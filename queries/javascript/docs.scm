(function_declaration
  name: (identifier) @function.name
  parameters: (formal_parameters
                (identifier)? @function.parameters.name)
  body: (statement_block
          (return_statement)? @function.return)) @function.definition

(function_declaration
  parameters: (formal_parameters
                (assignment_pattern
                  left: (shorthand_property_identifier) @function.parameters.name
                  right: (_) @function.parameters.default_value))) @function.definition

(lexical_declaration
  (variable_declarator
    name: (identifier) @variable.name
    value: (_)? @variable.initial_value)) @variable.definition
