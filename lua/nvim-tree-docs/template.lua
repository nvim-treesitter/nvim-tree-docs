local ts_utils = require "nvim-treesitter.ts_utils"
local api = vim.api

local M = {}

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

  if not templates or not templates[data.type] then return end

  local context = M.get_template_context(data)
  local lines = vim.split(templates[data.type](context), "\n")

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
    vim.tbl_extend("force", data, {
      text = function(node, multi)
        local text = ts_utils.get_node_text(node)

        return multi and text or text[1] or ''
      end
    }),
    {
      __index = function(tbl, key)
        local existing = rawget(tbl, key)

        if existing then return existing end

        local template_mod = M.get_template(nil, ft)

        if not template_mod[key] then
          return nil
        end

        local fn = function(...) return template_mod[key](tbl, ...) end

        rawset(tbl, key, fn)

        return fn
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
