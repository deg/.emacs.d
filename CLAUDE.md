# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About the User

Long-time Emacs user since 1978 (TECO-based EMACS on DEC-20 and ITS). Very comfortable with Emacs as a user but not deeply fluent in Elisp — explain Elisp constructs when suggesting config changes. Don't change global Emacs behaviors casually.

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
- **Byte compilation**: Not used for this config — there are deliberately no `.elc` files here, so an edited `.el` always takes effect on the next restart. Do not byte-compile these files or run `M-x byte-recompile-directory` on this directory. A `.elc` shadows its `.el` (`load-prefer-newer` is nil, and `init.el` loads modules by base name), so a stale one makes edits silently inert — which has cost real debugging time. Compiling bought nothing anyway: measured startup was 568ms compiled vs 566ms from source, because the time goes on loading packages in `elpa/`, not on ~1900 lines of config. This build has no native compilation (`native-comp-available-p` is nil).
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


<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:ca08a54f -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

## Session Completion

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd dolt push
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
<!-- END BEADS INTEGRATION -->
