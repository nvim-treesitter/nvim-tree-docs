(function_declaration
  name: (identifier) @function.name
  parameters: (formal_parameters
                (identifier)? @function.parameter)) @function.definition

(variable_declarator
  name: (identifier) @variable.name
  value: (_)? @variable.initial_value) @variable.definition
