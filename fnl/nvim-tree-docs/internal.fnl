(module nvim-tree-docs.internal
  {require {utils nvim-tree-docs.utils
            core aniseed.core
            templates nvim-tree-docs.template
            collectors nvim-tree-docs.collector}})

(local configs (require "nvim-treesitter.configs"))
(local queries (require "nvim-treesitter.query"))
(local ts-utils (require "nvim-treesitter.ts_utils"))

(def- language-specs {:javascript :jsdoc
                      :lua :luadoc
                      :typescript :tsdoc})

(def- doc-cache {})

(defn get-spec-for-lang [lang]
  (let [spec (. language-specs lang)]
    (when (not spec)
      (error (string.format "No language spec configured for %s" lang)))
    spec))

(defn get-spec-config [lang spec]
  (let [spec-def (templates.get-spec lang spec)
        module-config (configs.get_module :tree_docs)
        spec-default-config spec-def.config
        lang-config (utils.get [:lang_config lang spec] module-config {})
        spec-config (utils.get [:spec_config spec] module-config {})]
    (vim.tbl_deep_extend :force spec-default-config spec-config lang-config)))

(defn get-spec-for-buf [bufnr?]
  (let [bufnr (or bufnr? (vim.api.nvim_get_current_buf))]
    (get-spec-for-lang (vim.api.nvim_buf_get_option bufnr :ft))))

(defn generate-docs [data-list bufnr? lang?]
  (let [bufnr (utils.get-bufnr bufnr?)
        lang (or lang? (vim.api.nvim_buf_get_option bufnr :ft))
        spec-name (get-spec-for-lang lang)
        spec (templates.get-spec lang spec-name)
        spec-config (get-spec-config lang spec-name)
        edits []
        marks []]
    ; Guarantee that docs are from the top down.
    (table.sort data-list #(let [(_ _ start-byte-a) (utils.get-start-position $1)
                                  (_ _ start-byte-b) (utils.get-start-position $2)]
                                 (< start-byte-a start-byte-b)))
    (var line-offset 0)
    (each [_ doc-data (ipairs data-list)]
      (let [(node-sr node-sc) (utils.get-start-position doc-data)
            (node-er node-ec) (utils.get-end-position doc-data)
            content-lines (utils.get-buf-content node-sr node-sc node-er node-ec bufnr)
            replaced-count (- (+ node-er 1) node-sr)
            result (templates.process-template
                      doc-data
                      {: spec
                       : bufnr
                       :config spec-config
                       :start-line (+ node-sr line-offset)
                       :start-col node-sc
                       :kind doc-data.kind
                       :content content-lines})]
        (table.insert edits {:newText (.. (table.concat result.content "\n") "\n")
                             :range
                              {:start {:line node-sr :character 0}
                               :end {:line (+ node-er 1) :character 0}}})
        (vim.list_extend marks result.marks)
        (set line-offset (- (+ line-offset (length result.content)) replaced-count))))
    (vim.lsp.util.apply_text_edits edits bufnr)))
    ; Uncomment to test marks
    ;(utils.highlight-marks marks bufnr)))

(defn collect-docs [bufnr?]
  (let [bufnr (utils.get-bufnr bufnr?)]
    (if (= (utils.get [bufnr :tick] doc-cache)
           (vim.api.nvim_buf_get_changedtick bufnr))
      (utils.get [bufnr :docs] doc-cache)
      (let [collector (collectors.new-collector)
            doc-matches (queries.collect_group_results bufnr :docs)]
        (each [_ item (ipairs doc-matches)]
          (each [kind _match (pairs item)]
            (collectors.add-match collector kind _match)))
        (tset doc-cache bufnr {:tick (vim.api.nvim_buf_get_changedtick bufnr)
                               :docs collector})
        collector))))

