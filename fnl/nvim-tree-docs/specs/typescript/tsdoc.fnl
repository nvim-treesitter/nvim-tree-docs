(require-macros "fnl.nvim-tree-docs.macros")

(doc-spec
  {:spec tsdoc
   :lang typescript
   :extends javascript.jsdoc
   :config {:include_types false
            :empty_line_after_description true
            :slots {:function {:export false
                               :generator false
                               :function false}
                    :variable {:type false
                               :export false}
                    :class {:class false
                            :export false
                            :extends false}
                    :member {:memberof false
                             :type false}
                    :method {:memberof false}}}})
