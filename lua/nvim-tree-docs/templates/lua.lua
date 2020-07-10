local template = require "nvim-tree-docs.template"

local M = {}

M['function'] = template.compile [[
--- Description
<? for _, p in ipairs(ctx.parameters) do ?>
-- @param <%= ctx.text(p) %>: the <%= ctx.text(p) %n>
<? end ?>
<? if ctx['return'] then ?>
-- @returns
<? end ?>
]]

M['variable'] = template.compile [[
--- Description
]]

return M
