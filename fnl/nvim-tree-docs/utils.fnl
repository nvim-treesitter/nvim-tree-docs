(module nvim-tree-docs.utils
  {require {core aniseed.core}})

(defn get-start-node [entry]
  (if (and entry.start_point entry.start_point.node)
    entry.start_point.node
    (and entry.definition entry.definition.node)
    entry.definition.node
    nil))

(defn get-end-node [entry]
  (if (and entry.end_point entry.end_point.node)
    entry.end_point.node
    (and entry.definition entry.definition.node)
    entry.definition.node
    nil))
