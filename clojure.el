;;; Clojure and friends

;; rainbow delimiters
(global-rainbow-delimiters-mode)

;; CamelCase support for Java names
(add-hook 'nrepl-mode-hook 'subword-mode)
(add-hook 'clojure-mode-hook 'subword-mode)

;; Useful bindings
(global-set-key (kbd "C-c i") 'indent-region)
(global-set-key (kbd "C-c ;") 'comment-region)
(global-set-key (kbd "C-M-S-U") 'kill-backward-up-list)
;; Move nrepl binding to global context
(global-set-key (kbd "C-c C-z") 'nrepl-switch-to-repl-buffer)
(global-set-key (kbd "C-c M-z") 'nrepl-make-repl-connection-default)

;; paredit
;(add-hook 'clojure-mode-hook 'paredit-mode)
;(add-hook 'nrepl-mode-hook 'paredit-mode)
;(global-set-key [f7] 'paredit-mode)

;; nrepl (see https://github.com/clojure-emacs/nrepl.el)
(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
(setq nrepl-hide-special-buffers nil)
(setq nrepl-popup-stacktraces nil)
(setq nrepl-popup-stacktraces-in-repl t)
(setq nrepl-auto-select-error-buffer t)
(setq nrepl-buffer-name-separator "-")
(setq nrepl-buffer-name-show-port t)
(add-to-list 'same-window-buffer-names "*nrepl*")
;(add-hook 'nrepl-mode-hook 'paredit-mode)
;-- (add-hook 'nrepl-repl-mode-hook 'smartparens-strict-mode)
;-- (add-hook 'clojure-mode-hook 'smartparens-strict-mode)
(add-hook 'nrepl-repl-mode-hook 'smartparens-mode)
(add-hook 'clojure-mode-hook 'smartparens-mode)

(global-set-key [f8] 'nrepl-jack-in)
(global-set-key [C-f8] 'nrepl-restart)

;; SLIME looks nice.
;;  Look at http://common-lisp.net/project/slime/doc/slime.pdf to see what was lost by nrepl.
;;  Also, look at clojure-test-mode, which has a slime dependency now

;; Auto complete
(require 'auto-complete-config)
(ac-config-default)
(define-key ac-completing-map "\M-/" 'ac-stop) ; use M-/ to stop completion
;; ac-nrepl
(require 'ac-nrepl)
(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
(add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete" '(add-to-list 'ac-modes 'nrepl-mode))


;; Clojure mode in ClojureLisp buffers.
;; But, also see here for much more useful stuff later:
;; https://github.com/brentonashworth/one/wiki/Emacs
(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\.cljx$" . clojure-mode))


;; Indentation
(define-clojure-indent
  (ANY 2)
  (DELETE 2)
  (GET 2)
  (HEAD 2)
  (POST 2)
  (PUT 2)
  (append! 1)
  (button-group 2)
  (context 2)
  (defroutes 'defun)
  (fill-select-options 1)
  (listen! 2)
  (remote-callback 2)
  (set-html! 1)
  (set-inner-html! 1)
  (template 2))
