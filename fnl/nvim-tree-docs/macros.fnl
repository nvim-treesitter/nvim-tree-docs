(local modsym (gensym))

(fn doc-spec [config module]
  `(local ,modsym {:get-spec #(-> ,(tostring config.spec))})
   (tset (. (require "nvim-tree-docs.template") :loaded-specs)
         (.. config.lang "_" config.spec)
         ,modsym))

(fn template [kind ...]
  `(tset ,modsym ,(tostring kind)
     (fn [context#]
       (local output# [])
       (each [_# line# (ipairs ,[...])]
         (table.insert output# (context#.eval-line line# context#)))
       output#)))

(fn %= [key tbl default]
  `#(let [tbl# (or ,tbl $)]
      (or ($.get-text (. tbl# ,(tostring key)) default)))

(fn %? [key]
  `#(. $1 ,(tostring key)))

{: template
 : %=
 : %?}
