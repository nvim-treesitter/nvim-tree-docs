local ts_utils = require "nvim-treesitter.ts_utils"

local M = {}

-- TODO: implement a small template engine

M['function'] = function(data)
  local r = {
    '/**',
    ' * Description'
  }

 for _, param in ipairs(data.parameters) do
   local text = ts_utils.get_node_text(param)[1]

   table.insert(r, ' * @param ' .. text  .. ' {any} The ' .. text)
 end

 table.insert(r, ' */')

 return r
end

return M
