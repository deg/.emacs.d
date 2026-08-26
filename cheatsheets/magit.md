# Magit

Delete lines once you no longer need them. `C-c C-v` here toggles editing.

Magit is not a keybinding system, it is a menu system. Almost nothing here is
worth memorising -- learn the two doors and let the menus teach you the rest.

## The two doors

| Key       | Opens                                                    |
|-----------|----------------------------------------------------------|
| `C-c g`   | `magit-status` -- the main view, from any buffer          |
| `C-c M-g` | Git for **this file only**: blame, log, stage this hunk   |
| `?`       | Inside any magit buffer: the whole command menu           |

`?` is the one to learn. Every menu it opens shows its own options, and `?`
again inside a menu explains them. That is the discovery mechanism.

## Reading the status buffer

| Key       | Does                                        |
|-----------|---------------------------------------------|
| `TAB`     | Expand or collapse the section at point      |
| `C-<tab>` | Cycle this section through its detail levels |
| `S-TAB`   | Cycle the whole buffer                       |
| `1`..`4`  | Show everything at that depth                |
| `g`       | Refresh                                      |
| `RET`     | Visit the thing at point                     |
| `q`       | Leave                                        |

## The verbs

Each of these opens a menu rather than acting immediately.

| Key | Menu       | Key | Menu        |
|-----|------------|-----|-------------|
| `s` | Stage      | `c` | Commit      |
| `u` | Unstage    | `b` | Branch      |
| `k` | Discard    | `m` | Merge       |
| `d` | Diff       | `r` | Rebase      |
| `l` | Log        | `F` | Pull        |
| `z` | Stash      | `P` | Push        |
| `X` | Reset      | `f` | Fetch       |
| `A` | Cherry-pick | `t` | Tag        |
| `B` | Bisect     | `%` | Worktree    |
| `:` | Run a raw git command | `!` | Run a command |

## Inside a menu

| Key       | Does                                              |
|-----------|---------------------------------------------------|
| `C-g`     | Back out                                          |
| `?`       | Explain the options on this menu                  |
| `C-x s`   | Save the flags you set as the default for next time |

Menus are two-part: lowercase letters set switches and options, uppercase or
`RET` performs the action.

## Worth knowing exists

| Where            | What                                             |
|------------------|--------------------------------------------------|
| `C-c M-g`        | Blame this file, or stage just the hunk at point  |
| `l` then `l`     | Log for the current branch                        |
| `d` then `r`     | Diff a range                                      |
| `z` then `z`     | Stash everything, including staged changes        |
| `b` then `s`     | Create and check out a branch from a starting point |
| `r` then `i`     | Interactive rebase                                |
| `%`              | Worktrees -- a second checkout without a second clone |
| `M-.`            | In a diff, visit the file in the other window     |
