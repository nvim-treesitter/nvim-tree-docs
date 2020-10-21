nvim-tree-docs
==============

Highly configurable documentation generator using treesitter.

This plugin is experimental!

## Setup

nvim-tree-docs is a module for the `nvim-treesitter` plugin. You can install both by doing (vim-plug):

```vim
Plug nvim-treesitter/nvim-treesitter
Plug nvim-treesitter/nvim-tree-docs
```

You can configure `nvim-tree-docs` as part of your `nvim-treesitter` configuration.

```lua
require "nvim-treesitter.config".setup {
  tree_docs = {enable = true}
}
```

## Usage

There are two key bindings provided by default:

- `doc_node_at_cursor`: `gdd`
- `doc_all_in_range`: `gdd` (Visual)

These can be configured through the `keymap` option in the config.

## Advanced configuration

This plugin is extremely configurable. Most documentation is standardized, but our
projects and personal preferences for documentation vary. This plugin aims to add total
customization to the user.

### Core concepts

There three key components to how this plugin operates.

- `processors` -> Processors generate lines of content within a template.
- `slots` -> Slots are positions where a processor can output it's content.
- `templates` -> Templates are a list of slots, basically the ordering of processors.
                 These are by `kind` (Ex: function).
- `specs` -> Specs are a collection of templates and processors (Ex: jsdoc).

### Basic example

Here is a basic example of how this works (psuedo code).

```lua
local processors = {
  my_processor = function() -- The processor
    return "Output!!!"
  end
}

local template = { -- template
  "my_processor", -- slot
  "my_processor"  -- slot
}
```

This example would generate the lines

```
Output!!!
Output!!!
```

You get the idea... The above code doesn't actually do anything, but is just to illustrate the point.

### Configuring slots

The key advantage is they can be toggled on and off.
For example, lets say you like to include an `@author` tag on all your jsdoc classes.
You can enable the `author` slot to generate an author tag.
This is done in the configuration for the spec.

```lua
require "nvim-treesitter.config".setup {
  tree_docs = {
    enable = true,
    spec_config = {
      jsdoc = {
        slots = {
          class = {author = true}
        }
      }
    }
  }
}
```

This will generate the following output.

```javascript
/**
 * The person class
 * @author
 */
class Person {}
```

Pretty cool... but this is using the default processor for the spec, which in the case
of jsdoc, just generates a tag. What if we could modify the behavior of that processor?
We can configure author processor in the same config.

```lua
require "nvim-treesitter.config".setup {
  tree_docs = {
    enable = true,
    spec_config = {
      jsdoc = {
        slots = {
          class = {author = true}
        },
        processors = {
          author = function()
            return " * @author Steven Sojka"
          end
        }
      }
    }
  }
}
```

This will generate.

```javascript
/**
 * The person class
 * @author Steven Sojka
 */
class Person {}
```

Processors can return a single line or multiple lines.
Here's an advanced sample that will prompt the user for
an issue ticket number. If the user doesn't enter anything
the tag won't get generated.

```lua
require "nvim-treesitter.config".setup {
  tree_docs = {
    enable = true,
    spec_config = {
      jsdoc = {
        slots = {
          class = {see = true, author = true}
        },
        processors = {
          author = function() return " * @author Steven Sojka" end
          see = function()
            local ticket = vim.fn.input("Ticket: ")
            return ticket ~= "" and (" * @see " .. ticket) or []
          end
        }
      }
    }
  }
}
```

This will result in the following (assuming PROJ-X-123456 was inputted).

```javascript
/**
 * The person class
 * @author Steven Sojka
 * @see PROJ-X-123456
 */
class Person {}
```

### Configuring templates

Templates aren't traditional templates. It's basically just a set of slots in a specific order.
You can configure the template in the config.

```lua
require "nvim-treesitter.config".setup {
  tree_docs = {
    enable = true,
    spec_config = {
      jsdoc = {
        slots = {
          class = {custom = true, author = true}
        },
        templates = {
          class = {
            "doc-start" -- Note, these are implicit slots and can't be turned off and vary between specs.
            "custom"
            "author"
            "doc-end"
            "%content%"
          }
        }
      }
    }
  }
}
```

This will generate.

```javascript
/**
 * The person class
 * @custom
 * @author
 */
class Person {}
```

Note, in the above example, if we would have left out the `custom` slot in the template, it would not have output anything.


#### Builtin processors

There are some builtin processors that work across all specs (unless overridden, which is possible).

- `%content%` -> This will output the content line, in our case above it would be the class declaration line.
                 This makes it possible to wrap or put the documentation below the content line.
- `%rest%` -> This will output all slots that are enabled, but do not have an explicit slot in the template.

### Template context

This still needs to be documented...

## Writing language queries

Queries contain a couple conventions that are shared amongst all languages.

Query tag syntax is `@<kind>.<property>`

The `<kind>` tag corresponds with a template in the language specific template file.
Properties can be accessed within a processor as the first argument.

For example, a simple processor that gets the name of a nod

```lua
function(ctx) return ctx.get_text(ctx.name.node) end
```

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
