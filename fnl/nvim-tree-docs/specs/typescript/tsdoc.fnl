(require-macros "fnl.nvim-tree-docs.macros")

(doc-spec
  {:spec tsdoc
   :lang typescript
   :extends javascript.jsdoc
   :config {:include_types false
            :slots {:function {:export false}
                    :variable {:type false
                               :export false}
                    :class {:class false
                            :export false
                            :extends false}
                    :member {:memberOf false
                             :type false}
                    :method {:memberOf false}}}})
