# Emacs Lisp

Delete lines once you no longer need them. `C-c C-v` here toggles editing.

Elisp barely uses `C-c` -- the work happens on `C-M-` and `C-x`.

## Evaluating

| Key       | Does                                               |
|-----------|----------------------------------------------------|
| `C-x C-e` | Evaluate the expression **before point**           |
| `C-M-x`   | Evaluate the top-level form point is inside        |
| `C-c C-e` | Evaluate the region, or the whole buffer if none   |
| `M-:`     | Evaluate one expression you type in the minibuffer |
| `C-j`     | In `*scratch*`: evaluate and insert the result     |

`C-M-x` on a `defvar` will not re-set an already-set variable; `C-u C-M-x`
forces it. That is the usual reason an edit seems not to take.

## Finding out what something is

| Key     | Does                                             |
|---------|--------------------------------------------------|
| `C-h f` | Describe a function                              |
| `C-h v` | Describe a variable                              |
| `C-h k` | Describe what a key does                         |
| `C-h m` | Every binding live in this buffer                |
| `C-h a` | Apropos -- search commands and variables by word |
| `M-.`   | Jump to the source of the symbol at point        |
| `M-,`   | Jump back                                        |

## Moving by structure

| Key     | Does                                 |
|---------|--------------------------------------|
| `C-M-f` | Forward over one balanced expression |
| `C-M-b` | Backward over one                    |
| `C-M-d` | Down into a list                     |
| `C-M-u` | Up out of a list                     |
| `C-M-n` | Forward over the whole list          |
| `)`     | Up out of the list (smartparens)     |
| `C-M-q` | Re-indent the expression at point    |
| `M-q`   | Re-indent and re-fill the defun      |

## Editing structure (smartparens)

| Key             | Does                                            |
|-----------------|-------------------------------------------------|
| `C-(`           | Wrap the next expression in parens              |
| `s-<backspace>` | Kill backward up a list -- **dead on this Mac** |

Nine more smartparens commands sit behind `H-`, which no key here produces.

## Byte compiling

| Key       | Does                     |
|-----------|--------------------------|
| `C-c C-b` | Byte-compile this buffer |
| `C-c C-f` | Byte-compile a file      |

Do not use these on `~/.emacs.d` -- this config is deliberately kept
uncompiled, and a stale `.elc` silently shadows your edits.

## Debugging

| Command                     | Does                                          |
|-----------------------------|-----------------------------------------------|
| `M-x debug-on-entry`        | Break when a function is called               |
| `M-x edebug-defun`          | Step through the defun at point (`C-u C-M-x`) |
| `M-x toggle-debug-on-error` | Backtrace on the next error                   |
| `M-x ielm`                  | A real Elisp REPL                             |
