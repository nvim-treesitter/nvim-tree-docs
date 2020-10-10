(module nvim-tree-docs.template
  {require {core aniseed.core
            collectors nvim-tree-docs.collector}})

(def loaded-specs {})

(defn eval-content [context content]
  "Recursively evaluates a template form. The result should always be a string."
  (let [_type (type content)]
    (if (= _type :string)
      content
      (= _type :table)
      (core.reduce #(.. $1 (if (= $1 "") "" " ") (eval-content context $2)) "" content)
      (= _type :function)
      (eval-content context (content context))
      "")))

; (defn get-text [context tbl key])
; (defn for-each [context collector-or-list])

(defn new-template-context []
  (let [context {}]
    context))

(defn get-spec [])
