; ---- Functions

(function_declaration
  name: (identifier) @function.name) @function.definition

; Function doc
(
  (comment) @function.doc
  (function_declaration) @function.definition
)

; Function generics
(function_declaration
  type_parameters: (type_parameters
    (type_parameter
      (type_identifier) @function.generics.name @function.generics.definition))) @function.definition

; Function return type
(function_declaration
  return_type: (type_annotation
    (_) @function.return_type @function.end_point)) @function.definition

; Return statement
(function_declaration
  body: (statement_block
    (return_statement) @function.return)) @function.definition

; Exported function
(export_statement
  (function_declaration) @function.definition) @function.start_point @function.export

; Function export doc
(
  (comment) @function.doc
  (export_statement
    (function_declaration) @function.definition)
)

; Function param name
(function_declaration
  parameters: (formal_parameters
    (_
      (identifier) @function.parameters.name @function.parameters.definition))) @function.definition

; Function param types
(function_declaration
  parameters: (formal_parameters
    (_
      (identifier) @function.parameters.definition
      (type_annotation
        (_) @function.parameters.type)))) @function.definition

; Function param default value
(function_declaration
  parameters: (formal_parameters
    (_
      (identifier) @function.parameters.definition
      value: (_) @function.parameters.default_value @function.parameters.optional))) @function.definition

; ----- Variables

; Variable name
(lexical_declaration
  (variable_declarator
    name: (identifier) @variable.name) @variable.definition) @variable.start_point

; Variable initializer
(lexical_declaration
  (variable_declarator
    value: (_) @variable.initial_value) @variable.definition) @variable.start_point

; Variable doc
(
  (comment) @variable.doc
  (lexical_declaration
    (variable_declarator) @variable.definition)
)

; Exported variable
(export_statement
  (lexical_declaration
    (variable_declarator) @variable.definition)) @variable.start_point @variable.export

; Exported variable doc
(
  (comment) @variable.doc
  (export_statement
    (lexical_declaration
      (variable_declarator) @variable.definition))
)

; ----- Methods

(method_definition
  name: (property_identifier) @method.name) @method.definition

(method_definition
  parameters: (formal_parameters) @method.end_point) @method.definition

; Method class name
(
  (type_identifier) @method.class
  (class_body
    (method_definition) @method.definition)
)

; Method type parameters
(method_definition
  type_parameters: (type_parameters
    (type_parameter
      (type_identifier) @method.generics.name @method.generics.definition))) @method.definition

; Method return type
(method_definition
  return_type: (type_annotation
    (_) @method.return_type) @method.end_point) @method.definition


; Method return statement
(method_definition
  body: (statement_block
    (return_statement) @method.return)) @method.definition

; Required method params
(method_definition
  parameters: (formal_parameters
    (_
      (identifier) @method.parameters.name @method.parameters.definition))) @method.definition

; Method param type
(method_definition
  parameters: (formal_parameters
    (_
      (identifier) @method.parameters.definition
      (type_annotation (_) @method.parameters.type)))) @method.definition

; Method param default value
(method_definition
  parameters: (formal_parameters
    (_
      (identifier) @method.parameters.definition
      value: (_) @method.parameters.default_value @method.parameters.optional))) @method.definition

; Method signature name
(method_signature
  name: (property_identifier) @method.name) @method.definition

; Method signatures params
(method_signature
  parameters: (formal_parameters
    (required_parameter
      (identifier) @method.parameters.name @method.parameters.definition) @method.end_point)) @method.definition

; Method signatures params type
(method_signature
  parameters: (formal_parameters
    (_
      (identifier) @method.parameters.definition
      (type_annotation
        (_) @method.parameters.type)) @method.end_point)) @method.definition

; Method signatures return type
(method_signature
  return_type: (type_annotation
    (_) @method.return_type) @method.end_point) @method.definition

; ----- Classes

; Classes
(class_declaration
  name: (type_identifier) @class.name @class.end_point) @class.definition

; Class doc
(
  (comment) @class.doc
  (class_declaration) @class.definition
)

; Decorated class
(
  (decorator)+ @class.start_point
  (class_declaration) @class.definition
)

; Decorated class doc
(
  (comment) @class.doc
  (decorator)+
  (class_declaration) @class.definition
)

(class_declaration
  type_parameters: (type_parameters
    (type_parameter
      (type_identifier) @class.generics.name @class.generics.definition)) @class.end_point) @class.definition

(class_declaration
  (class_heritage
    (extends_clause
      (type_identifier) @class.extentions.name @class.extentions.definition))) @class.definition

(class_declaration
  (class_heritage
    (implements_clause
      (type_identifier) @class.implementations.name @class.implementations.definition))) @class.definition


; Exported class doc
(
  (comment) @class.doc
  (export_statement
    declaration: (class_declaration) @class.definition)
)

; Exported class
(export_statement
  declaration: (class_declaration) @class.definition) @class.export @class.start_point

; Member class
(
  (type_identifier)? @member.class
  (class_body
    (public_field_definition) @member.definition)
)

; Member name
(public_field_definition
  (property_identifier) @member.name @member.end_point) @member.definition

; Member doc
(
  (comment) @member.doc
  (public_field_definition) @member.definition
)

; Decorated member doc
(
  (comment) @member.doc
  (decorator)+
  (public_field_definition) @member.definition
)

; Decorated member
(
  (decorator)+ @member.start_point
  (public_field_definition) @member.definition
)

; ---- Interfaces

; Interface doc
(
  (comment) @interface.doc
  (interface_declaration) @interface.definition
)

; Interface name
(interface_declaration
  name: (_) @interface.name @interface.end_point) @interface.definition

; Interface type parameters
(interface_declaration
  type_parameters: (type_parameters
    (type_parameter
      (type_identifier) @interface.generics.name @interface.generics.definition)) @interface.end_point) @interface.definition

; Interface extend clause
(interface_declaration
  (extends_clause
    (_) @interface.extentions.name @interface.extentions.definition) @interface.end_point) @interface.definition

; Exported interface doc
(
  (comment) @interface.doc
  (export_statement
    (interface_declaration) @interface.definition)
)

; Exported interface
(export_statement
  (interface_declaration) @interface.definition) @interface.start_point

; Property signature name
(property_signature
  name: (_) @property_signature.name @property_signature.end_point) @property_signature.definition

; Property signature type
(property_signature
  type: (type_annotation
    (_) @property_signature.type) @property_signature.end_point) @property_signature.definition

; Property signature doc
(
  (comment) @interface.doc
  (property_signature) @property_signature.definition
)

; ---- Type aliases

; Type alias doc
(
  (comment) @interface.doc
  (type_alias_declaration) @type_alias.definition
)

; Type alias name
(type_alias_declaration
  name: (_) @type_alias.name @type_alias.end_point) @type_alias.definition

; Type alias type params
(type_alias_declaration
  type_parameters: (type_parameters
    (type_parameter
      (type_identifier) @type_alias.generics.name @type_alias.generics.definition)) @type_alias.end_point) @type_alias.definition

; Type alias export doc
(
  (comment) @type_alias.doc
  (export_statement
    (type_alias_declaration) @type_alias.definition)
)

; Type alias export
(export_statement
  (type_alias_declaration) @type_alias.definition) @type_alias.start_point

