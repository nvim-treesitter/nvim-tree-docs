; inherits: ecma
; Javascript

; ---- Functions

; Function param name
[
  (function_declaration
    parameters: (formal_parameters
      (identifier) @function.parameters.name @function.parameters.definition))
  (generator_function_declaration
    parameters: (formal_parameters
      (identifier) @function.parameters.name @function.parameters.definition))
] @function.definition

; Function param default value
[
  (function_declaration
    parameters: (formal_parameters
      (assignment_pattern
        left: (identifier) @function.parameters.definition @function.parameters.name
        right: (_) @function.parameters.default_value @function.parameters.optional)))
  (generator_function_declaration
    parameters: (formal_parameters
      (assignment_pattern
        left: (identifier) @function.parameters.definition @function.parameters.name
        right: (_) @function.parameters.default_value @function.parameters.optional)))
] @function.definition


(method_definition
  parameters: (formal_parameters) @method.end_point) @method.definition

; Method params
(method_definition
  parameters: (formal_parameters
    (identifier) @method.parameters.name @method.parameters.definition)) @method.definition

; Method param default value
(method_definition
  parameters: (formal_parameters
    (identifier) @method.parameters.definition
    (assignment_pattern
      left: (_) @method.parameters.name
      right: (_) @method.parameters.default_value @method.parameters.optional))) @method.definition

(class_declaration
  (class_heritage
    (identifier) @class.extends)) @class.definition

; Member name
(public_field_definition
  property: (property_identifier) @member.name @member.end_point) @member.definition
