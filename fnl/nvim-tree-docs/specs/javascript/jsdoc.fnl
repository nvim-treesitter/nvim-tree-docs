(require-macros "fnl.nvim-tree-docs.macros")

(doc-spec {:spec jsdoc :lang javascript})

(util get-param-name [ctx param]
  (if param.default_value
    (string.format "%s=%s"
                   (ctx.get-text param.name)
                   (ctx.get-text param.default_value))
    (ctx.get-text param.name)))

(util get-marked-type [] [" {" (%^ "any") "} "])

(util get-parameter-lines [ctx parameters]
  (%each [param (ctx.iter ctx.parameters)]
    [" * @param "
     (%> get-param-name ctx param.entry)
     (%> get-marked-type)
     "- "
     (%^ ["The " (%= name param.entry)])]))

(util get-return-line []
  [" * returns" (%> get-marked-type) "The result"])

(template function
  "/**"
  [" * " (%^ [(%= name) " description"])]
  #(when $.export " * @export")
  #(%> get-parameter-lines $ $.parameters)
  #(when $.return_statement (%> get-return-line))
  " */"
  (%content))

(template variable
  "/**"
  [" * " (%= name) " Description"]
  #(when $.export " * @export")
  " * @type {any}"
  " */"
  (%content))

(template method
  "/**"
  [" * " (%^ (%= name))]
  #(when $.class [" * @memberOf " (%= class)])
  #(%> get-parameter-lines $ $.parameters)
  #(when $.return_statement (%> get-return-line))
  " */"
  (%content))

(template class
  "/**"
  [" * The " (%= name) " class."]
  [" * @class " (%= name)]
  #(when $.export " * @export")
  #(each [extention ($.iter $.extentions)]
     [" * @extends" (%= name extention.entry)])
  " */"
  (%content))

(template member
  "/**"
  " * Description"
  #(when $.class [ " * @memberOf " (%= class)])
  [" * @type" (%> get-marked-type)]
  " */"
  (%content))
