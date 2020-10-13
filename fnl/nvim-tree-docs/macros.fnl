(local modsym (gensym))

(fn doc-spec [config]
  "Defines a documentation specification"
  (assert config.lang "A language is required")
  (assert config.spec "A specification name is required")
  `(local ,modsym
     (let [mod-name# (.. ,(tostring config.lang) "_" ,(tostring config.spec))
           module# {:templates {}
                    :utils {}
                    :spec ,(tostring config.spec)
                    :lang ,(tostring config.lang)}]
       (tset (. (require "nvim-tree-docs.template") :loaded-specs)
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
       (each [_# line# (ipairs ,[...])]
         (context#.eval-content line#)
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
  `#(or (ctx#.get-text (. ,(or tbl `$) ,(tostring key)) ,default)))

(fn %> [util-name ...]
  "Invokes a util function on this specification.
  This will invoke any inherited utils as well."
  `((. (. ,modsym :utils) ,(tostring util-name)) ,...))

(fn %content% []
  "Marks the content point for content to be inserted in."
  `(%^ "%%content%%" "%%content%%"))

{: template
 : util
 : %=
 : %^
 : %>
 : %content%
 : doc-spec}
