; ---- Functions

(
  (comment)+? @function.doc
  (function_declaration
    name: (identifier) @function.name
    type_parameters: (type_parameters
      (type_parameter
        (type_identifier) @function.generics.name @function.generics.definition))?
    parameters: (formal_parameters) @function.end_point
    return_type: (type_annotation
      (_) @function.return_type @function.end_point)?
    body: (statement_block
      (return_statement)? @function.return)) @function.definition
)

(
  (comment)+? @function.doc
  (export_statement
    (function_declaration) @function.definition) @function.start_point @function.export
)

; Required function params
(function_declaration
  parameters: (formal_parameters
    (required_parameter
      (identifier) @function.parameters.name @function.parameters.definition
      (type_annotation
        (_) @function.parameters.type)?
      value: (_)? @function.parameters.default_value @function.parameters.optional))) @function.definition

; Optional function params
(function_declaration
  parameters: (formal_parameters
    (optional_parameter
      (identifier) @function.parameters.name @function.parameters.definition @function.parameters.optional
      (type_annotation
        (_) @function.parameters.type)?))) @function.definition

; ----- Variables

; Variables `const test = 123;`
(
  (comment)+? @variable.doc
  (lexical_declaration
    (variable_declarator
      name: (identifier) @variable.name
      value: (_)? @variable.initial_value) @variable.definition) @variable.root
)

(
  (comment)+? @variable.doc
  (export_statement
    (lexical_declaration
      (variable_declarator) @variable.definition)) @variable.root @variable.export
)

; ----- Methods

(
  (identifier) @method.class
  (class_body
    ((comment)+? @method.doc
    (method_definition
      name: (property_identifier) @method.name
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
    name: (type_identifier) @class.name
    (class_heritage
      (extends_clause
        (type_identifier) @class.extentions.name @class.extentions.definition)?
      (implements_clause
        (type_identifier) @class.implementations.name @class.implementations.definition)?
    )?
  ) @class.definition
)

(
  (comment)+? @class.doc
  (class
    name: (type_identifier)? @class.name
    (class_heritage
      (identifier) @class.extentions.name @class.extentions.definition)?) @class.definition
)

; Exported Classes `export class Test {}`
(
  (comment)+? @class.doc
  (export_statement
    declaration: (class_declaration) @class.definition) @class.export @class.root
)

(
  (comment)+? @class.doc
  (export_statement
    declaration: (class) @class.definition) @class.export @class.root
)

; Class members
(
  (type_identifier)? @member.class
  (class_body
    ((comment)+? @member.doc
    (public_field_definition
      (readonly)? @member.readonly
      type: (type_annotation (_) @member.type)?
      name: (property_identifier) @member.name) @member.definition))
)

