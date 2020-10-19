(module nvim-tree-docs.utils
  {require {core aniseed.core}})

(import-macros {: log} "fnl.nvim-tree-docs.macros")

(def ns (vim.api.nvim_create_namespace "blorg"))

(defn get-start-node [entry]
  (or (-?> entry (. :start_point) (. :node))
      (-?> entry (. :definition) (. :node))))

(defn get-end-node [entry]
  (or (-?> entry (. :end_point) (. :node))
      (-?> entry (. :definition) (. :node))))

(defn get-position [key default-position entry]
  (let [explicit-entry (. entry key)
        {: node : position} (if (and (= (type explicit-entry) :table) explicit-entry.node)
                              {:node explicit-entry.node
                               :position (or explicit-entry.position default-position)}
                              {:node entry.definition.node
                               :position default-position})]
    (if (= position :start) (node:start) (node:end_))))

(def get-start-position (partial get-position :start_point :start))
(def get-end-position (partial get-position :end_point :end))

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
                          end-col))))
    result))

(defn highlight-marks [marks bufnr]
  (each [_ mark (ipairs marks)]
    (let [start-line (+ (- mark.line 1) mark.line-offset)
          end-line (+ (- mark.end-line 1) mark.line-offset)]
      (vim.highlight.range bufnr ns "Visual" [start-line mark.start-col] [end-line mark.end-col]))))

(defn get [path tbl default?]
  (let [segments (if (= (type path) :string)
                   (vim.split path "%.")
                   path)]
    (var result tbl)
    (each [_ segment (ipairs segments)]
      (if (= (type result) :table)
        (set result (. result segment))
        (set result nil)))
    (if (= result nil) default? result)))

(defn make-inverse-list [tbl]
  (let [result {}]
    (each [i v (ipairs tbl)]
      (tset result v i))
    result))

(defn get-all-truthy-keys [tbl]
  (let [result []]
    (each [k v (pairs tbl)]
      (when v (table.insert result k)))
    result))
