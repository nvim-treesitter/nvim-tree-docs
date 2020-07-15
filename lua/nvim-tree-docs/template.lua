local ts_utils = require "nvim-treesitter.ts_utils"
local Collector = require "nvim-tree-docs.collector"
local api = vim.api

local M = {}

local context_api = {
  -- Simple way to extract text from a match or node.
  text = function(node, default, multi)
    local default = default or ''

    if not node or type(node) ~= 'table' then return default end

    -- Safe access to matches
    if node.node then
      node = node.node
    end

    local lines = ts_utils.get_node_text(node)

    if multi then return lines end


    return lines[1] and lines[1] ~= '' and lines[1] or default
  end,
  has_any = function(matches)
    for _, match in pairs(matches) do
      local is_collector = Collector.is(match)

      if (is_collector and not match:is_empty()) or (not is_collector and match) then
        return true
      end
    end

    return false
  end,
  for_each = function(collector)
    return collector and collector:iterate() or function() return nil end
  end
}

function M.get_template(bufnr, ft)
  local bufnr = bufnr or api.nvim_get_current_buf()
  local ft = ft or api.nvim_buf_get_option(bufnr, 'ft')

  local successful, template = pcall(function()
    return require(string.format("nvim-tree-docs.templates.%s", ft))
  end)

  return successful and template or nil
end

function M.execute_template(data, bufnr, ft)
  local templates = M.get_template(bufnr, ft)

  if not templates or not templates[data.kind] then return end

  local context = M.get_template_context(data)
  local lines = vim.split(templates[data.kind](context), "\n")

  -- Trim leading/trailing blank lines
  if lines[1] == '' then
    table.remove(lines, 1)
  end

  if lines[#lines] == '' then
    table.remove(lines, #lines)
  end

  return lines
end

function M.get_template_context(data, ft)
  return setmetatable(
    vim.tbl_extend("force", data, context_api),
    {
      __index = function(tbl, key)
        -- Any unknown key will be looked up on the template modules context table.
        -- This allows for the adding of language specific util methods.
        local existing = rawget(tbl, key)

        if existing then return existing end

        local template_mod = M.get_template(nil, ft)

        if not template_mod.context or not type(template_mod.context[key]) then
          return nil
        end

        -- All context functions get passed the context as their first argument.
        local result = type(template_mod.context[key]) == 'function'
          and function(...) return template_mod.context[key](tbl, ...) end
          or template_mod.context[key];

        rawset(tbl, key, result)

        return result
      end
    }
  )
end

function M.compile(template)
  local compiled = [[
  return function(ctx)
    local r = {}
    local __ = table.insert
    __(r, [=[]]
  .. template
    :gsub("<%%=", "]=])\n__(r, ")
    :gsub("<%?", "]=])\n")
    :gsub("%?>", "\n__(r, [=[")
    :gsub("%%>", ")\n__(r, [=[")
    -- Adds a new line onto the end of expressions
    -- Sometime you have to force it...
    :gsub("%%n>", ")\n__(r, [=[\n")
  .. [[]=]) return table.concat(r, "") end]]

  -- TODO: raise template syntax errors

  return loadstring(compiled)()
end

return M
