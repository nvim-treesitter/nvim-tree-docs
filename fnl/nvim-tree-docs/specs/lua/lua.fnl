(require-macros "fnl.nvim-tree-docs.macros")

(doc-spec {:spec lua :lang lua})

(template function
  "--- Description"
  #(each [_ param ($.iter $.parameters)]
     ["-- @param " (%= name param) ": the " (%= name param)])
  "-- @returns")

(template variable
  "--- Description")
