(require-macros "fnl.nvim-tree-docs.macros")

; TODO: Make wrapper for inserting empty lines... maybe another macro

(doc-spec
  {:spec jsdoc
   :lang javascript
   :config {:include_types true
            :empty_line_after_description true
            :author ""
            :tags {:function {:param true
                              :returns true
                              :export true}
                   :variable {:type true
                              :export true}
                   :class {:class true
                           :export true
                           :extends true}
                   :member {:memberOf true
                            :type true}
                   :method {:memberOf true
                            :param true
                            :returns true}}
            :tag_processors {}}}

(local tag-processors
  {})

(util get-param-name [$ param]
  (if param.default_value
    (string.format "%s=%s"
                   ($.get-text param.name)
                   ($.get-text param.default_value))
    ($.get-text param.name)))

(util get-marked-type [$ not-found?]
  (if (%conf $ include_types)
    [" {" (%^ "any") "} "]
    (or not-found? "")))

(util get-parameter-lines [$ parameters]
  (%each [param ($.iter $.parameters)]
    [" * @param "
     (%> get-param-name $ param.entry)
     (%> get-marked-type $ " ")
     "- "
     (%^ ["The " (%= name param.entry)])]))

(util include-tag? [$ kind tag implicit]
  (let [include-tags (or (%conf $ ["include_tags" kind]))
        exclude-tags (or (%conf $ ["excluded_tags" kind]))]
    (and (not (vim.tbl_contains exclude-tags tag))
         (if (not implicit)
           (vim.tbl_contains include-tags tag)
           true))))

(util get-tag-list [$ kind]
  (let [include-tags (or (%conf $ ["include_tags" kind]))
        exclude-tags (or (%conf $ ["excluded_tags" kind]))
        implicit-tags ()]))

(util get-return-line [$]
  [" * @returns" (%> get-marked-type $ " ") "The result"])

(template function
  "/**"
  [" * " (%^ [(%= name) " description"])]
  (%when (%conf $ empty_line_after_description) " *")
  (%when $.export " * @export")
  (%> get-parameter-lines $ $.parameters)
  (%when $.return_statement (%> get-return-line $))
  " */"
  (%content))

(template variable
  "/**"
  [" * " (%= name) " Description"]
  (%when $.export " * @export")
  (%when (%conf $ include_types) [" * @type" (%> get-marked-type $)])
  " */"
  (%content))

(template method
  "/**"
  [" * " (%^ (%= name))]
  (%when (%conf $ empty_line_after_description) " *")
  (%when $.class [" * @memberOf " (%= class)])
  (%> get-parameter-lines $ $.parameters)
  (%when $.return_statement (%> get-return-line))
  " */"
  (%content))

(template class
  "/**"
  [" * The " (%= name) " class."]
  [" * @class " (%= name)]
  (%when $.export " * @export")
  (%each [extention ($.iter $.extentions)]
     [" * @extends" (%= name extention.entry)])
  " */"
  (%content))

(template member
  "/**"
  " * Description"
  (%when $.class [ " * @memberOf " (%= class)])
  (%when (%conf $ include_types) [" * @type" (%> get-marked-type $)])
  " */"
  (%content))
