(module nvim-tree-docs.utils
  {require {core aniseed.core}})

(def ns (vim.api.nvim_create_namespace "blorg"))

(defn get-start-node [entry]
  (or (-?> entry (. :start_point) (. :node))
      (-?> entry (. :definition) (. :node))))

(defn get-end-node [entry]
  (or (-?> entry (. :end_point) (. :node))
      (-?> entry (. :definition) (. :node))))

(defn get-bufnr [bufnr]
  (or bufnr (vim.api.nvim_get_current_buf)))

(defn get-buf-content [start-row start-col end-row end-col bufnr]
  (let [result (vim.api.nvim_buf_get_lines bufnr start-row (+ end-row 1) false)]
    (when (> (length result) 0)
      (when (not= start-col 0)
        (tset result 1 (string.sub (. result 1) (+ start-col 1))))
      (when (not= end-col 0)
        (tset result
              (length result)
              (string.sub (. result (length result))
                          1
                          (+ end-col 1)))))
    result))

(defn highlight-marks [marks bufnr]
  (each [_ mark (ipairs marks)]
    (let [start-line (+ (- mark.line 1) mark.line-offset)
          end-line (+ (- mark.end-line 1) mark.line-offset)]
      (vim.highlight.range bufnr ns "Visual" [start-line mark.start-col] [end-line mark.end-col]))))
