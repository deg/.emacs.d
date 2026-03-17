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

;; Don't warn about magit-auto-revert-mode
(setq magit-last-seen-setup-instructions "1.4.0")

;; Enable which-key mode (see https://github.com/justbur/emacs-which-key)
;; (broken on Ubuntu 19.04 28May19?)
;; (which-key-mode)

