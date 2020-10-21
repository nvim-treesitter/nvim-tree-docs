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
                    :config (vim.tbl_deep_extend
                              "force"
                              {:slots {}
                               :processors {}}
                              ,(or config.config {}))
                    :inherits nil
                    :spec ,(tostring config.spec)
                    :lang ,(tostring config.lang)
                    :module mod-name#}]
       (template-mod#.extend-spec module# :base.base)
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
  The kind correlates with the query matches."
  (let [slots (let [results []]
                (each [_ slot (ipairs [...])]
                  (table.insert results (tostring slot)))
                results)]
    `(tset (. ,modsym :templates) ,(tostring kind) ,slots)))

(fn %= [key tbl default]
  "Get a nodes text content. A key is provided and will
  access the root context or the provided table."
  `($.get-text (. ,(or tbl `$) ,(tostring key)) ,default))

(fn %> [util-name ...]
  "Invokes a util function on this specification.
  This will invoke any inherited utils as well."
  `((. (. ,modsym :utils) ,(tostring util-name)) ,...))

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

(fn post-processor [name bindings ...]
  `(tset (. ,modsym :post-processors) ,name (fn ,bindings ,...)))

(fn log [...]
  `(let [result# ,...]
     (print (vim.inspect result#))
     result#))

{: template
 : util
 : %=
 : %>
 : log
 : post-processor
 : processor
 : doc-spec}
