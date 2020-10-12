(module nvim-tree-docs.utils
  {require {core aniseed.core}})

(defn get-start-node [entry]
  (or (-?> entry (. :start_point) (. :node))
      (-?> entry (. :definition) (. :node))))

(defn get-end-node [entry]
  (or (-?> entry (. :end_point) (. :node))
      (-?> endry (. :end_point) (. :node))))

(defn get-bufnr [bufnr]
  (or bufnr (vim.api.nvim_get_current_buf)))
