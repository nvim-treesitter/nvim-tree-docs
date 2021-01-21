(module nvim-tree-docs.template
  {require {core aniseed.core
            utils nvim-tree-docs.utils
            collectors nvim-tree-docs.collector}})

(local ts-utils (require "nvim-treesitter.ts_utils"))
(import-macros {: log} "nvim-tree-docs.macros")

(def loaded-specs {})

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

(defn conf [context path default?]
  (utils.get path context.config default?))

(defn empty? [collector]
  (collectors.is-collector-empty collector))

(defn build-line [...]
  "Builds a line of content while capturing any marks that are defined"
  (let [result {:content "" :marks []}
        add-content #(set result.content (.. result.content $))]
    (each [_ value (ipairs [...])]
      (if (core.string? value)
        (add-content value)
        (and (core.table? value) (core.string? value.content))
        (if value.mark
          (let [start (length result.content)]
            (add-content value.content)
            (table.insert result.marks {:kind value.mark
                                        :stop (+ (length value.content) start)
                                        : start}))
          (add-content value.content))))
    result))

(defn new-template-context [collector options?]
  (let [options (or options? {})
        context (vim.tbl_extend
                  "keep"
                  {: iter
                   : empty?
                   :build build-line
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

(defn get-spec [lang spec]
  (let [key (.. lang "." spec)]
    (when (not (. loaded-specs key))
      (require (string.format "nvim-tree-docs.specs.%s.%s" lang spec)))
    (. loaded-specs key)))

(defn- normalize-processor [processor]
  (if (utils.func? processor)
    {:build processor}
    processor))

(defn- get-processor [processors name aliased-from?]
  (let [processor-config (. processors name)]
    (if (core.string? processor-config)
      (get-processor processors processor-config (or aliased-from? name))
      (let [result (-> (or processor-config processors.__default)
                       (normalize-processor))]
        {:processor result :name name :aliased-from aliased-from?}))))

(defn get-expanded-slots [ps-list slot-config processors]
  (let [result [(unpack ps-list)]]
    (var i 1)
    (while (<= i (length result))
      (let [ps-name (. result i)
            {: processor} (get-processor processors ps-name)]
        (if (and processor processor.expand)
          (let [expanded (processor.expand
                           (utils.make-inverse-list result)
                           slot-config)]
            (table.remove result i)
            (each [j expanded-ps (ipairs expanded)]
              (table.insert result (- (+ i j) 1) expanded-ps))))
        (set i (+ i 1))))
    result))

(defn get-filtered-slots [ps-list processors slot-config context]
  (->>
    (core.map #(get-processor processors $) ps-list)
    (core.filter #(and $.processor
                       (or $.processor.implicit
                           (. slot-config (or $.aliased-from $.name)))))
    (core.map #(let [include-ps (if (utils.method? $.processor :when)
                                    ($.processor.when context)
                                    (core.table? $.processor))]
                 (if include-ps $.name nil)))
    (core.filter #(not= $ nil))))

(defn normalize-build-output [output]
  (if (core.string? output)
    [{:content output :marks []}]
    (core.table? output)
    (if (core.string? output.content)
      [output]
      (core.map #(if (core.string? $)
                   {:content $ :marks []}
                   $)
                output))))

(defn indent-lines [lines indenter context]
  (let [indentation-amount (if (utils.func? indenter)
                             (indenter lines context)
                             context.start-col)]
    (core.map (fn [line]
                (vim.tbl_extend
                 "force"
                 {}
                 {:content (.. (string.rep " " indentation-amount) line.content)
                  :marks (core.map
                           #(vim.tbl_extend
                              "force"
                              $
                              {:start (+ $.start indentation-amount)
                               :stop (+ $.stop indentation-amount)})
                           line.marks)}))
              lines)))

(defn build-slots [ps-list processors context]
  (let [result []]
    (each [i ps-name (ipairs ps-list)]
      (let [{: processor} (get-processor processors ps-name)
            default-processor processors.__default
            build-fn (or (-?> processor (. :build))
                         (-?> default-processor (. :build)))
            indent-fn (or (-?> processor (. :indent))
                          (-?> default-processor (. :indent)))]
        (table.insert
          result
          (if (utils.func? build-fn)
            (-> (build-fn context {:processors ps-list
                                   :index i
                                   :name ps-name})
                (normalize-build-output)
                (indent-lines indent-fn context))
            []))))
    result))

(defn output-to-lines [output]
  (core.reduce #(vim.list_extend $1 $2) [] output))

(defn package-build-output [output context]
  (let [result {:content [] :marks []}]
    (each [i entry (ipairs output)]
      (each [j line (ipairs entry)]
        (let [lnum (+ (length result.content) 1)]
          (table.insert result.content line.content)
          (vim.list_extend result.marks (core.map #(vim.tbl_extend
                                                     "force"
                                                     {}
                                                     $
                                                     {:line (+ lnum
                                                               (or context.start-line 0))})
                                                  line.marks)))))
    result))

(defn process-template [collector config]
  (let [{: spec : kind :config spec-conf} config
        ps-list (or (-?> spec-conf (. :templates) (. kind))
                    (. spec.templates kind))
        processors (vim.tbl_extend
                     "force"
                     spec.processors
                     (or spec-conf.processors {}))
        slot-config (or (-?> spec-conf.slots (. kind)) {})
        context (new-template-context collector config)]
    (-> ps-list
        (get-expanded-slots slot-config processors)
        (get-filtered-slots processors slot-config context)
        (build-slots processors context)
        (package-build-output context))))

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

