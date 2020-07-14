nvim-tree-docs
==============

Documentation generator using treesitter

This plugin is experimental and may not work!

TODO: add more docs!

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
    (return_statement)? @function.return)) @function.definition

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

### `@<kind>.insert_<direction>_at_<column>`

This tag offers very fine control on where to insert our docs. We can specify whether it's inserted
above or below the tagged node as well as additional indentation from the `start_point`.

Take this python query for example.

```scheme
(function_definition
  name: (identifier) @function.name) @function.definition @function.insert_below
```

This will generate the following documentation.

```python
def add(a, b):
"""
Description
"""
    return a + b
```

This inserts the doc comment below the node instead of above it (default).
We can add additional indentation from the start node by adding a column to the tag.

```scheme
(function_definition
  name: (identifier) @function.name) @function.definition @function.insert_below_at_4
```

This will generate the following documenation.

```python
def add(a, b):
    """
    Description
    """
    return a + b
```

Note, this comment is inserted with columns on top of the start nodes column.
