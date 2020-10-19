; (require-macros "fnl.nvim-tree-docs.macros")

; (doc-spec
;   {:spec ldoc
;    :lang lua
;    :config {:use_type_tags false
;             :default_tags
;             {:author []
;              :release []
;              :see []
;              :usage []}}})

; (util get-typed-tag [ctx tag]
;   (if (ctx.conf :use_type_tags)
;     (.. "t" tag)
;     tag))

; (template function
;   "--- Description"
;   (%each [param ($.iter $.parameters)]
;     ["-- @" (%> get-typed-tag $ "param") " " (%= name param.entry) ": the " (%= name param.entry)])
;   "-- @" (%> get-typed-tag $ "returns"))

; (template variable
;   "--- Description")
