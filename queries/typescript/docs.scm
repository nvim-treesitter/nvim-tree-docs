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
      type_parameters: (type_parameters
        (type_parameter
          (type_identifier) @method.generics.name @method.generics.definition))?
      parameters: (formal_parameters) @method.end_point
      return_type: (type_annotation
        (_) @method.return_type)? @method.end_point
      body: (statement_block
        (return_statement)? @method.return)) @method.definition))
)

; Required method params
(method_definition
  parameters: (formal_parameters
    (required_parameter
      (identifier) @method.parameters.name @method.parameters.definition
      (type_annotation
        (_) @method.parameters.type)?
      value: (_)? @method.parameters.default_value @method.parameters.optional))) @method.definition

; Optional method params
(method_definition
  parameters: (formal_parameters
    (optional_parameter
      (identifier) @method.parameters.name @method.parameters.definition
      (type_annotation
        (_) @method.parameters.type)?
      value: (_)? @method.parameters.default_value @method.parameters.optional))) @method.definition

; Method signatures (required params)
(method_signature
  name: (property_identifier) @method.name
  parameters: (formal_parameters
    (required_parameter
      (identifier) @method.parameters.name @method.parameters.definition
      (type_annotation
        (_) @method.parameters.type)?)?)
  return_type: (type_annotation
    (_) @method.return_type)? @method.end_point) @method.definition

; Method signatures (optional params)
(method_signature
  name: (property_identifier) @method.name
  parameters: (formal_parameters
    (optional_parameter
      (identifier) @method.parameters.name @method.parameters.definition
      (type_annotation
        (_) @method.parameters.type)?)?)
  return_type: (type_annotation
    (_) @method.return_type)? @method.end_point) @method.definition

; ----- Classes

; Classes
(
  (comment)+? @class.doc
  (class_declaration
    name: (type_identifier) @class.name @class.end_point
    type_parameters: (type_parameters
      (type_parameter
        (type_identifier) @class.generics.name @class.generics.definition))? @class.end_point
    (class_heritage
      (extends_clause
        (type_identifier) @class.extentions.name @class.extentions.definition)?
      (implements_clause
        (type_identifier) @class.implementations.name @class.implementations.definition)?)? @class.end_point) @class.definition
)

; Exported Classes `export class Test {}`
(
  (comment)+? @class.doc
  (export_statement
    declaration: (class_declaration) @class.definition) @class.export @class.start_point
)

; Class members
(
  (identifier)? @member.class
  (class_body
    ((comment)+? @member.doc
    (public_field_definition
      (property_identifier) @member.name @member.end_point) @member.definition))
)

; Decorated members
(
  (comment)+? @member.doc
  (decorator)+? @member.start_point
  (public_field_definition
    (property_identifier) @member.name @member.end_point) @member.definition
)

; ---- Interfaces

(
  (comment)+? @interface.doc
  (interface_declaration
    name: (_) @interface.name @interface.end_point
    type_parameters: (type_parameters
      (type_parameter
        (type_identifier) @interface.generics.name @interface.generics.definition))? @interface.end_point
    (extends_clause
      (_) @interface.extentions.name @interface.extentions.definition)? @interface.end_point) @interface.definition
)

(
  (comment)+? @interface.doc
  (export_statement
    (interface_declaration) @interface.definition) @interface.start_point
)

(
  (comment)+? @interface.doc
  (property_signature
    name: (_) @property_signature.name
    type: (type_annotation
      (_) @property_signature.type)? @proprety_signature.end_point) @property_signature.definition
)

; ---- Types

(
  (comment)+? @interface.doc
  (type_alias_declaration
    name: (_) @type_alias.name @type_alias.end_point
    type_parameters: (type_parameters
      (type_parameter
        (type_identifier) @type_alias.generics.name @type_alias.generics.definition))? @type_alias.end_point) @type_alias.definition
)

(
  (comment)+? @type_alias.doc
  (export_statement
    (type_alias_declaration) @type_alias.definition) @type_alias.start_point
)

