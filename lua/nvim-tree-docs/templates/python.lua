local template = require "nvim-tree-docs.template"

local M = {}

M['function'] = template.compile [[
"""
Description
"""
]]

return M
