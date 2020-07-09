(function
  (function_name) @function.name
  (parameters
    (identifier)? @function.parameter)
  (return_statement)? @function.return) @function.definition

(local_variable_declaration
  (variable_declarator
    (identifier) @variable.name)) @variable.definition
