# Prefix map

Where the commands live. One line per prefix; details in the per-topic sheets.

## The convention

Emacs splits `C-c` in two, and almost everything follows it:

| Shape             | Belongs to                                                |
|-------------------|-----------------------------------------------------------|
| `C-c C-`*letter*  | The **major mode** -- means something different per buffer |
| `C-c` *letter*    | **You**, by convention. Packages that squat here are guests |

So `C-c C-c` is "do the main thing for this kind of file", and `C-c C-s` is
markdown styling in a `.md` buffer and a REPL send in a Python one.

## Everywhere

| Prefix    | Leads to                                    | Count |
|-----------|---------------------------------------------|-------|
| `C-c p`   | **projectile** -- project-wide everything    | 103   |
| `C-c c`   | **claude-code**                              | 26    |
| `C-c !`   | **flycheck** -- errors, wherever it is on    | 19    |
| `C-c g`   | `magit-status` (single key, not a prefix)    | 1     |
| `C-c M-g` | `magit-file-dispatch` -- git for this file   | 1     |
| `C-c ;`   | `comment-region`                             | 1     |
| `C-c #`   | `clear-python-shell`                         | 1     |
| `C-c ?`   | This picker                                  | 1     |
| `C-c TAB` | `browse-url` (Python and Markdown shadow it) | 1     |

## Per major mode

| Prefix      | In Markdown          | In Python            | In a REPL / comint  |
|-------------|----------------------|----------------------|---------------------|
| `C-c C-c`   | Export & preview (14) | Send buffer          | Interrupt           |
| `C-c C-s`   | Styling: bold, code, tables (29) | Send string | Search history  |
| `C-c C-t`   | Headers (12)          | Skeletons: def, class, for (7) | --        |
| `C-c C-x`   | Toggles: markup, images (11) | --            | Prefix              |
| `C-c C-a`   | Links & footnotes (6) | --                   | Beginning of line   |
| `C-c TAB`   | Insert image          | Imports: add, fix, sort (4) | --           |
| `C-c C-z`   | --                    | Jump to the REPL     | --                  |
| `C-c C-v`   | Formatted view        | `python-check`       | --                  |

Elisp is the quiet one: only `C-c C-e` (eval), `C-c C-b` (byte-compile buffer),
`C-c C-f` (byte-compile file). Everything else there is `C-M-x` and `C-x C-e`.

## Not on C-c at all

| Key       | Leads to                                            |
|-----------|-----------------------------------------------------|
| `?`       | **magit**: the dispatch menu, inside any magit buffer |
| `C-x`     | Files, windows, buffers -- plus your own additions below |
| `M-n`/`M-p` | Next / previous **error** (compilation, grep, flycheck) |
| `<f9>`/`<f10>` | Undo / redo                                         |

## Your own top-level keys

| Key             | Does                                  |
|-----------------|---------------------------------------|
| `C-x !`         | `ghostel` -- a real terminal in Emacs  |
| `C-x o`         | `ace-window` -- pick a window by letter |
| `C-x u`         | `undo-tree-visualize`                  |
| `C-x g`         | `goto-line`                            |
| `C-x C-b`       | `ibuffer`                              |
| `C-x C-r`       | Recent files                           |
| `M-<up>`/`M-<down>` | Scroll the window                  |
| `C-z`/`M-z`     | Scroll one line                        |
| `M-=`           | Compare this window with the next      |
| `M-SPC`         | Collapse whitespace                    |

## Dead prefixes

`s-l` (all of LSP) and `H-` (nine smartparens commands) are bound but
unreachable -- nothing on this Mac produces Super or Hyper. Both Command keys
and both Option keys are Meta. Use `M-x lsp-...` meanwhile. See beads
`emacs-voi` and `emacs-56j`.
