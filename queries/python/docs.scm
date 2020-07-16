(function_definition
  name: (identifier) @function.name) @function.definition

(function_definition
  parameters: (parameters
    (identifier) @function.parameters.name @function.parameters.definition) @function.end_point) @function.definition
