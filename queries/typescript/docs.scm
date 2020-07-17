; ---- Functions

; Function generics
(function_declaration
  type_parameters: (type_parameters
    (type_parameter
      (type_identifier) @function.generics.name @function.generics.definition))) @function.definition

; Function return type
(function_declaration
  return_type: (type_annotation
    (_) @function.return_type @function.end_point)) @function.definition

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

; Variable initializer
(lexical_declaration
  (variable_declarator
    type: (type_annotation
      (_) @variable.type)) @variable.definition)

; ----- Methods

; Method type parameters
(method_definition
  type_parameters: (type_parameters
    (type_parameter
      (type_identifier) @method.generics.name @method.generics.definition))) @method.definition

; Method return type
(method_definition
  return_type: (type_annotation
    (_) @method.return_type) @method.end_point) @method.definition

; Method params
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

; ; ----- Classes

; Classes

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

; ; ---- Interfaces

; ; Interface doc
; (
;   (comment) @interface.doc
;   (interface_declaration) @interface.definition
; )

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
; (
;   (comment) @interface.doc
;   (export_statement
;     (interface_declaration) @interface.definition)
; )

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

; ; Property signature doc
; (
;   (comment) @interface.doc
;   (property_signature) @property_signature.definition
; )

; ; ---- Type aliases

; ; Type alias doc
; (
;   (comment) @interface.doc
;   (type_alias_declaration) @type_alias.definition
; )

; Type alias name
(type_alias_declaration
  name: (_) @type_alias.name @type_alias.end_point) @type_alias.definition

; Type alias type params
(type_alias_declaration
  type_parameters: (type_parameters
    (type_parameter
      (type_identifier) @type_alias.generics.name @type_alias.generics.definition)) @type_alias.end_point) @type_alias.definition

; ; Type alias export doc
; (
;   (comment) @type_alias.doc
;   (export_statement
;     (type_alias_declaration) @type_alias.definition)
; )

; Type alias export
(export_statement
  (type_alias_declaration) @type_alias.definition) @type_alias.start_point