(defn get-doc-data-for-node [node bufnr?]
  (var current nil)
  (var last-start nil)
  (var last-end nil)
  (let [doc-data (collect-docs bufnr?)
        (_ _ node-start) (node:start)]
    (each [iter-item (collectors.iterate-collector doc-data)]
      (var is-more-specific true)
      (let [{:entry doc-def} iter-item
            (_ _ start) (utils.get-start-position doc-def)
            (_ _ end) (utils.get-end-position doc-def)
            is-in-range (and (>= node-start start)
                             (< node-start end))]
        (when (and last-start last-end)
          (set is-more-specific (and (>= start last-start) (<= end last-end))))
        (when (and is-in-range is-more-specific)
          (do
            (set last-start start)
            (set last-end end)
            (set current doc-def)))))
    current))

(defn doc-node [node bufnr? lang?]
  (if node
    (let [doc-data (get-doc-data-for-node node bufnr?)]
      (generate-docs [doc-data] bufnr? lang?))))

(defn doc-node-at-cursor []
  (doc-node (ts-utils.get_node_at_cursor)))

(defn get-docs-from-position [args]
  (let [{: start-line
         : end-line
         : position
         :inclusion inclusion?
         :bufnr bufnr?} args
        is-edit-type? (= position :edit)
        doc-data (collect-docs bufnr?)
        result []]
    (each [item (collectors.iterate-collector doc-data)]
      (let [{:entry _def} item
            start-r (if is-edit-type?
                      (utils.get-edit-start-position _def)
                      (utils.get-start-position _def))
            end-r (if is-edit-type?
                    (utils.get-edit-end-position _def)
                    (utils.get-end-position _def))]
        (when (if inclusion?
                (and (>= start-line start-r) (<= end-line end-r))
                (and (>= start-r start-line) (<= end-r end-line)))
          (table.insert result _def))))
    result))

(defn get-docs-in-range [args]
  (get-docs-from-position (vim.tbl_extend
                            "force"
                            args
                            {:inclusion false :position nil})))

(defn get-docs-at-range [args]
  (get-docs-from-position (vim.tbl_extend
                            "force"
                            args
                            {:inclusion true :position :edit})))

(defn get-docs-from-selection []
  (let [(_ start _ _) (unpack (vim.fn.getpos "'<"))
        (_ end _ _) (unpack (vim.fn.getpos "'>"))]
    (get-docs-in-range {:start-line (- start 1)
                        :end-line (- end 1)})))

(defn doc-all-in-range []
  (-> (get-docs-from-selection)
      (generate-docs)))

(defn edit-doc-at-cursor []
  (let [[row] (vim.api.nvim_win_get_cursor 0)
        doc-data (get-docs-at-range {:start-line (- row 1)
                                     :end-line (- row 1)})
        lang (or lang? (vim.api.nvim_buf_get_option bufnr :ft))
        spec-name (get-spec-for-lang lang)]
    (print (vim.inspect doc-data))))

(defn attach [bufnr?]
  (let [bufnr (utils.get-bufnr bufnr?)
        config (configs.get_module :tree_docs)]
    (each [_fn mapping (pairs config.keymaps)]
      (var mode :n)
      (when (= _fn :doc_all_in_range)
        (set mode :v))
      (when mapping
        (vim.api.nvim_buf_set_keymap
          bufnr
          mode
          mapping
          (string.format ":lua require 'nvim-tree-docs.internal'.%s()<CR>" _fn)
          {:silent true})))))

(defn detach [bufnr?]
  (let [bufnr (utils.get-bufnr bufnr?)
        config (configs.get_module :tree_docs)]
    (each [_fn mapping (pairs config.keymaps)]
      (var mode :n)
      (when (= _fn :doc_all_in_range)
        (set mode :v))
      (when mapping
        (vim.api.nvim_buf_del_keymap bufnr mode mapping)))))

; Export these as snake case for configuration purposes.
(def doc_node_at_cursor doc-node-at-cursor)
(def doc_node doc-node)
(def doc_all_in_range doc-all-in-range)
(def edit_doc_at_cursor edit-doc-at-cursor)
