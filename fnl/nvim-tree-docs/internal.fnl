(module nvim-tree-docs.internal
  {require {utils nvim-tree-docs.utils
            core aniseed.core
            templates nvim-tree-docs.template
            collectors nvim-tree-docs.collector}})

(local configs (require "nvim-treesitter.configs"))
(local queries (require "nvim-treesitter.query"))
(local ts-utils (require "nvim-treesitter.ts_utils"))

(def- language-specs {:javascript :jsdoc
                      :lua :lua
                      :typescript :tsdoc})

(def- doc-cache {})

(defn get-spec-for-lang [lang]
  (let [spec (. language-specs lang)]
    (when (not spec)
      (error (string.format "No language spec configured for %s" lang)))
    spec))

(defn get-spec-for-buf [bufnr?]
  (let [bufnr (or bufnr? (vim.api.nvim_get_current_buf))]
    (get-spec-for-lang (vim.api.nvim_buf_get_option bufnr :ft))))


(defn generate-docs [data-list bufnr? lang?]
  (let [bufnr (utils.get-bufnr bufnr?)
        lang (or lang? (vim.api.nvim_buf_get_option bufnr :ft))
        spec (templates.get-spec lang (get-spec-for-lang lang))
        edits []
        marks []]
    (each [_ doc-data (ipairs data-list)]
      (let [(node-sr node-sc) (utils.get-start-position doc-data)
            (node-er node-ec) (utils.get-end-position doc-data)
            content-lines (utils.get-buf-content node-sr node-sc node-er node-ec bufnr)
            context (templates.execute-template
                      doc-data
                      (-?> spec (. :templates) (. doc-data.kind))
                      {:content content-lines
                       : bufnr
                       :start-line node-sr
                       :start-col node-sc})
            lines (templates.context-to-lines context node-sc)]
        ; (print (vim.inspect context))
        (table.insert edits {:newText (table.concat lines "\n")
                             :range
                              {:start {:line node-sr :character node-sc}
                               :end {:line node-er :character node-ec}}})
        (vim.list_extend marks context.marks)))
    (vim.lsp.util.apply_text_edits edits bufnr)
    ; Uncomment to test mark positions.
    ; (utils.highlight-marks marks bufnr)
    ))

(defn collect-docs [bufnr?]
  (let [bufnr (utils.get-bufnr bufnr?)]
    (if (= (-?> doc-cache (. bufnr) (. :tick))
           (vim.api.nvim_buf_get_changedtick bufnr))
      (-> doc-cache (. bufnr) (. :docs))
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

(defn get-docs-in-range [start-line end-line bufnr?]
  (let [doc-data (collect-docs bufnr?)
        result []]
    (each [item (collectors.iterate-collector doc-data)]
      (let [{:entry _def} item
            start-r (utils.get-start-position _def)
            end-r (utils.get-end-position _def)]
        (when (and (>= start-r start-line) (<= end-r end-line))
          (table.insert result _def))))
    result))

(defn get-docs-from-selection []
  (let [(_ start _ _) (unpack (vim.fn.getpos "'<"))
        (_ end _ _) (unpack (vim.fn.getpos "'>"))]
    (get-docs-in-range (- start 1) (- end 1))))

(defn doc-all-in-range []
  (-> (get-docs-from-selection)
      (generate-docs)))

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
