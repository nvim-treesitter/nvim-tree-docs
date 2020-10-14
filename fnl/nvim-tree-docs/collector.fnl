(module nvim-tree-docs.collector)

(local collector-metatable
  {:__index (fn [tbl key]
              (if (= (type key) :number)
                  (let [id (. tbl.__order key)]
                    (if id (. tbl.__entries id) nil))
                  (rawget tbl key)))})

(defn new-collector []
  (setmetatable {:__entries {}
                 :__order {}}
                collector-metatable))

(defn is-collector [value]
  (and (= (type value) :table)
       (= (type value.__entries) :table)))

(defn is-collector-empty [collector]
  (= (length collector.__order) 0))

(defn iterate-collector [collector]
  (var i 1)
  (fn []
    (let [id (. collector.__order i)]
      (if id
          (do
            (set i (+ i 1))
            {:index (- i 1)
             :entry (. collector.__entries id)})
          nil))))

(defn get-node-id [node]
  (let [(srow scol erow ecol) (node:range)]
    (string.format "%d_%d_%d_%d" srow scol erow ecol)))

(defn collect [collector entry _match key add-fn]
  (if _match.definition
    (do
      (when (not (. entry key))
        (tset entry key (new-collector)))
      (-> (. entry key)
          (add-fn key _match collect)))
    (not (. entry key))
    (tset entry key _match)
    (and (= key :start_point) _match.node)
    (let [(_ _ current-start) (-> (. entry key) (. :node) (: :start))
          (_ _ new-start) (-> (. _match :node) (: :start))]
      (when (< new-start current-start)
        (tset entry key _match)))
    (and (= key :end_point) _match.node)
    (let [(_ _ current-end) (-> (. entry key) (. :node) (: :end_))
          (_ _ new-end) (-> (. _match :node) (: :end_))]
      (when (> new-end current-end)
        (tset entry key _match)))))

(defn add-match [collector kind _match]
  (if (and _match _match.definition)
    (let [_def _match.definition
          def-node _def.node
          node-id (get-node-id def-node)]
      (when (not (. collector.__entries node-id))
        (var order-index 1)
        (let [(_ _ def-start-byte) (def-node:start)]
          (var done false)
          (var i 1)
          (while (not done)
            (local entry (. collector.__entries i))
            (if (not entry)
              (set done true)
              (let [(_ _ start-byte) (entry.defintion.node:start)]
                (if (< def-start-byte start-byte)
                  (set done true)
                  (set order-index (+ order-index 1))))))
          (table.insert collector.__order order-index node-id)
          (tset collector.__entries node-id {:kind kind :definition _def})))
      (each [key submatch (pairs _match)]
        (when (not= key :definition)
          (collect collector (. collector.__entries node-id) submatch key add-match))))))

