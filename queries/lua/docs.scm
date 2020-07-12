; Nonlocal functions `function M.test() end`
(function
  (function_name) @function.name
  (parameters
    (identifier)? @function.parameters.name @function.parameters.definition)
  (return_statement)? @function.return) @function.definition

; Local functions `local function test() end`
(local_function
  (identifier) @function.name
  (parameters
    (identifier)? @function.parameters.name @function.parameters.definition)
  (return_statement)? @function.return) @function.definition @function.local

; Non local variables `M.test = {}`
(local_variable_declaration
  (variable_declarator
    (identifier) @variable.name)) @variable.definition @variable.local

; Local variables `local test = {}`
(variable_declaration
  (variable_declarator
    (identifier) @variable.name)) @variable.definition
