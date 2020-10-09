(module nvim-tree-docs.main)

(local queries (require "nvim-treesitter.query"))

(defn init []
  (->>
    {:tree_docs {:module_path "nvim-tree-docs.internal"
                 :keymaps {:doc_node_at_cursor "gdd"
                           :doc_all_in_range "gdd"}
                 :is_supported #(not= (queries.get_query $1 :docs) nil)}}
    (require "nvim-treesitter")))
