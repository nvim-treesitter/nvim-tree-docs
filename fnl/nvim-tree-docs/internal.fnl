(module nvim-tree-docs.internal
  {require {utils nvim-tree-docs.utils
            collectors nvim-tree-docs.collector}})

(local configs (require "nvim-treesitter.configs"))
(local queries (require "nvim-treesitter.query"))
(local ts-utils (require "nvim-treesitter.ts_utils"))

(defn doc-node [])

(defn doc-node-at-cursor []
  (doc-node (ts-utils.get_node_at_cursor)))
