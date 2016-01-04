;;; Clojure and friends

;;; [TODO] Re-examine bindings. (Last half-did so 26Nov14)

;; rainbow delimiters
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; CamelCase support for Java names
(add-hook 'clojure-mode-hook 'subword-mode)

;; Useful bindings
(global-set-key (kbd "C-c i") 'indent-region)
(global-set-key (kbd "C-c ;") 'comment-region)
;;(global-set-key (kbd "C-M-S-U") 'kill-backward-up-list)

;; Move nrepl binding to global context
;;26Nov14;; (global-set-key (kbd "C-c C-z") 'cider-switch-to-repl-buffer)
;;26Nov14;; (global-set-key (kbd "C-c M-z") 'nrepl-make-connection-default)

;; **** [TODO] Checked up to here

;; nrepl (see https://github.com/clojure-emacs/nrepl.el)
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
;- (setq nrepl-hide-special-buffers t)
;- (setq nrepl-popup-stacktraces nil)
;- (setq nrepl-popup-stacktraces-in-repl t)
(setq cider-auto-select-error-buffer t)
(setq nrepl-buffer-name-separator "-")
(setq nrepl-buffer-name-show-port t)
(setq cider-repl-display-in-current-window t)
;(set cider-repl-result-prefix ";; => ")
;(set cider-interactive-eval-result-prefix ";; ==> ")
(setq cider-repl-history-file "~/repl-history.clj-repl")
(add-to-list 'same-window-buffer-names "*nrepl*")
;-- (add-hook 'nrepl-repl-mode-hook 'smartparens-strict-mode)
;-- (add-hook 'clojure-mode-hook 'smartparens-strict-mode)
(add-hook 'nrepl-repl-mode-hook 'smartparens-mode)
(add-hook 'clojure-mode-hook 'smartparens-mode)

;; nrepl-ritz debugger
;+ (add-hook 'nrepl-interaction-mode-hook 'my-nrepl-mode-setup)
;+ (defun my-nrepl-mode-setup ()
;+   (require 'nrepl-ritz))
;;26Nov14;; (global-set-key [f8] 'cider-jack-in)
;+ ;; Turn on when problem with Austin is fixed (see
   ;; https://degel.fogbugz.com/default.asp?160 and
   ;; https://github.com/cemerick/austin/issues/11)
;+ (global-set-key [f8] 'nrepl-ritz-jack-in)
;;26Nov14;; (global-set-key [M-f8] 'cider-restart)

;; SLIME looks nice.
;;  Look at http://common-lisp.net/project/slime/doc/slime.pdf to see what was lost by nrepl.
;;  Also, look at clojure-test-mode, which has a slime dependency now

;;; [TODO] IS ANY OF THIS STILL NEEDED, OR DOES CIDER COMPANY MODE REPLACE IT
;; ;; Auto complete
;; (require 'auto-complete-config)
;; (ac-config-default)
;; (define-key ac-completing-map "\M-/" 'ac-stop) ; use M-/ to stop completion
;; ;; ac-nrepl
;; (require 'ac-nrepl)
;; (add-hook 'cider-repl-mode-hook 'ac-nrepl-setup)
;; (add-hook 'cider-mode-hook 'ac-nrepl-setup)
;; (eval-after-load "auto-complete"
;;   '(add-to-list 'ac-modes 'cider-repl-mode))

;; (eval-after-load "cider"
;;   '(define-key cider-mode-map (kbd "C-c C-d") 'ac-nrepl-popup-doc))


;; Clojure mode in ClojureLisp buffers.
;; But, also see here for much more useful stuff later:
;; https://github.com/brentonashworth/one/wiki/Emacs
(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\.cljx$" . clojure-mode))


;; Indentation
(require 'clojure-mode)
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
