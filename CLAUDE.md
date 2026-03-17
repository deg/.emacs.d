# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal Emacs configuration (~/.emacs.d) organized as modular `.el` files loaded by `init.el`. There is no build system or test suite — changes take effect when Emacs reloads the config or the affected file is re-evaluated.

## Loading Order

`init.el` loads modules in this sequence:
1. `packages.el` — package installation via `package.el` + MELPA
2. `python.el`, `javascript.el`, `clojure.el` — language configs
3. `display.el` — fonts, theme, UI
4. `irc.el` — rcirc IRC client
5. `linux.el`, `windows.el` — OS-specific settings
6. `bindings.el`, `bindings-smartparens.el` — keybindings last

## Key Architectural Decisions

- **Package manager**: `package.el` with MELPA only (Marmalade removed as dead; MELPA-stable removed due to CIDER breakage). New packages go in the `my-packages` list in `packages.el`.
- **Experimental packages**: `beads` is installed via `use-package :vc` (not on MELPA yet) — this is intentionally separate from the main `my-packages` list.
- **Byte compilation**: Auto-compilation was disabled (see comment in `init.el`). To recompile after edits: `M-x byte-recompile-directory`.
- **Backups**: Redirected to `~/.emacs-saves` to avoid cluttering project directories and triggering Flask auto-reload.
- **Lock files**: Disabled (`create-lockfiles nil`) to avoid interfering with Create React App.

## Language Configurations

- **Python** (`python.el`): Emacs 29+, uses `lsp-mode`/`lsp-pyright`, Poetry, Ruff (replaced Black + py-isort), tree-sitter, pytest. `C-c t` runs one test, `C-c T` runs all.
- **JavaScript** (`javascript.el`): `rjsx-mode`, ESLint via Flycheck, Prettier for formatting.
- **Clojure** (`clojure.el`): CIDER, Figwheel REPL, rainbow-delimiters, subword-mode for CamelCase.

## Debugging Init

To start Emacs with init debugging on Mac:
```
open -a /Applications/Emacs.app --args --debug-init
```

## Key Custom Settings (in `init.el` `custom-set-variables`)

- `fill-column`: 100
- `flycheck-python-ruff-maximum-line-length`: 100
- `js-indent-level`: 2
- `ns-command-modifier`: `meta` (Mac Command key acts as Meta)
- `grep-find-ignored-directories`: extended list including `.venv`, `node_modules`, `.ruff_cache`, etc.
