(module nvim-tree-docs.template
  {require {core aniseed.core
            utils nvim-tree-docs.utils
            collectors nvim-tree-docs.collector}})

(local ts-utils (require "nvim-treesitter.ts_utils"))

(def loaded-specs {})

; (defn mark [context line start-col end-line end-col tag?]
;   (table.insert context.marks {: line
;                                :line-offset context.start-line
;                                : start-col
;                                : end-col
;                                : end-line
;                                :tag tag?}))

; (defn eval-content [context content ignore-col?]
;   "Recursively evaluates a template form."
;   (let [_type (type content)]
;     (if (= _type :string)
;       (context.add-token content ignore-col?)
;       (= _type :table)
;       (each [_ v (ipairs content)]
;         (eval-content context v ignore-col?))
;       (= _type :function)
;       (eval-content context (content context) ignore-col?))))

; (defn eval-and-mark [context content tag?]
;   (let [line context.head-ln
;         start-col context.head-col]
;       (eval-content context content)
;       (mark context line start-col context.head-ln context.head-col tag?)))

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

; (defn any [matches]
;   (core.reduce #(if $1
;                   true
;                   (let [is-collector (collectors.is-collector $2)]
;                     (or (and is-collector (not (collectors.is-collector-empty $2)))
;                         (and (not is-collector) $2))))
;                false
;                matches))

; (defn has-tokens-at-line [context line]
;   (= (type (. context.tokens line)) :table))

; (defn has-tokens-at-head [context]
;   (has-tokens-at-line context context.head-ln))

; (defn add-token [context token ignore-col?]
;   (when (not (has-tokens-at-head context))
;     (if ignore-col?
;       (tset context.tokens context.head-ln [])
;       (add-token context (string.rep " " context.start-col) true)))
;   (table.insert (. context.tokens context.head-ln) {:value token
;                                                     :col context.head-col})
;   (set context.head-col (+ context.head-col (length token)))
;   (set context.last-token token))

; (defn next-line [context]
;   (when (has-tokens-at-head context)
;     (set context.head-col context.start-col)
;     (set context.head-ln (+ context.head-ln 1))))

; (defn expand-content-lines [context]
;   (let [head (core.first context.content)
;         rest (core.rest context.content)]
;     (when head
;       (eval-content context head))
;     (each [_ line (ipairs rest)]
;       (next-line context)
;       (eval-content context line true))))

(defn conf [context path default?]
  (utils.get path context.config default?))

(defn empty? [collector]
  (collectors.is-collector-empty collector))

(defn new-template-context [collector options?]
  (let [options (or options? {})
        context (vim.tbl_extend
                  "keep"
                  {: iter
                   : empty?
                   :config options.config
                   :kind options.kind
                   :start-line (or options.start-line 0)
                   :start-col (or options.start-col 0)
                   :content (or options.content [])
                   :bufnr (utils.get-bufnr options.bufnr)}
                  collector)]
    (set context.get-text (partial get-text context))
    (set context.conf (partial conf context))
    context))

; (defn new-template-context [collector config options?]
;   (let [options (or options? {})
;         context (vim.tbl_extend
;                   "keep"
;                   {:tokens []
;                    :content (or options.content [])
;                    :head-ln 1
;                    :head-col 0
;                    :processors options.processors
;                    : config
;                    : iter
;                    : is-empty
;                    :start-col (or options.start-col 0)
;                    :start-line (or options.start-line 1)
;                    :bufnr (utils.get-bufnr options.bufnr)
;                    :marks []}
;                   collector)]
;     (set context.get-text (partial get-text context))
;     (set context.eval-and-mark (partial eval-and-mark context))
;     (set context.eval-content (partial eval-content context))
;     (set context.mark (partial mark context))
;     (set context.next-line (partial next-line context))
;     (set context.expand-content-lines (partial expand-content-lines context))
;     (set context.add-token (partial add-token context))
;     (set context.conf (partial conf context))
;     context))

