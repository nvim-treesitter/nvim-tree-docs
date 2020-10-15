; Javascript

; ---- Functions

(function_declaration
  name: (identifier) @function.name) @function.definition

; Function doc
; (
;   (comment) @function.doc
;   (function_declaration) @function.definition
; )

(function_declaration
  body: ((statement_block) @function.end_point)
         (#set! function.end_point.position "start")) @function.definition

; Return statement
(function_declaration
  body: (statement_block
    (return_statement) @function.return_statement)) @function.definition

; Exported function
(export_statement
  (function_declaration) @function.definition) @function.start_point @function.export

; Function export doc
; (
;   (comment) @function.doc
;   (export_statement
;     (function_declaration) @function.definition)
; )

; Function param name
(function_declaration
  parameters: (formal_parameters
    (identifier) @function.parameters.name @function.parameters.definition)) @function.definition

; Function param default value
(function_declaration
  parameters: (formal_parameters
    (assignment_pattern
      left: (identifier) @function.parameters.definition @function.parameters.name
      value: (_) @function.parameters.default_value @function.parameters.optional))) @function.definition

; ----- Variables

; Variable name
(lexical_declaration
  (variable_declarator
    name: (identifier) @variable.name) @variable.definition) @variable.start_point

; Variable initializer
(lexical_declaration
  (variable_declarator
    value: (_) @variable.initial_value) @variable.definition)

; Variable doc
; (
;   (comment) @variable.doc
;   (lexical_declaration
;     (variable_declarator) @variable.definition)
; )

; Exported variable
(export_statement
  (lexical_declaration
    (variable_declarator) @variable.definition)) @variable.start_point @variable.export

; Exported variable doc
; (
;   (comment) @variable.doc
;   (export_statement
;     (lexical_declaration
;       (variable_declarator) @variable.definition))
; )

; ----- Methods

(method_definition
  name: (property_identifier) @method.name) @method.definition

(method_definition
  parameters: (formal_parameters) @method.end_point) @method.definition

; Method class name
(class_declaration
  name: (_) @method.class
  body: (class_body
    (method_definition) @method.definition))

(method_definition
  body: ((statement_block) @method.end_point)
         (#set! method.end_point.position "start")) @method.definition

; Method return statement
(method_definition
  body: (statement_block
    (return_statement) @method.return_statement)) @method.definition

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

; ; ----- Classes

; Classes
(class_declaration
  name: (_) @class.name) @class.definition

(class_declaration
  body: ((class_body) @class.end_point)
         (#set! class.end_point.position "start")) @class.definition

; Class doc
; (
;   (comment) @class.doc
;   (class_declaration) @class.definition
; )

(class_declaration
  (class_heritage
    (identifier) @class.extentions.name @class.extentions.definition)) @class.definition

; Exported class doc
; (
;   (comment) @class.doc
;   (export_statement
;     declaration: (class_declaration) @class.definition)
; )

; Exported class
(export_statement
  declaration: (class_declaration) @class.definition) @class.export @class.start_point

; Member class
(class_declaration
  name: (_) @member.class
  body: (class_body
    (public_field_definition) @member.definition))

; Member name
(public_field_definition
  property: (property_identifier) @member.name @member.end_point) @member.definition

; ; Member doc
; (
;   (comment) @member.doc
;   (public_field_definition) @member.definition
; )

; ; Decorated member doc
; (
;   (comment) @member.doc
;   (decorator)+
;   (public_field_definition) @member.definition
; )

; ; Decorated member
; (
;   (decorator)+ @member.start_point
;   (public_field_definition) @member.definition
; )
