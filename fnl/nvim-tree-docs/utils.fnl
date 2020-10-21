(module nvim-tree-docs.utils
  {require {core aniseed.core}})

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
