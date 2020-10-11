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
       (local output# [])
       (each [_# line# (ipairs ,[...])]
         (table.insert output# (context#.eval-line line# context#)))
       output#)))

(fn %= [key tbl default]
  `#(or (ctx#.get-text (. ,(or tbl `$) ,(tostring key)) ,default)))

(fn %? [key]
  `#(. $1 ,(tostring key)))

{: template
 : %=
 : %?
 : doc-spec}
