(when (< emacs-major-version 24)
  (warn "DEG emacs environment requires Emacs 24 or later, not %s." emacs-version))

;;; Load packages
(require 'package)
(add-to-list 'package-archives ' ("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))
(defvar my-packages '(;; Good
		      magit              ;; Nice interface to Git
		      clojure-mode       ;; Clojure editing
		      ;;nrepl              ;; New interface to leiningen
		      ;;nrepl-ritz         ;; Debugger interface
		      undo-tree	         ;; Tree-based undo
		      elein              ;; Interface to leiningen commands
		      rainbow-delimiters ;; Subtle parens colorization
		      auto-complete      ;; Auto completion
		      popup              ;; Popups for auto-complete (I think)
		      ;;ac-nrepl           ;; Auto completion for nrepl
		      smartparens        ;; Auto parens typing

		      ;; Maybe drop
		      ;;paredit

		      ;; New. Evaluating
		      cider
		      clojure-cheatsheet
		      
		      ))
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))
