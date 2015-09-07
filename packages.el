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
                      magit                ;; Nice interface to Git
                      exec-path-from-shell ;; https://github.com/purcell/exec-path-from-shell.  Fix path right for lein on mac.
                      undo-tree            ;; Tree-based undo

                      auto-complete        ;; Auto completion
                      popup                ;; Popups for auto-complete (I think)

                      cider                ;; Clojure interface
                      clojure-mode         ;; Clojure editing
                      smartparens          ;; Auto parens typing
		      clojure-cheatsheet   ;; Documentation
		      rainbow-delimiters   ;; Subtle parens colorization
		      company		   ;; Completion mode


		      ;;nrepl              ;; New interface to leiningen
		      ;;nrepl-ritz         ;; Debugger interface
;;		      elein                ;; Interface to leiningen commands


;;		      ac-nrepl           ;; Auto completion for nrepl
		      
		      ))
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; Don't warn about magit-auto-revert-mode
(setq magit-last-seen-setup-instructions "1.4.0")
