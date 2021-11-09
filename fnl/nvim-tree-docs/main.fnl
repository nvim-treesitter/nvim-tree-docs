(module nvim-tree-docs.main
  {autoload {queries nvim-treesitter.query
             ts nvim-treesitter}})

(defn init []
  (->> {:tree_docs {:module_path "nvim-tree-docs.internal"
                    :keymaps {:doc_node_at_cursor :gdd
                              :doc_all_in_range :gdd
                              :edit_doc_at_cursor :gde}
                    :is_supported #(not= (queries.get_query $1 :docs) nil)}}
       (ts.define_modules)))
