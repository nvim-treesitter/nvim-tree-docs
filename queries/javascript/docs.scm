;TODO: Figure out a way to avoid so much duplication
; Function params
(
  (comment)* @function.doc
  (function_declaration
    name: (identifier) @function.name
    parameters: (formal_parameters
                  (identifier)? @function.parameters.name)
    body: (statement_block
            (return_statement)? @function.return)) @function.definition
)

; Function params with default values `a = 123`
(
  (comment)* @function.doc
  (function_declaration
    parameters: (formal_parameters
                  (assignment_pattern
                    left: (shorthand_property_identifier) @function.parameters.name
                    right: (_) @function.parameters.default_value))) @function.definition
)

; Variables `const test = 123;`
(
  (comment)+? @variable.doc
  (lexical_declaration
    (variable_declarator
      name: (identifier) @variable.name
      value: (_)? @variable.initial_value)) @variable.definition
)

; Method params
(class_declaration
  name: (identifier) @method.class
  body: (class_body
          ((comment)* @method.doc
          (method_definition
            name: (property_identifier) @method.name
            parameters: (formal_parameters
                          (identifier)? @method.parameters.name)
            body: (statement_block
                    (return_statement)? @method.return)) @method.definition))) @method.class

; Method params with default values `a = 123`
(class_declaration
  name: (identifier) @method.class
  body: (class_body
          ((comment)* @method.doc
          (method_definition
            parameters: (formal_parameters
                          (assignment_pattern
                            left: (shorthand_property_identifier) @method.parameters.name
                            right: (_) @method.parameters.default_value))) @method.definition)))

(class_declaration
  name: (identifier) @class.name
  (class_heritage
    (identifier) @class.extensions.name)?) @class.definition
