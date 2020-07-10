local template = require "nvim-tree-docs.template"

local M = {}

function M.get_param_name(ctx, p)
  local name = ctx.text(p.name.node)

  return p.default_value and string.format("[%s=%s]", name, ctx.text(p.default_value.node)) or name
end

M['function'] = template.compile [[
/**
 * <%= ctx.text(ctx.name.node) %n>
<? for _, p in ipairs(ctx.parameters) do ?>
 * @param <%= ctx.get_param_name(p) %> {any} The <%= ctx.text(p.name.node) %n>
<? end ?>
<? if ctx['return'] then ?>
 * @returns
<? end ?>
 */
]]

M.variable = template.compile [[
/**
 * Description
 * @type {any}
 */
]]

M.method = template.compile [[
/**
 * <%= ctx.text(ctx.name.node) %n>
 * @memberOf <%= ctx.text(ctx.class.node) %n>
<? for _, p in ipairs(ctx.parameters) do ?>
 * @param <%= ctx.get_param_name(p) %> {any} The <%= ctx.text(p.name.node) %n>
<? end ?>
<? if ctx['return'] then ?>
 * @returns
<? end ?>
 */
]]

M.class = template.compile [[
/**
 * The <%= ctx.text(ctx.name.node) %> class.
 * @class <%= ctx.text(ctx.name.node) %n>
<? for _, e in ipairs(ctx.extensions) do ?>
 * @extends <%= ctx.text(e.name.node) %n>
<? end ?>
 */
]]

M.member = template.compile [[
/**
 * Description
 * @memberOf <%= ctx.text(ctx.class.node) %n>
 * @type {any}
 */
]]

return M
