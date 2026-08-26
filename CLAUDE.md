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
- **Package archives**: Emacs runs `package-initialize` itself before `init.el`, reading only the GNU archives; `packages.el` adds MELPA afterwards, so `package-read-all-archive-contents` must run before any install or every MELPA package reports "unavailable". It is guarded to run only when something is actually missing (~125ms of a ~570ms startup). A failed install still aborts `packages.el` and with it the rest of init — see bead `emacs-9gp`.
- **Experimental packages**: `beads` is installed via `use-package :vc` (not on MELPA yet) — this is intentionally separate from the main `my-packages` list.
- **Byte compilation**: Not used for this config — there are deliberately no `.elc` files here, so an edited `.el` always takes effect on the next restart. Do not byte-compile these files or run `M-x byte-recompile-directory` on this directory. A `.elc` shadows its `.el` (`load-prefer-newer` is nil, and `init.el` loads modules by base name), so a stale one makes edits silently inert — which has cost real debugging time. Compiling bought nothing anyway: measured startup was 568ms compiled vs 566ms from source, because the time goes on loading packages in `elpa/`, not on ~1900 lines of config. This build has no native compilation (`native-comp-available-p` is nil).
- **Cheat sheets**: `cheatsheets/*.md`, opened by `C-c ?` (`my-cheatsheet` in `init.el`). **Seeded once from live keymap dumps and hand-maintained thereafter — never regenerate them.** The point is that entries get deleted as they become muscle memory, so a refresh pass would silently undo every prune; `git log cheatsheets/` is meant to read as a record of what has been learned. They lint under `~/.markdownlint-cli2.jsonc`, whose `MD060` requires table pipes to be column-aligned. If a new sheet is ever needed, closed bead `emacs-cvc` records the keymap-dumping method that seeded these.
- **No xwidget support**: `(featurep 'xwidget-internal)` is nil, so there is no WebKit widget and nothing can render HTML inside Emacs beyond `eww`/`shr`. Test with `featurep`, not `fboundp` — `(fboundp 'xwidget-webkit-browse-url)` returns t from an autoload even on a build without the feature, which is a false positive. This is why Markdown preview splits into pandoc-into-eww for local reading and `grip-mode` in an external browser for GitHub fidelity.
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

## Verifying a config change

Load the whole config, not a piece of it:

```bash
emacs --batch -l ~/.emacs.d/init.el      # exit 0 means init survives
/usr/bin/time -p emacs --batch -l ~/.emacs.d/init.el   # ~0.7-0.9s is normal
```

Evaluating a hand-picked region of `init.el` in `emacs -Q --batch` tests the logic
but proves nothing about whether Emacs still starts — it misses load-order bugs
entirely, which is how a broken `packages.el` once reached a real restart.

Two traps when inspecting keymaps from batch:

- `substitute-command-keys "\{some-map}"` resolves every command's docstring and
  autoloads much of the config; against this init it hangs rather than returning.
  Walk the map with `map-keymap` instead.
- Entering `python-mode` or `rjsx-mode` to sample their bindings starts lsp and
  flycheck and hangs too. Read the mode's keymap variable directly.

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
