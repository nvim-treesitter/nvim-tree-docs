; ---- Functions

(
  (comment)+? @function.doc
  (function_declaration
    name: (identifier) @function.name
    parameters: (formal_parameters) @function.end_point
    body: (statement_block
      (return_statement)? @function.return)) @function.definition
)

(
  (comment)+? @function.doc
  (export_statement
    (function_declaration) @function.definition) @function.start_point @function.export
)

; Function params
(function_declaration
  parameters: (formal_parameters
    (identifier)? @function.parameters.name @function.parameters.definition)) @function.definition


; Function params with default values `a = 123`
(function_declaration
  parameters: (formal_parameters
    (assignment_pattern
      left: (shorthand_property_identifier) @function.parameters.name @function.parameters.definition
      right: (_) @function.parameters.default_value))) @function.definition

; ----- Variables

; Variables `const test = 123;`
(
  (comment)+? @variable.doc
  (lexical_declaration
    (variable_declarator
      name: (identifier) @variable.name
      value: (_)? @variable.initial_value) @variable.definition) @variable.start_point
)

(
  (comment)+? @variable.doc
  (export_statement
    (lexical_declaration
      (variable_declarator) @variable.definition)) @variable.start_point @variable.export
)

; ----- Methods

(
  (identifier) @method.class
  (class_body
    ((comment)+? @method.doc
    (method_definition
      name: (property_identifier) @method.name
      parameters: (formal_parameters) @method.end_point
      body: (statement_block
        (return_statement)? @method.return)) @method.definition))
)

; Method params
(method_definition
  parameters: (formal_parameters
    (identifier) @method.parameters.name @method.parameters.definition)) @method.definition

; Method params with default values `a = 123`
(method_definition
  parameters: (formal_parameters
    (assignment_pattern
      left: (shorthand_property_identifier) @method.parameters.name @method.parameters.definition
      right: (_) @method.parameters.default_value))) @method.definition

; ----- Classes

; Classes
(
  (comment)+? @class.doc
  (class_declaration
    name: (identifier) @class.name @class.end_point
    (class_heritage
      (identifier) @class.extentions.name @class.extentions.definition)?) @class.definition
)

(
  (comment)+? @class.doc
  (class
    name: (identifier)? @class.name
    (class_heritage
      (identifier) @class.extentions.name @class.extentions.definition @class.end_point)?) @class.definition
)

; Exported Classes `export class Test {}`
(
  (comment)+? @class.doc
  (export_statement
    declaration: (class_declaration) @class.definition) @class.export @class.start_point
)

(
  (comment)+? @class.doc
  (export_statement
    declaration: (class) @class.definition) @class.export @class.start_point
)

; Class members
(
  (identifier)? @member.class
  (class_body
    ((comment)+? @member.doc
    (public_field_definition
      (property_identifier) @member.name @member.end_point) @member.definition))
)

