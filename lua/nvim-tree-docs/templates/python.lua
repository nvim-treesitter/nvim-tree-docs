local template = require "nvim-tree-docs.template"

local M = {}

M['function'] = template.compile [[
"""
Some text on top
"""
<@ content @>
    """
    Description
    """
]]

return M
