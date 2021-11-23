; ECMAScript base

; ---- Functions

[
  (function_declaration name: (identifier) @function.name)
  (generator_function_declaration name: (identifier) @function.name)
] @function.definition

(generator_function_declaration) @function.definition @function.generator

; Generator yields
(generator_function_declaration
  body: (statement_block
    (expression_statement
      (yield_expression
        (identifier) @function.yields)))) @function.definition

; Function doc
((comment) @function.doc @function.edit_start_point
 .
 (function_declaration) @function.definition)

[
  (function_declaration
    body: ((statement_block) @function.end_point)
           (#set! function.end_point.position "start"))
  (generator_function_declaration
    body: ((statement_block) @function.end_point)
           (#set! function.end_point.position "start"))
] @function.definition

; Return statement
[
  (function_declaration
    body: (statement_block
      (return_statement) @function.return_statement))
  (generator_function_declaration
    body: (statement_block
      (return_statement) @function.return_statement))
] @function.definition

; Exported function

[
  (export_statement (function_declaration) @function.definition)
  (export_statement (generator_function_declaration) @function.definition)
] @function.export @function.start_point

; Function export doc
((comment) @function.doc @function.edit_start_point
 .
 (export_statement
   (function_declaration) @function.definition))

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
((comment) @variable.doc
 .
 (lexical_declaration
   (variable_declarator) @variable.definition))

; Exported variable
(export_statement
  (lexical_declaration
    (variable_declarator) @variable.definition)) @variable.start_point @variable.export

; Exported variable doc
((comment) @variable.doc
 .
 (export_statement
   (lexical_declaration
     (variable_declarator) @variable.definition)))

; ----- Methods

(method_definition
  name: (property_identifier) @method.name) @method.definition

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

; ----- Classes

; Classes
(class_declaration
  name: (_) @class.name) @class.definition

(class_declaration
  body: ((class_body) @class.end_point)
         (#set! class.end_point.position "start")) @class.definition

; Class doc
((comment) @class.doc
 .
 (class_declaration) @class.definition)

; Exported class doc
((comment) @class.doc
 .
 (export_statement
   declaration: (class_declaration) @class.definition))

; Exported class
(export_statement
  declaration: (class_declaration) @class.definition) @class.export @class.start_point
