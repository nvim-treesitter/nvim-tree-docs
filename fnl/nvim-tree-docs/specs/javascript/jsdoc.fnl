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
           (%- " * @returns%sThe result" type-str)))

(processor function
  when #(not $.generator)
  build #(%- " * @function %s" (%= name)))

(processor module
  build #(let [filename (vim.fn.expand "%:t:r")]
           (%- " * @module %s" filename)))

(processor template
  when #$.generics
  build #(let [result []]
           (each [generic ($.iter $.generics)]
             (let [name (%= name generic.entry)]
               (table.insert result
                             (string.format " * @template %s The %s type" name name))))
           result))

(processor extends
  when #$.extends
  build #(%- " * @extends %s" (%= extends)))

(processor class
  build #(%- " * @class %s" (%= name)))

(processor generator
  when #$.generator)

(processor yields
  when #$.yields
  build #(%- " * @yields%s" (%> get-marked-type $ "")))

(processor description
  implicit true
  build #(let [description (%- " * The %s %s" (%= name) $2.name)
               {: processors : index} $2
               next-ps (. processors (+ index 1))]
           (if (or (= next-ps :doc-end)
                   (not ($.conf :empty_line_after_description)))
             description
             [description " *"])))

(processor type
  when #$.type
  build #(let [type-str (%> get-marked-type $ " ")]
           (%- " * @type%s" type-str)))

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
                 (%- " * @param %s%s- The %s param" param-name type-str name))))
           result))

(processor memberof
  when #$.class
  build #(%-  " * @memberof %s" (%= class)))

(processor
  build #(%- " * @%s" $2.name))

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
