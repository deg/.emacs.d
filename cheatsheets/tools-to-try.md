# Tools to try

Not a keybinding sheet -- things installed here that you may not know you have.
Delete an entry once you have decided about it, either way.

## projectile -- `C-c p`, 103 commands

Already on. It knows every git repo you visit as a "project" and scopes commands
to it. The dozen that matter:

| Key         | Does                                        |
|-------------|---------------------------------------------|
| `C-c p f`   | Find a file anywhere in this project        |
| `C-c p p`   | Switch to another project                   |
| `C-c p b`   | Switch buffer within this project           |
| `C-c p s g` | grep the project                            |
| `C-c p r`   | Replace across the project                  |
| `C-c p t`   | Jump between a file and its test            |
| `C-c p k`   | Kill every buffer belonging to this project |
| `C-c p D`   | dired at the project root                   |
| `C-c p m`   | The full menu, if you would rather browse   |

Sub-prefixes if you go looking: `C-c p c` compile and test, `C-c p s` search,
`C-c p x` run a shell or terminal, `C-c p 4` do it in another window, `C-c p 5`
another frame, `C-c p B` bookmarks, `C-c p w` saved sessions.

## ghostel -- `C-x !`

A real terminal emulator inside Emacs, running the actual Ghostty engine. Not a
shell-in-a-buffer approximation: full-screen programs, colour and cursor
handling all work. It is also what the Claude buffers render through.

## ace-window -- `C-x o`

Already replacing `other-window`. With three or more windows open it labels each
one and you press the letter. Worth using deliberately on your screens rather
than cycling.

## undo-tree -- `C-x u`, `<f9>`, `<f10>`

Undo in Emacs is already non-linear; undo-tree draws the tree so you can see it.
`C-x u` opens the visualiser: move with `p`/`n` between states, `b`/`f` between
branches, `q` to leave. Worth one deliberate use after an undo-then-retype
tangle, which is exactly when the tree earns itself.

## which-key

Installed but switched off, behind a 2019 note about a Linux bug. Emacs 30 now
ships its own copy. It shows the menu of what can follow a prefix, a moment
after you press it -- the live version of this whole directory. Bead
`emacs-vlt`.

## consult

Present as a dependency; `C-c r` in Python buffers uses `consult-ripgrep`.
It has a lot more: `consult-line` (search the buffer with live preview),
`consult-buffer` (buffers, recent files and bookmarks in one list),
`consult-imenu`, `consult-outline`. None are bound. Try them with `M-x` first.

## beads

The issue tracker this config is developed with. `bd prime` in a terminal, or
the `beads.el` interface installed here.

## Worth a look, not installed

- `vertico` + `orderless` -- much better minibuffer completion than ido
- `expand-region` -- grow the selection by syntactic unit, repeatedly
- `avy` -- jump to any visible character in two keystrokes
- `rg.el` -- a real ripgrep results buffer rather than grep-mode
