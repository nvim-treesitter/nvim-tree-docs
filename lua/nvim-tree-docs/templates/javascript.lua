local template = require "nvim-tree-docs.template"

local M = {}

M.context = {}

function M.context.get_param_name(ctx, p)
  local name = ctx.text(p.name)

  if p.default_value then
    return string.format("[%s=%s]", name, ctx.text(p.default_value))
  elseif p.optional then
    return string.format("[%s]", name)
  else
    return name
  end
end

M['function'] = template.compile [[
/**
 * <%= ctx.text(ctx.name) %n>
<? if ctx.export then ?>
 * @export
<? end ?>
<? for _, p in ctx.for_each(ctx.parameters) do ?>
 * @param <%= ctx.get_param_name(p) %> {<%= ctx.text(p.type, 'any') %>} - The <%= ctx.text(p.name) %n>
<? end ?>
<? if ctx['return'] then ?>
 * @returns {<%= ctx.text(ctx.return_type, 'any') %>}
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
 * @param <%= ctx.get_param_name(p) %> {<%= ctx.text(ctx.type, 'any')%>} - The <%= ctx.text(p.name) %n>
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
<? for _, impl in ctx.for_each(ctx.implementations) do ?>
 * @implements <%= ctx.text(impl.name) %n>
<? end ?>
<? for _, e in ctx.for_each(ctx.extentions) do ?>
 * @extends <%= ctx.text(e.name) %n>
<? end ?>
 */
]]

M.member = template.compile [[
/**
 * Description
<? if ctx.readonly then ?>
 * @readonly
<? end ?>
<? if ctx.class then ?>
 * @memberOf <%= ctx.text(ctx.class) %n>
<? end ?>
 * @type {<%= ctx.text(ctx.type, 'any') %>}
 */
]]

return M
