; Nonlocal functions `function M.test() end`
; Local functions `local function test() end`
(function_declaration
  name: (_) @function.name
  parameters: (parameters
    (identifier)? @function.parameters.name @function.parameters.definition) @function.end_point
  (return_statement)? @function.return) @function.definition

; Non local variables `M.test = {}`
(assignment_statement
  (variable_list
    name: (dot_index_expression
      field: (identifier) @variable.name)) @variable.end_point) @variable.definition @variable.local

; Local variables `local test = {}`
(variable_declaration
  (assignment_statement
    (variable_list
      name: (identifier) @variable.name)) @variable.end_point) @variable.definition
