# Python

Delete lines once you no longer need them. `C-c C-v` here toggles editing.

## Tests

| Key       | Does                                 |
|-----------|--------------------------------------|
| `C-c t`   | Run the test at point                 |
| `C-c T`   | Run all tests                         |
| `C-c p t` | Toggle between a file and its test    |
| `C-c p T` | Find the test file for this one       |

## The REPL

| Key       | Does                                            |
|-----------|-------------------------------------------------|
| `C-c C-z` | Start or jump to the REPL for this project       |
| `C-c C-c` | Send the whole buffer                            |
| `C-c C-r` | Send the region                                  |
| `C-c C-e` | Send the statement at point                      |
| `C-c C-b` | Send the block at point                          |
| `C-M-x`   | Send the function at point                       |
| `C-c C-l` | Send the file                                    |
| `C-c #`   | Clear the REPL buffer (works from anywhere)      |

## Errors

| Key         | Does                                |
|-------------|-------------------------------------|
| `M-n`/`M-p` | Next / previous error                |
| `C-c ! l`   | List all errors in the buffer        |
| `C-c ! e`   | Explain the error at point           |
| `C-c ! f`   | Try to fix the error at point        |
| `C-c ! v`   | Show which checkers are running here |
| `C-c ! x`   | Disable a misbehaving checker        |

## Imports

| Key         | Does                                  |
|-------------|---------------------------------------|
| `C-c TAB a` | Add an import for the symbol at point  |
| `C-c TAB f` | Fix missing and unused imports         |
| `C-c TAB r` | Remove an import                       |
| `C-c TAB s` | Sort imports                           |

Ruff also reformats and reorders imports on every save.

## Looking things up

| Key       | Does                                       |
|-----------|--------------------------------------------|
| `M-.`     | Jump to definition                          |
| `M-,`     | Jump back                                   |
| `C-c C-d` | Describe the symbol at point                |
| `C-c C-f` | One-line signature for the symbol at point  |
| `C-c C-j` | Jump to a definition in this file (imenu)   |
| `C-c r`   | ripgrep across the project                  |

Pyright runs behind these. Its own `s-l` prefix does not work on this Mac, so
the rest of LSP is `M-x lsp-` -- `lsp-rename`, `lsp-execute-code-action`,
`lsp-find-references`, `lsp-organize-imports`.

## Typing less

| Key         | Inserts a skeleton for |
|-------------|------------------------|
| `C-c C-t d` | `def`                  |
| `C-c C-t c` | `class`                |
| `C-c C-t f` | `for`                  |
| `C-c C-t i` | `if`                   |
| `C-c C-t w` | `while`                |
| `C-c C-t t` | `try`                  |
| `C-c C-t m` | `import`               |

## Shifting code

| Key       | Does                          |
|-----------|-------------------------------|
| `C-c <`   | Shift the region left          |
| `C-c >`   | Shift the region right         |
| `C-c C-v` | Run the checker over the file  |
