nvim-tree-docs
==============

Documentation generator using treesitter

This plugin is experimental and may not work!

## Writing templates (WIP)

Templates are by language and by `<kind>`, for example `function`. Templates are compiled into functions, meaning
functions could be used in place of templating if desired for finer controller.

### Template syntax

The template syntax is very loosly based on erb templates. Here is an example:

```
/**
 * <%= ctx.text(ctx.name) %> description
<? if ctx.export then ?>
 * @export
<? end ?>
<? for _, p in ctx.for_each(ctx.parameters) do ?>
 * @param <%= ctx.get_param_name(p) %> {any} - The <%= ctx.text(p.name) %> argument
<? end ?>
<? if ctx['return'] then ?>
 * @returns {any} The result
<? end ?>
 */
]]
```

- `<%= expression %>` -> Evaluates a value.
- `<%= expression %n>` -> Evaluates a value and inserts a newline after the expression.
- `<? lua code ?>` -> Runs lua code. Useful for conditionals or loops.
- `<@ content @>` -> Special case evaluation, in this case, inserts the content of the capture (I.E. function signature)

#### <@ content @>

You can control where docs are inserted in your template. For example, python docs are inserted below the document signature.

```
<@ content @>
    """
    Description
    """
```

This will generate:

```python
def add(a, b):
    """
    Description
    """
    return a + b
```

### Template context

The template context is a table that is passed to the template function. The keys are captures based on the query.
The context also contains utility functions as well as custom functions for a specific language. Universal context methods are.

`text(node | match)` -> Gets the text of a node
`for_each(collector)` -> Iterator for a match like `parameters`
`has_any(list_of_matches)` -> Checks if any matches exist in the list. Useful for nil checking matches.

In templates, the context is available under `ctx`.

## Writing language queries

Queries contain a couple conventions that are shared amongst all languages.

Query tag syntax is `@<kind>.<property>`

The `<kind>` tag corresponds with a template in the language specific template file.
Properties can be accessed within a template under the `ctx` (context) table.

For example a simple template `-- @param <%= ctx.text(ctx.name.node) %>`.
This would correspond to a tag `@<kind>.name`.

Properties are not predefined and can differ from language to language, but there a couple
that have special behavior.

### `@<kind>.definition`

This is the most important one and is required for each `<kind>`.
This defines the node that defines the `<kind>`. If multiple queries
match the same definition node, those entries will be merged together.
This is very important for function parameters where multiple matches
need to be grouped under the same function definition.

For example, that this javascript query.

```scheme
(function_declaration
  name: (identifier) @function.name
  body: (statement_block
    (return_statement)? @function.return)) @function.definition

(export_statement
  (function_declaration) @function.definition) @function.export
```

This will match both these functions.

```javascript
function test() {}

export function test() {}
```

The key difference is one will have an `export` node associated with it. Both queries
match the function that is exported but they get merged into a single data model
because both `@function.definition` tags match the same node at the same position.

### `@<kind>.<kind>.definition`

Kind queries can be nested to define multiple different node merge points. This can be done
by providing multiple, nested definition tags. For example in function parameters. A nested `<kind>`
can be thought of as a list of similiar items.

### `@<kind>.start_point`

When docs are inserted into the document, it will insert the docs at the indentation and position
of the definition node (`@<kind>.definition`). This can be changed, if you need to keep the same definition
node, but need a different start point to insert.

For example, that this javascript query.

```scheme
(function_declaration
  name: (identifier) @function.name
  body: (statement_block
    (return_statement)? @function.return_statement)) @function.definition

(export_statement
  (function_declaration) @function.definition) @function.start_point @function.export
```

If we doc'ed the following functions WITHOUT the root tag, we would get this:

```javascript
/**
 * test
 */
function test() {}

       /**
        * test
        */
export function test() {}
```

Including the start_point tag flags the export_statement node as the root node INSTEAD of the definition node.

### `@<kind>.end_point`

This flags the end node that document can be triggered from. For example, the end of a function signature.
This is important, because it allows us to trigger docs on a multiline signature.

For example, that this javascript query.

```scheme
(
  (comment)+? @function.doc
  (function_declaration
    name: (identifier) @function.name
    parameters: (formal_parameters) @function.end_point
    body: (statement_block
      (return_statement)? @function.return)) @function.definition
)
```

This flags the parameters node as the end node for the signature. This allows us
to doc signatures that look like this.

```javascript
function test(
  someVeryLongNameThatRequiresUsToWrap,
  blorg, // <- We can trigger here to generate docs with no problem
  boom
) {
  return;
}
```

The furtherest end node will be used if there are overlapping end_points.
You should always have an end_point defined in order to avoid unwanted document triggers.

### `@<kind>.doc`

The doc references the current doc that is preceding the definition node. This gives access to existing
documentation to either parse, update, or remove with updated information.
