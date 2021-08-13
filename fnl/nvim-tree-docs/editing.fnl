(module nvim-tree-docs.editing
  {autoload {ts-utils nvim-treesitter.ts_utils
             tsq vim.treesitter.query}})

(def- ns (vim.api.nvim_create_namespace "doc-edit"))

(defn get-doc-comment-data [args]
  (let [{: lang
         : doc-lang
         : node
         : bufnr} args
        doc-lines (ts-utils.get_node_text node bufnr)
        doc-string (table.concat doc-lines "\n")
        parser (vim.treesitter.get_string_parser doc-string doc-lang)
        query (tsq.get_query doc-lang :edits)
        iter (query:iter_matches
               (-> (parser:parse) (: :root))
               doc-string
               1
               (+ (length doc-string) 1))
        result {}]
    (var item [(iter)])
    (while (. item 1)
      (let [[pattern-id matches] item]
        (each [id match-node (pairs matches)]
          (let [match-name (. query.captures id)]
            (when (not (. result match-name))
              (tset result match-name []))
            (table.insert (. result match-name) match-node)))
        (set item [(iter)])))
    result))

(defn edit-doc [args]
  (let [{: bufnr :node doc-node} args
        {: edit} (get-doc-comment-data args)
        (sr) (doc-node:range)]
    (vim.api.nvim_buf_clear_namespace bufnr ns 0 -1)
    (each [_ node (ipairs edit)]
      (let [(dsr dsc der dec) (node:range)]
        (ts-utils.highlight_range
          [(+ dsr sr ) dsc (+ der sr) dec]
          bufnr
          ns
          :Visual)))))
