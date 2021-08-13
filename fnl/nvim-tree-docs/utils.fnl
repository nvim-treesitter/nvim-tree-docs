(module nvim-tree-docs.utils
  {require {core nvim-tree-docs.aniseed.core}})

(def ns (vim.api.nvim_create_namespace "blorg"))

(defn get-start-node [entry]
  (or (-?> entry (. :start_point) (. :node))
      (-?> entry (. :definition) (. :node))))

(defn get-end-node [entry]
  (or (-?> entry (. :end_point) (. :node))
      (-?> entry (. :definition) (. :node))))

(defn get-position [keys default-position entry]
  (var i 1)
  (var result nil)
  (while (and (not result) (<= i (length keys)))
    (let [key (. keys i)
          match? (. entry key)
          has-match? (and (core.table? match?) match?.node)
          position? (if has-match? (or match?.position default-position) nil)]
      (if has-match?
        (set result (if (= position? :start)
                      [(match?.node:start)]
                      [(match?.node:end_)]))))
    (set i (core.inc i)))
  (unpack result))

(def get-start-position (partial get-position [:start_point :definition] :start))
(def get-end-position (partial get-position [:end_point :definition] :end))
(def get-edit-start-position (partial get-position [:edit_start_point :start_point :definition] :start))
(def get-edit-end-position (partial get-position [:edit_end_point :end_point :definition] :end))

(defn get-bufnr [bufnr]
  (or bufnr (vim.api.nvim_get_current_buf)))

(defn get-buf-content [start-row start-col end-row end-col bufnr]
  (vim.api.nvim_buf_get_lines bufnr start-row (+ end-row 1) false))

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

(defn func? [v] (= (type v) :function))
(defn method? [v key] (and (= (type v) :table)
                           (= (type (. v key)) :function)))

(defn highlight-marks [marks bufnr]
  (each [_ mark (ipairs marks)]
    (let [line (- mark.line 1)]
      (vim.highlight.range bufnr ns "Visual" [line mark.start] [line mark.stop]))))
