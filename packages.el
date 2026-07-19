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
(when (not package-archive-contents)
  (package-refresh-contents))
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
                      ;; beads           ;; https://codeberg.org/ctietze/beads.el - not yet on Melpa
                      ))
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; [TODO] Move into main list above when it works
(use-package beads
  :vc (:url "https://codeberg.org/ctietze/beads.el"
       :lisp-dir "lisp"
       :rev :newest))


;; vterm — a proper terminal emulator inside Emacs, based on libvterm.
;; Unlike ansi-term/shell/eshell, vterm runs a real terminal (not a comint buffer),
;; so ncurses apps (htop, vim, etc.) and shell prompts with color/cursor magic work.
;;
;; System requirements (both must be installed before Emacs compiles the module):
;;   cmake  — brew install cmake   (used to build the native module)
;;   libtool — brew install libtool (already installed)
;;
;; On first use, Emacs will compile a small C module (vterm-module.so).
;; If it fails, run: M-x vterm-module-compile
(use-package vterm
  :ensure t
  :config
  ;; Use the login shell so .zshrc / .bash_profile are sourced, giving the same
  ;; environment (PATH, aliases, etc.) you'd get in a normal terminal window.
  (setq vterm-shell (concat "/bin/zsh --login"))
  ;; Keep a generous scrollback — the default (1000) is easy to exhaust.
  (setq vterm-max-scrollback 10000))

(declare-function vterm-send-key "vterm")
(declare-function vterm-send-string "vterm")
(with-eval-after-load 'vterm
  (define-key vterm-mode-map (kbd "C-c C-[")
              (lambda () (interactive)
                (vterm-send-key "<escape>")))
  (define-key vterm-mode-map (kbd "S-<return>")
              (lambda () (interactive)
                (vterm-send-string "\n"))))

;; claude-code.el — Claude Code integration (https://github.com/stevemolitor/claude-code.el).
;; C-c c is a prefix:
;;   C-c c c  start Claude for this project (first one is named "default")
;;   C-c c i  start another named session (RET at the prompt = auto-numbered)
;;   C-c c b  switch between this project's sessions (completing-read)
;;   C-c c B  switch across all projects;  C-c c k kill;  C-c c m full menu
;; Installed from git (:vc) — the MELPA package named "claude-code" is a
;; DIFFERENT project (yuya373's); never install that one from the archive.
;; Uses our existing vterm as the terminal backend.

;; ghostel — alternative terminal backend worth trying: libghostty-based
;; (the engine behind the Ghostty terminal), typically faster than vterm
;; and renders the Claude TUI most faithfully. On MELPA; its native module
;; is a prebuilt binary that auto-downloads on first use (no compile step).
;; To try it: uncomment this line, restart Emacs, and switch the backend
;; setq below from 'vterm to 'ghostel.
(use-package ghostel :ensure t)

(use-package claude-code
  :vc (:url "https://github.com/stevemolitor/claude-code.el" :rev :newest)
  :bind-keymap ("C-c c" . claude-code-command-map)
  :config
  ;; Backend: 'vterm (current) or 'ghostel (see use-package comment above).
  (setq claude-code-terminal-backend 'ghostel)

  ;; Window behavior — using the package defaults: the Claude window opens
  ;; below the current one and focus stays where you are. Alternatives:
  ;; (setq claude-code-display-window-fn #'pop-to-buffer-same-window) ; take over
  ;;         the current window, like the old my/claude-vterm did
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
  (add-hook 'claude-code-start-hook #'my/claude-rename-cli-session))


;; Don't warn about magit-auto-revert-mode
(setq magit-last-seen-setup-instructions "1.4.0")

;; Enable which-key mode (see https://github.com/justbur/emacs-which-key)
;; (broken on Ubuntu 19.04 28May19?)
;; (which-key-mode)

