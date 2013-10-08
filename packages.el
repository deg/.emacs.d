(when (< emacs-major-version 24)
  (warn "DEG emacs environment requires Emacs 24 or later, not %s." emacs-version))

;;; Load packages
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))
(defvar my-packages '(;; Good
		      magit              ;; Nice interface to Git
		      clojure-mode       ;; Clojure editing
		      nrepl              ;; New interface to leiningen
		      undo-tree	         ;; Tree-based undo
		      elein              ;; Interface to leiningen commands
		      rainbow-delimiters ;; Subtle parens colorization
		      auto-complete      ;; Auto completion
		      popup              ;; Popups for auto-complete (I think)
		      ac-nrepl           ;; Auto completion for nrepl

		      ;; Maybe drop
		      ;;paredit
		      smartparens
		      ))
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))
