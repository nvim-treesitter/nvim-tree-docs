(require-macros "nvim-tree-docs.macros")

(doc-spec
  {:spec luadoc
   :lang lua
   :config {:slots {:function {:param true
                               :returns true}
                    :variable {}}}})

(template function
  description
  param
  returns)

(template variable
  description)

(processor description
  implicit true
  build #"--- Description")

(processor param
  when #(and $.parameters
             (not ($.empty? $.parameters)))
  build #(let [result []]
           (each [param ($.iter $.parameters)]
             (let [name (%= name param.entry)]
               (table.insert
                 result
                 (.. "-- @param " name " The " name))))
           result))
