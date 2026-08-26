# Markdown & text

Delete lines once you no longer need them. `C-c C-v` here toggles editing.

## Reading

| Key         | Does                                                        |
|-------------|-------------------------------------------------------------|
| `C-c C-v`   | Toggle the formatted view: headers scaled, `*` and backticks hidden |
| `q`         | In the view: back to editing (or dismiss a cheat sheet)      |
| `C-c C-c l` | Live preview -- renders into an eww window on every save     |
| `C-c C-c p` | Render once, open in the external browser                    |
| `M-x grip-mode` | Preview exactly as GitHub renders it (needs network)     |
| `C-c C-x RET`   | Hide markup without leaving the buffer editable          |
| `C-c C-x TAB`   | Show inline images                                       |

## Moving by structure

| Key       | Does                                    |
|-----------|-----------------------------------------|
| `TAB`     | Cycle a heading: folded / children / all |
| `S-TAB`   | Cycle the whole buffer                   |
| `C-c C-n` | Next heading                             |
| `C-c C-p` | Previous heading                         |
| `C-c C-f` | Next heading, same level                 |
| `C-c C-b` | Previous heading, same level             |
| `C-c C-u` | Up to the parent heading                 |
| `C-c C-M-h` | Mark this subtree                      |

## Writing

| Key         | Does                                              |
|-------------|---------------------------------------------------|
| `C-c C-s b` | Bold -- wraps the region or the word at point      |
| `C-c C-s i` | Italic                                             |
| `C-c C-s c` | Inline code                                        |
| `C-c C-s C` | Fenced code block, prompts for the language        |
| `C-c C-s q` | Blockquote                                         |
| `C-c C-s t` | Insert a table, prompts for size                   |
| `C-c C-s l` | Insert a link                                      |
| `C-c C-s [` | Insert a `- [ ]` checkbox                          |
| `C-c C-s 1` | Heading level 1 (`2`..`6` likewise)                |
| `C-c C-s h` | Heading, guessing the level from context           |
| `C-c -`     | Horizontal rule                                    |
| `C-*`       | Wrap the region in `*` (smartparens)               |

## Restructuring

| Key           | Does                                          |
|---------------|-----------------------------------------------|
| `C-c <left>`  | Promote: heading up a level, list item outdent |
| `C-c <right>` | Demote                                         |
| `C-c <up>`    | Move this item or subtree up                   |
| `C-c <down>`  | Move it down                                   |
| `M-RET`       | New list item at the same level                |
| `C-c C-d`     | Do the thing at point: tick a checkbox, follow a link |
| `C-c C-k`     | Kill the thing at point, keeping its text      |
| `C-c C-c n`   | Renumber a messed-up ordered list              |

## Tables

| Key             | Does                          |
|-----------------|-------------------------------|
| `TAB`           | Next cell, realigning the row  |
| `C-c S-<right>` | Insert a column                |
| `C-c S-<left>`  | Delete a column                |
| `C-c S-<down>`  | Insert a row                   |
| `C-c S-<up>`    | Delete a row                   |
| `C-c C-c ^`     | Sort the rows                  |
| `C-c C-c t`     | Transpose the table            |

## Links & code

| Key         | Does                                                  |
|-------------|-------------------------------------------------------|
| `C-c C-l`   | Insert a link                                          |
| `C-c TAB`   | Insert an image                                        |
| `C-c C-o`   | Follow the link at point                               |
| `M-n`/`M-p` | Next / previous link                                   |
| `C-c '`     | Edit the code block at point in its own language's mode |
| `C-c C-c c` | List reference links that are defined but never used   |

## Any text buffer

| Key       | Does                                              |
|-----------|---------------------------------------------------|
| `M-q`     | Re-wrap this paragraph at column 88                |
| `M-SPC`   | Collapse surrounding whitespace                    |
| `C-c ;`   | Comment out the region                             |
| `C-c TAB` | Open the URL at point in a browser (outside Markdown) |
| `M-=`     | Compare this window with the next                  |
| `C-x g`   | Go to line                                         |
| `C-c ?`   | This picker                                        |
