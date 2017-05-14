;;; Clojure and friends

(setq cider-cljs-lein-repl "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")

(require 'clojure-mode)
(define-clojure-indent
  (trace-forms 'defun)
  (assoc-if 'defun))

;; rainbow delimiters (See color settings in init.el)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; CamelCase support for Java names
(add-hook 'prog-mode-hook 'subword-mode)


(global-set-key (kbd "<s-backspace>") 'kill-backward-up-list)
(global-set-key (kbd "C-c ;") 'comment-region)

;;;;;--old 01Aug16 old--;;;;   
;;;;;--old 01Aug16 old--;;;;   ;; Useful bindings
;;;;;--old 01Aug16 old--;;;;   (global-set-key (kbd "C-c i") 'indent-region)
;;;;;--old 01Aug16 old--;;;;   
;;;;;--old 01Aug16 old--;;;;   ;; Move nrepl binding to global context
;;;;;--old 01Aug16 old--;;;;   ;;26Nov14;; (global-set-key (kbd "C-c C-z") 'cider-switch-to-repl-buffer)
;;;;;--old 01Aug16 old--;;;;   ;;26Nov14;; (global-set-key (kbd "C-c M-z") 'nrepl-make-connection-default)
;;;;;--old 01Aug16 old--;;;;   
;;;;;--old 01Aug16 old--;;;;   ;; **** [TODO] Checked up to here
;;;;;--old 01Aug16 old--;;;;   
;;;;;--old 01Aug16 old--;;;;   ;; nrepl (see https://github.com/clojure-emacs/nrepl.el)
;;;;;--old 01Aug16 old--;;;;   (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
;;;;;--old 01Aug16 old--;;;;   ;- (setq nrepl-hide-special-buffers t)
;;;;;--old 01Aug16 old--;;;;   ;- (setq nrepl-popup-stacktraces nil)
;;;;;--old 01Aug16 old--;;;;   ;- (setq nrepl-popup-stacktraces-in-repl t)
;;;;;--old 01Aug16 old--;;;;   (setq cider-auto-select-error-buffer t)
;;;;;--old 01Aug16 old--;;;;   (setq nrepl-buffer-name-separator "-")
;;;;;--old 01Aug16 old--;;;;   (setq nrepl-buffer-name-show-port t)
;;;;;--old 01Aug16 old--;;;;   (setq cider-repl-display-in-current-window t)
;;;;;--old 01Aug16 old--;;;;   ;(set cider-repl-result-prefix ";; => ")
;;;;;--old 01Aug16 old--;;;;   ;(set cider-interactive-eval-result-prefix ";; ==> ")
;;;;;--old 01Aug16 old--;;;;   (setq cider-repl-history-file "~/repl-history.clj-repl")
;;;;;--old 01Aug16 old--;;;;   (add-to-list 'same-window-buffer-names "*nrepl*")
;;;;;--old 01Aug16 old--;;;;   ;-- (add-hook 'nrepl-repl-mode-hook 'smartparens-strict-mode)
;;;;;--old 01Aug16 old--;;;;   ;-- (add-hook 'clojure-mode-hook 'smartparens-strict-mode)
;;;;;--old 01Aug16 old--;;;;   (add-hook 'nrepl-repl-mode-hook 'smartparens-mode)
;;;;;--old 01Aug16 old--;;;;   (add-hook 'clojure-mode-hook 'smartparens-mode)
;;;;;--old 01Aug16 old--;;;;   
;;;;;--old 01Aug16 old--;;;;   ;; nrepl-ritz debugger
;;;;;--old 01Aug16 old--;;;;   ;+ (add-hook 'nrepl-interaction-mode-hook 'my-nrepl-mode-setup)
;;;;;--old 01Aug16 old--;;;;   ;+ (defun my-nrepl-mode-setup ()
;;;;;--old 01Aug16 old--;;;;   ;+   (require 'nrepl-ritz))
;;;;;--old 01Aug16 old--;;;;   ;;26Nov14;; (global-set-key [f8] 'cider-jack-in)
;;;;;--old 01Aug16 old--;;;;   ;+ ;; Turn on when problem with Austin is fixed (see
;;;;;--old 01Aug16 old--;;;;      ;; https://degel.fogbugz.com/default.asp?160 and
;;;;;--old 01Aug16 old--;;;;      ;; https://github.com/cemerick/austin/issues/11)
;;;;;--old 01Aug16 old--;;;;   ;+ (global-set-key [f8] 'nrepl-ritz-jack-in)
;;;;;--old 01Aug16 old--;;;;   ;;26Nov14;; (global-set-key [M-f8] 'cider-restart)
;;;;;--old 01Aug16 old--;;;;   
;;;;;--old 01Aug16 old--;;;;   ;; SLIME looks nice.
;;;;;--old 01Aug16 old--;;;;   ;;  Look at http://common-lisp.net/project/slime/doc/slime.pdf to see what was lost by nrepl.
;;;;;--old 01Aug16 old--;;;;   ;;  Also, look at clojure-test-mode, which has a slime dependency now
;;;;;--old 01Aug16 old--;;;;   
;;;;;--old 01Aug16 old--;;;;   ;;; [TODO] IS ANY OF THIS STILL NEEDED, OR DOES CIDER COMPANY MODE REPLACE IT
;;;;;--old 01Aug16 old--;;;;   ;; ;; Auto complete
;;;;;--old 01Aug16 old--;;;;   ;; (require 'auto-complete-config)
;;;;;--old 01Aug16 old--;;;;   ;; (ac-config-default)
;;;;;--old 01Aug16 old--;;;;   ;; (define-key ac-completing-map "\M-/" 'ac-stop) ; use M-/ to stop completion
;;;;;--old 01Aug16 old--;;;;   ;; ;; ac-nrepl
;;;;;--old 01Aug16 old--;;;;   ;; (require 'ac-nrepl)
;;;;;--old 01Aug16 old--;;;;   ;; (add-hook 'cider-repl-mode-hook 'ac-nrepl-setup)
;;;;;--old 01Aug16 old--;;;;   ;; (add-hook 'cider-mode-hook 'ac-nrepl-setup)
;;;;;--old 01Aug16 old--;;;;   ;; (eval-after-load "auto-complete"
;;;;;--old 01Aug16 old--;;;;   ;;   '(add-to-list 'ac-modes 'cider-repl-mode))
;;;;;--old 01Aug16 old--;;;;   
;;;;;--old 01Aug16 old--;;;;   ;; (eval-after-load "cider"
;;;;;--old 01Aug16 old--;;;;   ;;   '(define-key cider-mode-map (kbd "C-c C-d") 'ac-nrepl-popup-doc))
;;;;;--old 01Aug16 old--;;;;   
;;;;;--old 01Aug16 old--;;;;   
;;;;;--old 01Aug16 old--;;;;   ;; Clojure mode in ClojureLisp buffers.
;;;;;--old 01Aug16 old--;;;;   ;; But, also see here for much more useful stuff later:
;;;;;--old 01Aug16 old--;;;;   ;; https://github.com/brentonashworth/one/wiki/Emacs
;;;;;--old 01Aug16 old--;;;;   (add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))
;;;;;--old 01Aug16 old--;;;;   (add-to-list 'auto-mode-alist '("\.cljx$" . clojure-mode))
;;;;;--old 01Aug16 old--;;;;   
;;;;;--old 01Aug16 old--;;;;   
;;;;;--old 01Aug16 old--;;;;   ;; Indentation
;;;;;--old 01Aug16 old--;;;;   (require 'clojure-mode)
;;;;;--old 01Aug16 old--;;;;   (define-clojure-indent
;;;;;--old 01Aug16 old--;;;;     (ANY 2)
;;;;;--old 01Aug16 old--;;;;     (DELETE 2)
;;;;;--old 01Aug16 old--;;;;     (GET 2)
;;;;;--old 01Aug16 old--;;;;     (HEAD 2)
;;;;;--old 01Aug16 old--;;;;     (POST 2)
;;;;;--old 01Aug16 old--;;;;     (PUT 2)
;;;;;--old 01Aug16 old--;;;;     (append! 1)
;;;;;--old 01Aug16 old--;;;;     (button-group 2)
;;;;;--old 01Aug16 old--;;;;     (context 2)
;;;;;--old 01Aug16 old--;;;;     (defroutes 'defun)
;;;;;--old 01Aug16 old--;;;;     (fill-select-options 1)
;;;;;--old 01Aug16 old--;;;;     (listen! 2)
;;;;;--old 01Aug16 old--;;;;     (remote-callback 2)
;;;;;--old 01Aug16 old--;;;;     (set-html! 1)
;;;;;--old 01Aug16 old--;;;;     (set-inner-html! 1)
;;;;;--old 01Aug16 old--;;;;     (template 2))
