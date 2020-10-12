(module nvim-tree-docs.internal
  {require {utils nvim-tree-docs.utils
            core aniseed.core
            collectors nvim-tree-docs.collector}})

(local configs (require "nvim-treesitter.configs"))
(local queries (require "nvim-treesitter.query"))
(local ts-utils (require "nvim-treesitter.ts_utils"))

; (defn generate-docs [data-list bufnr?]
;   (let [bufnr (utils.get-bufnr bufnr?)
;         edits (core.reduce
;                 (fn [result doc-data]
;                   (let [(node-sr node-sc) (:start (utils.get-start-node doc-data))
;                         (node-er) (:end_ (utils.get-end-node doc-data))
;                         {:lines-above :lines-below} ()]
;                     ))
;                 []
;                 data-list)]))

; (defn doc-node [node bufnr?]
;   (let [bufnr (utils.get-bufnr bufnr?)]
;     ()))

; (defn doc-node-at-cursor []
;   (doc-node (ts-utils.get_node_at_cursor)))
