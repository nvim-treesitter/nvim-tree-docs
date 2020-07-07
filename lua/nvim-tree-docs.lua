local queries = require "nvim-treesitter.query"

local M = {}

function M.init()
  require "nvim-treesitter".define_modules {
    tree_docs = {
      module_path = "nvim-tree-docs.docs",
      is_supported = function(lang)
        return queries.get_query(lang, 'docs') ~= nil
      end
    }
  }
end

return M
