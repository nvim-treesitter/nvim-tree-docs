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
                      :typescript :jsdoc})

(defn get-spec-for-lang [lang]
  (let [spec (. language-specs lang)]
    (when (not spec)
      (error (string.format "No language spec configured for %s" lang)))
    spec))

(defn get-spec-for-buf [bufnr?]
  (let [bufnr (or bufnr? (vim.api.nvim_get_current_buf))]
    (get-spec-for-lang (vim.api.nvim_buf_get_option bufnr :ft))))

(defn generate-docs [data-list bufnr?]
  (let [bufnr (utils.get-bufnr bufnr?)
        lang (vim.api.nvim_buf_get_option bufnr :ft)
        spec (templates.get-spec lang (get-spec-for-lang lang))
        edits []]
    (each [_ doc-data (ipairs data-list)]
      (let [(node-sr node-sc) (-> (utils.get-start-node doc-data) (: :start))
            (node-er node-ec) (-> (utils.get-end-node doc-data) (: :end_))
            context (templates.execute-template doc-data (. spec doc-data.kind))
            content-lines (ts-utils.get_node_text doc-data bufnr)
            lines (templates.context-to-lines context content-lines node-sc)]
        (table.insert edits {:newText (table.concat lines "\n")
                             :range
                              {:start {:line node-sr :character 0}
                               :end {:line node-er :character node-ec}}})))
    (vim.lsp.util.apply_text_edits edits bufnr)))

; (defn doc-node [node bufnr?]
;   (let [bufnr (utils.get-bufnr bufnr?)]
;     ()))

; (defn doc-node-at-cursor []
;   (doc-node (ts-utils.get_node_at_cursor)))
