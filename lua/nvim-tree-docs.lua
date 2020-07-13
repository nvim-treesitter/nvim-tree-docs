local queries = require "nvim-treesitter.query"

local M = {}

function M.init()
  require "nvim-treesitter".define_modules {
    tree_docs = {
      module_path = "nvim-tree-docs.internal",
      keymaps = {
        doc_node_at_cursor = "gdd",
        doc_all_in_range = "gdd"
      },
      is_supported = function(lang)
        return queries.get_query(lang, 'docs') ~= nil
      end
    }
  }
end

return M
