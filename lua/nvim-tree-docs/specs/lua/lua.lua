do
  local _1_0 = {templates = {}}
  require("nvim-tree-docs.template")["loaded-specs"][("lua" .. "_" .. "lua")] = _1_0
end
local function _2_(context_0_)
  for __0_, line_0_ in ipairs({"--- Description"}) do
    context_0_["eval-content"](line_0_, context_0_)
  end
  return output_0_
end
_1_.templates["function"] = _2_
return nil