(defn get-spec [lang spec]
  (let [key (.. lang "." spec)]
    (when (not (. loaded-specs key))
      (require (string.format "nvim-tree-docs.specs.%s.%s" lang spec)))
    (. loaded-specs key)))

; (defn get-content-mark [context]
;   (core.some #(= $2.tag "%content") context.marks))

; (defn execute-template [collector template-fn config options?]
;   (let [context (new-template-context collector config options?)]
;     (template-fn context)
;     context))

(defn- get-processor [processors name]
  (or (. processors name) processors.__default))

(defn get-expanded-slots [ps-list slot-config processors]
  (let [filter-from-conf (core.filter
                           #(let [ps (get-processor processors $)]
                             (and ps (or ps.implicit (. slot-config $))))
                           ps-list)
        result [(unpack filter-from-conf)]]
    (var i 1)
    (while (<= i (length result))
      (let [ps-name (. result i)
            processor (get-processor processors ps-name)]
        (if (and processor processor.expand)
          (let [expanded (processor.expand
                           (utils.make-inverse-list result)
                           slot-config)]
            (table.remove result i)
            (each [j expanded-ps (ipairs expanded)]
              (table.insert result (- (+ i j) 1) expanded-ps))))
        (set i (+ i 1))))
    result))

(defn get-filtered-slots [ps-list processors context]
  (core.filter #(let [ps (get-processor processors $)]
                  (if (utils.method? ps :when)
                    (ps.when context ps-list)
                    (core.table? ps)))
               ps-list))

(defn normalize-build-output [output]
  (if (core.string? output)
    [output]
    (core.table? output)
    output
    []))

(defn indent-with-processor [lines processor context ignore-first?]
  (if (utils.method? processor :indent)
    (processor.indent lines context)
    (let [result []]
      (each [i line (ipairs lines)]
        (table.insert
          result
          (if (and (= i 1) ignore-first?)
              line
              (.. (string.rep " " context.start-col) line))))
      result)))

(defn build-slots [ps-list processors context]
  (let [result []]
    (each [i ps-name (ipairs ps-list)]
      (let [processor (get-processor processors ps-name)
            default-processor processors.__default
            build-fn (or (-?> processor (. :build))
                         (-?> default-processor (. :build)))]
        (table.insert
          result
          (if (utils.func? build-fn)
            (-> (build-fn context {:processors ps-list
                                   :index i
                                   :name ps-name})
                (normalize-build-output)
                (indent-with-processor processor context false))
            []))))
    result))

(defn output-to-lines [output]
  (core.reduce #(vim.list_extend $1 $2) [] output))

; Not implemented yet
(defn post-process-output [output processors context]
  {:lines (output-to-lines output)
   :marks []})

;expand all processors (expand hook)
; get all processors from the configuration that are true
; filter the template list by these processors that aren't set to implicit true
; invoke the expand hook for each of these with a ps-index-list and the configuration
; create a template context
; filter the list by the when hook using the context
; loop over the resulting list of processor names and run the build hook
; flatten all resulting lines into a single list

(defn process-template [collector config]
  (let [{: spec : kind :config spec-conf} config
        ps-list (. spec.templates kind)
        processors (vim.tbl_extend
                     "force"
                     spec.processors
                     (or spec-conf.processors {}))
        slot-config (or (-?> spec-conf.slots (. kind)) {})
        context (new-template-context collector config)]
    (-> (. spec.templates kind)
        (get-expanded-slots slot-config processors)
        (get-filtered-slots processors context)
        (build-slots processors context)
        (post-process-output processors context))))

; (defn context-to-lines [context col?]
;   (let [col (or col? 0)]
;     (core.map
;       (fn [tokens]
;         (core.reduce #(.. $1 $2.value) "" tokens))
;       context.tokens)))

(defn extend-spec [mod spec]
  (when (and spec (not= mod.module spec))
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
        (tset mod :processors (vim.tbl_extend "force" mod.processors inherited-spec.processors))
        (tset mod :config (vim.tbl_deep_extend "force" inherited-spec.config mod.config))))))

