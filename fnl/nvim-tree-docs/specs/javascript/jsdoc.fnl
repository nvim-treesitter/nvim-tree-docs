(require-macros "fnl.nvim-tree-docs.macros")

(doc-spec {:spec "jsdoc" :lang "javascript"})

(fn get-param-name [ctx param]
  (if param.default_value
    (string.format "%s=%s"
                   (ctx.get-text param.name)
                   (ctx.get-text param.default_value))
    (ctx.get-text param.name)))

(template function
  "/**"
  [" *" (%^ [(%= name) " description"])]
  #(when $.export " * @export")
  #(each [_ param ($.iter $.parameters)]
    [" * @param "
     #(get-param-name $ param)
     " {" (%^ "any")  "} - " (%^ ["The " (%= name param)])])
  #(when $.return_statement
     [" * returns {" (%^ "any") "} The result"])
  " */")

(template variable
  "/**"
  " * Description"
  #(when $.export " * @export")
  " * @type {any}"
  " */")

(template method
  "/**"
  [" *" (%= name)]
  #(when $.class [" * @memberOf " (%= class)])
  #(each [_ param ($.iter $.parameters)]
     [" * @param " #(get-param-name $ param) " {any} - The " (%= name param) " argument"])
  #(when $.return_statement " * @returns")
  " */")

(template class
  "/**"
  [" * The" (%= name) "class."]
  [" * @class" (%= name)]
  #(when $.export " * @export")
  #(each [_ extention ($.iter $.extentions)]
     [" * @extends" (%= name extention)])
  " */")

(template member
  "/**"
  " * Description"
  #(when $.class [ "* @memberOf" (%= class)])
  " * @type {any}"
  " */")
