(require-macros "fnl.nvim-tree-docs.macros")

(doc-spec
  {:spec base
   :lang base})

(processor %rest%
  implicit true
  expand (fn [slot-indexes slot-config]
           (let [expanded []]
             (each [ps-name enabled (pairs slot-config)]
               (when (not (. slot-indexes ps-name))
                 (table.insert expanded ps-name)))
             expanded)))

(processor %content%
  implicit true
  build #$.content
  indent #$)
