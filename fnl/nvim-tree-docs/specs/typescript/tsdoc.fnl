(require-macros "fnl.nvim-tree-docs.macros")

(doc-spec
  {:spec tsdoc
   :lang typescript
   :extends javascript.jsdoc
   :config {:include_types false}})
