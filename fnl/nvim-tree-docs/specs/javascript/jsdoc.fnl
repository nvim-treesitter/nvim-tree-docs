(require-macros "fnl.nvim-tree-docs.macros")

(doc-spec
  {:spec jsdoc
   :lang javascript
   :config {:include_types true
            :empty_line_after_description false
            :slots {:function {:param true
                               :example false
                               :returns true
                               :function true
                               :generator true
                               :yields true
                               :export true}
                    :variable {:type true
                               :export true}
                    :class {:class true
                            :example false
                            :export true
                            :extends true}
                    :member {:memberOf true
                             :type true}
                    :method {:memberOf true
                             :example false
                             :param true
                             :returns true}
                    :module {:module true}}}})

(template function
  doc-start
  description
  %rest%
  generator
  yields
  param
  returns
  example
  doc-end
  %content%)

(template variable
  doc-start
  description
  %rest%
  doc-end
  %content%)

(template method
  doc-start
  description
  %rest%
  memberOf
  param
  returns
  example
  doc-end
  %content%)

(template class
  doc-start
  description
  %rest%
  class
  extends
  example
  doc-end
  %content%)

(template member
  doc-start
  description
  %rest%
  class
  extends
  doc-end
  %content%)

(template module
  doc-start
  description
  module
  %rest%
  doc-end)

(processor doc-start
  implicit true
  build #(do "/**"))

(processor doc-end
  implicit true
  build #(do " */"))

(processor returns
  when #$.return_statement
  build #(let [type-str (%> get-marked-type $ " ")]
           (.. " * @returns" type-str  "The result")))

(processor function
  when #(not $.generator))

(processor module
  build #(do " * @module <moduleName>"))

(processor generator
  when #$.generator)

(processor yields
  when #$.yields
  build #(.. " * @yields" (%> get-marked-type $ "")))

(processor description
  implicit true
  build #(let [description (.. " * The " (%= name) " " $2.name)
               {: processors : index} $2
               next-ps (. processors (+ index 1))]
           (if (or (= next-ps :doc-end)
                   (not ($.conf :empty_line_after_description)))
             description
             [description " *"])))

(processor type
  when #$.type
  build #(let [type-str (%> get-marked-type $ " ")]
           (.. " * @type" type-str)))

(processor export
  when #$.export)

(processor param
  when #(and $.parameters
             (not ($.empty? $.parameters)))
  build #(let [result []]
           (each [param ($.iter $.parameters)]
             (let [param-name (%> get-param-name $ param.entry)
                   type-str (%> get-marked-type $ " ")
                   name (%= name param.entry)]
               (table.insert
                 result
                 (.. " * @param " param-name type-str "- The " name))))
           result))

(processor memberOf
  when #$.class
  build #(.. " * @memberOf " (%= class)))

(processor
  build #(.. " * @" $2.name))

(util get-param-name [$ param]
  (if param.default_value
    (string.format "%s=%s"
                   ($.get-text param.name)
                   ($.get-text param.default_value))
    ($.get-text param.name)))

(util get-marked-type [$ not-found?]
  (if ($.conf :include_types)
    " {any} "
    (or not-found? "")))
