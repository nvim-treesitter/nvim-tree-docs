(local modsym (gensym))

(fn doc-spec [config]
  `(do
    (local ,modsym {:templates {}})
    (tset (. (require "nvim-tree-docs.template") :loaded-specs)
           (.. ,config.lang "_" ,config.spec)
           ,modsym)))

(fn template [kind ...]
  `(tset (. ,modsym :templates) ,(tostring kind)
     (fn [context#]
       (each [_# line# (ipairs ,[...])]
         (context#.eval-content line# context#))
       output#)))

(fn %^ [form]
  `#($.eval-and-mark ,form))

(fn %= [key tbl default]
  `#(or (ctx#.get-text (. ,(or tbl `$) ,(tostring key)) ,default)))

(fn %? [key]
  `#(. $1 ,(tostring key)))

{: template
 : %=
 : %?
 : %^
 : doc-spec}
