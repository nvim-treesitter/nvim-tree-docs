local template = require "nvim-tree-docs.template"

local M = {}

M.context = {}

function M.context.get_param_name(ctx, p)
  local name = ctx.text(p.name)

  if p.default_value then
    return string.format("[%s=%s]", name, ctx.text(p.default_value))
  end

  return name
end

M['function'] = template.compile [[
/**
 * <%= ctx.text(ctx.name) %> description
<? if ctx.export then ?>
 * @export
<? end ?>
<? for _, p in ctx.for_each(ctx.parameters) do ?>
 * @param <%= ctx.get_param_name(p) %> {any} - The <%= ctx.text(p.name) %> argument
<? end ?>
<? if ctx['return'] then ?>
 * @returns {any} The result
<? end ?>
 */
]]

M.variable = template.compile [[
/**
 * Description
<? if ctx.export then ?>
 * @export
<? end ?>
 * @type {any}
 */
]]

M.method = template.compile [[
/**
 * <%= ctx.text(ctx.name) %n>
<? if ctx.class then ?>
 * @memberOf <%= ctx.text(ctx.class) %n>
<? end ?>
<? for _, p in ctx.for_each(ctx.parameters) do ?>
 * @param <%= ctx.get_param_name(p) %> {any} - The <%= ctx.text(p.name) %> argument
<? end ?>
<? if ctx['return'] then ?>
 * @returns
<? end ?>
 */
]]

M.class = template.compile [[
/**
 * The <%= ctx.text(ctx.name) %> class.
 * @class <%= ctx.text(ctx.name) %n>
<? if ctx.export then ?>
 * @export
<? end ?>
<? for _, e in ctx.for_each(ctx.extentions) do ?>
 * @extends <%= ctx.text(e.name) %n>
<? end ?>
 */
]]

M.member = template.compile [[
/**
 * Description
<? if ctx.class then ?>
 * @memberOf <%= ctx.text(ctx.class) %n>
<? end ?>
 * @type {any}
 */
]]

return M
