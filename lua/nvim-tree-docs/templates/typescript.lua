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
 * The <%= ctx.text(ctx.name) %n> function
<? if ctx.has_any({ ctx.generics, ctx.parameters, ctx['return'] }) then ?>
 *
<? end ?>
<? for _, g in ctx.for_each(ctx.generics) do ?>
 * @template <%= ctx.text(g.name) %n> - The <%= ctx.text(g.name) %> type
<? end ?>
<? for _, p in ctx.for_each(ctx.parameters) do ?>
 * @param <%= ctx.get_param_name(p) %> - The <%= ctx.text(p.name) %> argument
<? end ?>
<? if ctx['return'] then ?>
 * @returns The result
<? end ?>
 */
]]

M.variable = template.compile [[
/**
 * The <%= ctx.text(ctx.name) %> variable
 */
]]

M.method = template.compile [[
/**
 * The <%= ctx.text(ctx.name) %> method
<? if ctx.has_any({ ctx.parameters, ctx['return'] }) then ?>
 *
<? end ?>
<? for _, p in ctx.for_each(ctx.parameters) do ?>
 * @param <%= ctx.get_param_name(p) %> - The <%= ctx.text(p.name) %n> argument
<? end ?>
<? if ctx['return'] then ?>
 * @returns The result
<? end ?>
 */
]]

M.class = template.compile [[
/**
 * The <%= ctx.text(ctx.name) %> class.
<? if ctx.has_any({ ctx.generics }) then ?>
 *
<? end ?>
<? for _, g in ctx.for_each(ctx.generics) do ?>
 * @template <%= ctx.text(g.name) %n> - The <%= ctx.text(g.name) %n> type
<? end ?>
 */
]]

M.member = template.compile [[
/**
 * Description
 */
]]

M.interface = template.compile [[
/**
 * The <%= ctx.text(ctx.name) %> interface.
<? if ctx.has_any({ ctx.generics }) then ?>
 *
<? end ?>
<? for _, g in ctx.for_each(ctx.generics) do ?>
 * @template <%= ctx.text(g.name) %n> - The <%= ctx.text(g.name) %n> type
<? end ?>
 */
]]

M.property_signature = M.member

M.type_alias = template.compile [[
/**
 * The <%= ctx.text(ctx.name) %> type.
<? if ctx.has_any({ ctx.generics }) then ?>
 *
<? end ?>
<? for _, g in ctx.for_each(ctx.generics) do ?>
 * @template <%= ctx.text(g.name) %n> - The <%= ctx.text(g.name) %n> type
<? end ?>
 */
]]

return M
