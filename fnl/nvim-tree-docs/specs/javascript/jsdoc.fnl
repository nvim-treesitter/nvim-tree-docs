(require-macros "nvim-tree-docs.macros")

(doc-spec {:spec "jsdoc" :lang "javascript"})

(fn get-param-name [ctx param]
  (if param.default_value
    (string.format "%s=%s"
                   (ctx.get-text param.name)
                   (ctx.get-text param.default_value))
    (ctx.get-text param.name)))

(template function
  "/**"
  [" *" (%= name) "description"]
  #(when $.export
     " * @export")
  #(each [i param $.parameters]
    [" * @param" #(get-param-name $ param) "{any} - The" (%= name param)])
  #(when $.return_statement
     " * returns {any} The result")
  " */")

(template variable
  "/**"
  " * Description"
  #(when $.export " * @export")
  " * @type {any}"
  " */")
