(local modsym (gensym))

(fn doc-spec [config]
  "Defines a documentation specification"
  (assert config.lang "A language is required")
  (assert config.spec "A specification name is required")
  `(local ,modsym
     (let [mod-name# (.. ,(tostring config.lang) "." ,(tostring config.spec))
           template-mod# (require "nvim-tree-docs.template")
           module# {:templates {}
                    :utils {}
                    :processors {}
                    :config ,(or config.config {})
                    :inherits nil
                    :spec ,(tostring config.spec)
                    :lang ,(tostring config.lang)}]
       (template-mod#.extend-spec module# ,(if config.extends (tostring config.extends) nil))
       (tset (. template-mod# :loaded-specs)
             mod-name#
             module#)
       module#)))

(fn util [name parameters ...]
  "Defines a util function as part of this specification.
  These can be used in templates as well as any specification
  That extends this specification."
  `(tset (. ,modsym :utils) ,(tostring name) (fn ,parameters ,...)))

(fn template [kind ...]
  "Defines a template for a given 'kind'.
  The kind correlates with the query matches.
  All other forms are considered a single line in the resulting documentation.
  A vector can be given to evaluate multiple expressions in a single line.
  If a function is given, it will be called with the context object.
  These expressions are evaluated recursively. For example, a vector that
  contains a function will get invoked and the result will be used."
  `(tset (. ,modsym :templates) ,(tostring kind)
     (fn [context#]
       (each [i# line# (ipairs ,[...])]
         (context#.eval-content line# (= i# 1))
         (context#.next-line))
       context#)))

(fn %^ [form tag?]
  "Marks an expression and it's position.
  These marks can be used to mark the positions in the
  resulting documentation."
  `#($.eval-and-mark ,form ,tag?))

(fn %= [key tbl default]
  "Get a nodes text content. A key is provided and will
  access the root context or the provided table."
  `#($.get-text (. ,(or tbl `$) ,(tostring key)) ,default))

(fn %> [util-name ...]
  "Invokes a util function on this specification.
  This will invoke any inherited utils as well."
  `((. (. ,modsym :utils) ,(tostring util-name)) ,...))

(fn %content []
  "Marks the content point for content to be inserted in."
  `(%^ #($.expand-content-lines) "%content"))

(fn processor [...]
  (let [processor {}
        forms [...]
        has-name (not= (% (length forms) 2) 0)]
    (var hook nil)
    (var callback nil)
    (var name :__default)
    (when has-name
      (do
        (set name (. forms 1))
        (table.remove forms 1)))
    (each [_ form (ipairs forms)]
      (if hook
        (set callback form)
        (set hook (tostring form)))
      (if (and hook callback)
        (do
          (tset processor hook form)
          (set hook nil)
          (set callback nil))))
    `(tset (. ,modsym :processors) ,(tostring name) ,processor)))

(fn %each [vec ...]
  "Generates a form for each iterated item.
  Each item will be it's own line."
  (let [[binding iter] vec]
    `#(let [iterator# ,iter]
        (var ,binding (iterator#))
        (while ,binding
          ($.eval-content ,...)
          (set ,binding (iterator#))
          (when ,binding
            ($.next-line))))))

(fn %conf [context path default?]
  `((. ,context :conf) ,(if (sequence? path)
                    path
                    (tostring path)) ,default?))

(fn %when [condition consequence]
  `#(when ,condition ,consequence))

(fn %run [...]
  `#(do ,...  nil))

(fn %expand [...]
  `#(let [lines# ,...
          iter# (ipairs lines)]
      (var v# (iter#))
      (while v#
        ($.eval-content v#)
        (set v# (iter#))
        (when v#
          ($.next-line)))))

(fn log [...]
  `(let [result# ,...]
     (print (vim.inspect result#))
     result#))

{: template
 : util
 : %=
 : %^
 : %>
 : %content
 : %each
 : %conf
 : %when
 : %run
 : %expand
 : log
 : processor
 : doc-spec}
