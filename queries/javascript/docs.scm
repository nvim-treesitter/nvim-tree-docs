;TODO: Figure out a way to avoid so much duplication

; ---- Functions

; Function params
(
  (comment)* @function.doc
  (function_declaration
    name: (identifier) @function.name
    parameters: (formal_parameters
                  (identifier)? @function.parameters.name @function.parameters.definition)
    body: (statement_block
            (return_statement)? @function.return)) @function.definition
)

; Exported functions `export function test () {}`
(
  (comment)* @function.doc
  (export_statement
    (function_declaration
      name: (identifier) @function.name
      parameters: (formal_parameters
                    (identifier)? @function.parameters.name @function.parameters.definition)
      body: (statement_block
              (return_statement)? @function.return)) @function.definition) @function.root @function.export
)

; Function params with default values `a = 123`
(
  (comment)* @function.doc
  (function_declaration
    parameters: (formal_parameters
                  (assignment_pattern
                    left: (shorthand_property_identifier) @function.parameters.name @function.parameters.definition
                    right: (_) @function.parameters.default_value))) @function.definition
)

; Exported function params with default values `export const a = 123`
(
  (comment)* @function.doc
  (export_statement
    declaration: (function_declaration
                   parameters: (formal_parameters
                                 (assignment_pattern
                                   left: (shorthand_property_identifier) @function.parameters.name @function.parameters.definition
                                   right: (_) @function.parameters.default_value))) @function.definition) @function.export @function.root
)

; ----- Variables

; Variables `const test = 123;`
(
  (comment)+? @variable.doc
  (lexical_declaration
    (variable_declarator
      name: (identifier) @variable.name
      value: (_)? @variable.initial_value)) @variable.definition
)

; ----- Methods

; Method params
(
  (identifier) @method.class
  (class_body
    ((comment)* @method.doc
    (method_definition
      name: (property_identifier) @method.name
      parameters: (formal_parameters
                    (identifier)? @method.parameters.name)
      body: (statement_block
              (return_statement)? @method.return)) @method.definition))
)

; Method params with default values `a = 123`
(
  (identifier)? @method.class
  (class_body
    ((comment)* @method.doc
    (method_definition
      parameters: (formal_parameters
                    (assignment_pattern
                      left: (shorthand_property_identifier) @method.parameters.name
                      right: (_) @method.parameters.default_value))) @method.definition))
)

; ----- Classes

; Classes
(
  (comment)* @class.doc
  (class_declaration
    name: (identifier) @class.name
    (class_heritage
      (identifier) @class.extensions.name)?) @class.definition
)

; Exported Classes `export class Test {}`
(
  (comment)* @class.doc
  (export_statement
    declaration: (class_declaration
                   name: (identifier) @class.name
                   (class_heritage
                     (identifier) @class.extensions.name)?) @class.definition) @class.export @class.root
)

; Default class exports `export default class Test {}`
(
  (comment)* @class.doc
  (export_statement
    declaration: (class
                   name: (identifier) @class.name
                   (class_heritage
                     (identifier) @class.extensions.name)?) @class.definition) @class.export @class.root
)

; Class members
(
  (identifier) @member.class
  (class_body
    ((comment)* @member.doc
    (public_field_definition
      property: (property_identifier) @member.name) @member.definition))
)

