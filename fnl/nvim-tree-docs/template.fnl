(module nvim-tree-docs.template
  {require {core aniseed.core
            collectors nvim-tree-docs.collector}})

(local ts-utils (require "nvim-treesitter.ts_utils"))

(def loaded-specs {})

(defn mark [context line start-col end-col]
  (table.insert context.marks {: line
                               : start-col
                               : end-col}))

(defn eval-content [context content]
  "Recursively evaluates a template form. The result should always be a string."
  (let [_type (type content)]
    (if (= _type :string)
      (context.add-token content)
      (= _type :table)
      (each [_ v (ipairs content)]
        (eval-content context v))
      (= _type :function)
      (eval-content context (content context)))))

(defn eval-and-mark [context content]
  (let [line context.head-ln
        start-col context.head-col]
      (eval-content context content)
      (mark context line start-col context.head-col)))

(defn get-text [context node default multi]
  (let [default-value (or default "")]
    (if (and node (= (type node) :table))
      (let [tsnode (if node.node node.node node)
            lines (ts-utils.get_node_text tsnode)]
        (if multi
          lines
          (let [line (. lines 1)]
            (if (not= line "") line default-value))))
      default-value)))

(defn iter [collector]
  (if collector (collectors.iterate-collector collector) #nil))

(defn any [matches]
  (core.reduce #(if $1
                  true
                  (let [is-collector (collectors.is-collector $2)]
                    (or (and is-collector (not (collectors.is-collector-empty $2)))
                        (and (not is-collector) $2))))
               false
               matches))

(defn has-tokens-at-line [context line]
  (= (type (. context.tokens line)) :table))

(defn has-tokens-at-head [context]
  (has-tokens-at-line context context.head-ln))

(defn add-token [context token]
  (when (not (has-tokens-at-head context))
    (tset context.tokens context.head-ln []))
  (table.insert (. context.tokens context.head-ln) {:value token
                                                    :col context.head-col})
  (set context.head-col (+ context.head-col (length token)))
  (set context.last-token token))

(defn next-line [context]
  (when (has-tokens-at-head context)
    (set context.head-col 0)
    (set context.head-ln (+ context.head-ln 1))))

(defn new-template-context [collector]
  (let [context {:tokens []
                 :head-ln 1
                 :head-col 0
                 :marks []}]
    (set context.iter iter)
    (set context.get-text (partial get-text context))
    (set context.eval-and-mark (partial eval-and-mark context))
    (set context.eval-content (partial eval-content context))
    (set context.mark (partial mark context))
    (set context.next-line (partial next-line context))
    context))

; ; (defn get-spec [])
