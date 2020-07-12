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
by providing multiple, nested definition tags. For example in function parameters.

### `@<kind>.root`

When docs are inserted into the document, it will insert the docs at the indentation and position
of the definition node (`@<kind>.definition`). This can be changed, if you need to keep the same definition
node, but need a different root node to insert.

For example, that this javascript query.

```scheme
(function_declaration
  name: (identifier) @function.name
  body: (statement_block
    (return_statement)? @function.return)) @function.definition

(export_statement
  (function_declaration) @function.definition) @function.root @function.export
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

Including the root tag flags the export_statement node as the root node INSTEAD of the definition node.

### `@<kind>.doc`

The doc references the current doc that is preceding the definition node. This gives access to existing
documentation to either parse, update, or remove with updated information.
