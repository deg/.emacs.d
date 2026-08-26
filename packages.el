;;; packages.el --- Package installation  -*- lexical-binding: t; -*-

(when (< emacs-major-version 24)
  (warn "DEG emacs environment requires Emacs 24 or later, not %s." emacs-version))

;;; Load packages
(require 'package)
;; 25Jun21 - Marmalade is dead and duplicat?? Remove here, and let's see
;; (add-to-list 'package-archives '("marmalade"    . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa"        . "http://melpa.org/packages/") t)
;; 25Jul18 - Moved to using just stable archive, after Cider broke on me once too often.
;; (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;;25Oct21;; (package-initialize)
(defvar my-packages '(;; Good
                      magit                ;; Nice interface to Git
                      exec-path-from-shell ;; https://github.com/purcell/exec-path-from-shell.  Fix path right for lein on mac.
                      undo-tree            ;; Tree-based undo

                      which-key            ;; Show commmand options

                      auto-complete        ;; Auto completion
                      popup                ;; Popups for auto-complete (I think)

                      cider                ;; Clojure interface
                      clojure-mode         ;; Clojure editing
                      smartparens          ;; Auto parens typing
                      ;; clojure-cheatsheet   ;; Documentation
                      rainbow-delimiters   ;; Subtle parens colorization
                      company              ;; Completion mode

                      ;;nrepl              ;; New interface to leiningen
                      ;;nrepl-ritz         ;; Debugger interface
                      ;; elein             ;; Interface to leiningen commands
                      ;; ac-nrepl          ;; Auto completion for nrepl


                      ;; Libs for Python from https://realpython.com/emacs-the-best-python-editor/
                      ;; Later [Feb2025] replaced by my latest version of python.el
                      ;; [Oct2025] switched from blacken+py-isort to ruff-format for consistency
                      ;; better-defaults
                      ;; elpy
                      ;; flycheck
                      ;; blacken      ; replaced by ruff-format-buffer
                      ;; py-isort     ; replaced by ruff-format-buffer (handles imports too)
                      ;; ;;material-theme

                      better-defaults ;; https://git.sr.ht/~technomancy/better-defaults

                      ace-window   ;; Letter-based window picker (bound to C-x o in display.el)
                      grip-mode    ;; GitHub-identical Markdown preview (see below)
                      ;; beads           ;; https://codeberg.org/ctietze/beads.el - not yet on Melpa
                      ))
;; Emacs calls `package-initialize' itself before init.el is loaded, and that
;; call reads only the archives configured at that moment -- the two GNU ones.
;; MELPA is added above, which happens afterwards, so its cached index sits on
;; disk unread and every MELPA package looks unavailable to `package-install'.
;; Nothing notices while they are all installed already; the first new one added
;; to `my-packages' fails with "Package 'foo' is unavailable" and takes the rest
;; of init down with it.  `package-read-all-archive-contents' re-reads the index
;; now that MELPA is in the list, without going to the network.
;;
;; It costs roughly 125ms of a 570ms startup, so it runs only when something
;; actually needs installing, which is almost never.
(let ((missing (seq-remove #'package-installed-p my-packages))
      (refreshed nil))
  (when missing
    (package-read-all-archive-contents)
    (dolist (p missing)
      ;; Still absent from the cached index means the cache predates the
      ;; package, which is the one case worth a network round trip.
      (unless (or (assq p package-archive-contents) refreshed)
        (package-refresh-contents)
        (setq refreshed t))
      (package-install p))))


;; [TODO] Move into main list above when it works
(use-package beads
  :vc (:url "https://codeberg.org/ctietze/beads.el"
       :lisp-dir "lisp"
       :rev :newest))


;; claude-code.el — Claude Code integration (https://github.com/stevemolitor/claude-code.el).
;; C-c c is a prefix:
;;   C-c c c  start Claude for this project (first one is named "default")
;;   C-c c i  start another named session (RET at the prompt = auto-numbered)
;;   C-c c b  switch between this project's sessions (completing-read)
;;   C-c c B  switch across all projects;  C-c c k kill;  C-c c m full menu
;; Installed from git (:vc) — the MELPA package named "claude-code" is a
;; DIFFERENT project (yuya373's); never install that one from the archive.
;; Uses ghostel as the terminal backend (see below).

;; ghostel — a real terminal emulator inside Emacs, built on libghostty (the
;; engine behind the Ghostty terminal).  Serves two roles here: the terminal
;; backend for the Claude buffers, which it renders most faithfully, and a
;; standalone terminal (M-x ghostel, bound to C-x ! in bindings.el).
;; Its native module is a prebuilt binary with no compile step, but the
;; download is manual: on a new machine, run M-x ghostel-download-module once.
(use-package ghostel :ensure t)

(use-package claude-code
  :vc (:url "https://github.com/stevemolitor/claude-code.el" :rev :newest)
  :bind-keymap ("C-c c" . claude-code-command-map)
  :config
  ;; Backend: 'ghostel (see use-package block above).  The package also
  ;; supports 'eat and 'vterm, neither of which is installed here.
  (setq claude-code-terminal-backend 'ghostel)

  ;; Window behavior — using the package defaults: the Claude window opens
  ;; below the current one and focus stays where you are. Alternatives:
  ;; (setq claude-code-display-window-fn #'pop-to-buffer-same-window) ; take over
  ;;         the current window instead of splitting
  ;; (setq claude-code-toggle-auto-select t) ; move focus into the Claude
  ;;         window whenever it opens

  (claude-code-mode)

  ;; At the session-name prompt, plain RET picks the next free number
  ;; (the package itself refuses an empty name).
  (defun my/claude-name-or-number (orig dir existing &optional force-prompt)
    (if (or existing force-prompt)
        (let ((name (string-trim
                     (read-string (format "Claude session name for %s (RET = auto): "
                                          (abbreviate-file-name dir))))))
          (cond ((string-empty-p name)
                 (let ((n 2))
                   (while (member (number-to-string n) existing)
                     (setq n (1+ n)))
                   (number-to-string n)))
                ((member name existing)
                 (funcall orig dir existing force-prompt))
                (t name)))
      "default"))
  (advice-add 'claude-code--prompt-for-instance-name
              :around #'my/claude-name-or-number)

  ;; When a session has a real name, tell the Claude CLI about it too,
  ;; so /resume later shows the same name. The timer gives the Claude
  ;; TUI a few seconds to finish starting before we type into it.
  (defun my/claude-rename-cli-session ()
    (let ((buf (current-buffer))
          (name (claude-code--extract-instance-name-from-buffer-name
                 (buffer-name))))
      (when (and name (not (equal name "default")))
        (run-at-time 4 nil
                     (lambda ()
                       (when (buffer-live-p buf)
                         (with-current-buffer buf
                           (claude-code--term-send-string
                            claude-code-terminal-backend
                            (format "/rename %s" name))
                           (sit-for 0.2)
                           (claude-code--term-send-string
                            claude-code-terminal-backend (kbd "RET")))))))))
  (add-hook 'claude-code-start-hook #'my/claude-rename-cli-session)

  ;; Ghostel replaces the buffer's keymap whenever it leaves copy/emacs/line
  ;; mode (which engage automatically on mouse click or scroll), discarding
  ;; the claude-code bindings — notably C-g -> send Escape to interrupt the
  ;; agent. Re-apply them after every return to the normal input mode.
  (defun my/claude-restore-ghostel-keymap (&rest _)
    (when (and (eq claude-code-terminal-backend 'ghostel)
               (claude-code--buffer-p (current-buffer)))
      (claude-code--term-setup-keymap 'ghostel)))
  (advice-add 'ghostel-semi-char-mode :after #'my/claude-restore-ghostel-keymap))


;; grip-mode -- render Markdown exactly the way GitHub does, by handing it to
;; GitHub's own renderer through the `grip' binary (already installed via
;; Homebrew).  M-x grip-mode in a Markdown buffer starts a local server and
;; opens it; toggling the mode off shuts the server down.
;;
;; This is the fidelity check, not the everyday reader: it needs the network,
;; and GitHub's API allows only 60 unauthenticated requests an hour.  Setting
;; `grip-github-user' and `grip-github-password' (a personal access token)
;; lifts that limit.  For local, offline reading use C-c C-c l (pandoc into
;; eww) or C-c C-v (the formatted in-buffer view) instead.
;;
;; grip always opens an external browser here: its in-Emacs option renders
;; through xwidget-webkit, and this build has no xwidget support.
(defvar grip-preview-use-webkit)
(setopt grip-preview-use-webkit nil)


;; Don't warn about magit-auto-revert-mode
;; The `defvar' declares the name without giving it a value, so the byte
;; compiler knows it is a real variable; magit defines it for real on load.
(defvar magit-last-seen-setup-instructions)
(setq magit-last-seen-setup-instructions "1.4.0")

;; Enable which-key mode (see https://github.com/justbur/emacs-which-key)
;; (broken on Ubuntu 19.04 28May19?)
;; (which-key-mode)

