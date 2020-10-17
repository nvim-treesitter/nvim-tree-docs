(module nvim-tree-docs.template
  {require {core aniseed.core
            utils nvim-tree-docs.utils
            collectors nvim-tree-docs.collector}})

(local ts-utils (require "nvim-treesitter.ts_utils"))

(def loaded-specs {})

(defn mark [context line start-col end-line end-col tag?]
  (table.insert context.marks {: line
                               :line-offset context.start-line
                               : start-col
                               : end-col
                               : end-line
                               :tag tag?}))

(defn eval-content [context content ignore-col?]
  "Recursively evaluates a template form."
  (let [_type (type content)]
    (if (= _type :string)
      (context.add-token content ignore-col?)
      (= _type :table)
      (each [_ v (ipairs content)]
        (eval-content context v ignore-col?))
      (= _type :function)
      (eval-content context (content context) ignore-col?))))

(defn eval-and-mark [context content tag?]
  (let [line context.head-ln
        start-col context.head-col]
      (eval-content context content)
      (mark context line start-col context.head-ln context.head-col tag?)))

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

(defn add-token [context token ignore-col?]
  (when (not (has-tokens-at-head context))
    (if ignore-col?
      (tset context.tokens context.head-ln [])
      (add-token context (string.rep " " context.start-col) true)))
  (table.insert (. context.tokens context.head-ln) {:value token
                                                    :col context.head-col})
  (set context.head-col (+ context.head-col (length token)))
  (set context.last-token token))

(defn next-line [context]
  (when (has-tokens-at-head context)
    (set context.head-col context.start-col)
    (set context.head-ln (+ context.head-ln 1))))

(defn expand-content-lines [context]
  (let [head (core.first context.content)
        rest (core.rest context.content)]
    (when head
      (eval-content context head))
    (each [_ line (ipairs rest)]
      (next-line context)
      (eval-content context line true))))

(defn conf [context path default?]
  (utils.get path context.config default?))

(defn new-template-context [collector config options?]
  (let [options (or options? {})
        context (vim.tbl_extend
                  "keep"
                  {:tokens []
                   :content (or options.content [])
                   :head-ln 1
                   :head-col 0
                   : config
                   :start-col (or options.start-col 0)
                   :start-line (or options.start-line 1)
                   :bufnr (utils.get-bufnr options.bufnr)
                   :marks []}
                  collector)]
    (set context.iter iter)
    (set context.get-text (partial get-text context))
    (set context.eval-and-mark (partial eval-and-mark context))
    (set context.eval-content (partial eval-content context))
    (set context.mark (partial mark context))
    (set context.next-line (partial next-line context))
    (set context.expand-content-lines (partial expand-content-lines context))
    (set context.add-token (partial add-token context))
    (set context.conf (partial conf context))
    context))

(defn get-spec [lang spec]
  (let [key (.. lang "." spec)]
    (when (not (. loaded-specs key))
      (require (string.format "nvim-tree-docs.specs.%s.%s" lang spec)))
    (. loaded-specs key)))

(defn get-content-mark [context]
  (core.some #(= $2.tag "%content") context.marks))

(defn execute-template [collector template-fn config options?]
  (let [context (new-template-context collector config options?)]
    (template-fn context)
    context))

(defn context-to-lines [context col?]
  (let [col (or col? 0)]
    (core.map
      (fn [tokens]
        (core.reduce #(.. $1 $2.value) "" tokens))
      context.tokens)))

(defn extend-spec [mod spec]
  (when spec
    (do
      (require (.. "nvim-tree-docs.specs." spec))
      (let [inherited-spec (. loaded-specs spec)]
        (tset mod :templates (vim.tbl_extend "force"
                                         mod.templates
                                         (-> loaded-specs (. spec) (. :templates))))
        (tset mod :utils (vim.tbl_extend "force"
                                     mod.utils
                                     (-> loaded-specs (. spec) (. :utils))))
        (tset mod :inherits inherited-spec)
        (tset mod :config (utils.merge-tbl inherited-spec.config mod.config))))))

