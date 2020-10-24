(require-macros "fnl.nvim-tree-docs.macros")

(doc-spec
  {:spec jsdoc
   :lang javascript
   :doc-lang jsdoc
   :config {:include_types true
            :empty_line_after_description false
            :slots {:function {:param true
                               :example false
                               :returns true
                               :function true
                               :generator true
                               :template true
                               :yields true
                               :export true}
                    :variable {:type true
                               :export true}
                    :class {:class true
                            :example false
                            :export true
                            :extends true}
                    :member {:memberof true
                             :type true}
                    :method {:memberof true
                             :example false
                             :yields true
                             :generator true
                             :param true
                             :returns true}
                    :module {:module true}}}})

(template function
  doc-start
  description
  function
  generator
  yields
  %rest%
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
  memberof
  %rest%
  param
  returns
  example
  doc-end
  %content%)

(template class
  doc-start
  description
  class
  extends
  %rest%
  example
  doc-end
  %content%)

(template member
  doc-start
  description
  memberof
  %rest%
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
  build #"/**")

(processor doc-end
  implicit true
  build #" */")

(processor returns
  when #$.return_statement
  build #(let [type-str (%> get-marked-type $ " ")]
           (%- " * @returns" type-str (%! "The result"))))

(processor function
  when #(not $.generator)
  build #(%- " * @function " (%= name)))

(processor module
  build #(let [filename (vim.fn.expand "%:t:r")]
           (%- " * @module " (%! filename))))

(processor template
  when #$.generics
  build #(%> build-generics $ :template))

(processor typeParam
  when #$.generics
  build #(%> build-generics $ :typeParam))

(processor extends
  when #$.extends
  build #(%- " * @extends " (%= extends)))

(processor class
  build #(%- " * @class " (%= name)))

(processor generator
  when #$.generator)

(processor yields
  when #$.yields
  build #(%- " * @yields" (%> get-marked-type $ "")))

(processor description
  implicit true
  build #(let [description (%- " * " (%! (.. "The " (%= name) " " $2.name)))
               {: processors : index} $2
               next-ps (. processors (+ index 1))]
           (if (or (= next-ps :doc-end)
                   (not ($.conf :empty_line_after_description)))
             description
             [description " *"])))

(processor type
  when #$.type
  build #(let [type-str (%> get-marked-type $ " ")]
           (%- " * @type" type-str)))

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
                 (%- " * @param"
                     type-str
                     param-name
                     " - "
                     (%! (.. "The " name " param"))))))
           result))

(processor memberof
  when #$.class
  build #(%-  " * @memberof " (%= class)))

(processor
  build #(%- " * @" $2.name))

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

(util build-generics [$ tag]
  (let [result []]
    (each [generic ($.iter $.generics)]
      (let [name (%= name generic.entry)]
        (table.insert result
                      (%- " * @" tag " " name " " (%! (.. "The " name " type"))))))
    result))
