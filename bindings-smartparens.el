;;; bindings-smartparens.el --- Smartparens setup  -*- lexical-binding: t; -*-

;;; Originally derived from
;;; https://github.com/Fuco1/smartparens/wiki/Example-configuration
;;; (18 November 2014); has diverged since.

;;;;;;;;;
;; global
(require 'smartparens-config)
(smartparens-global-mode t)

;; highlights matching pairs
(show-smartparens-global-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;
;; keybinding management

(define-key smartparens-mode-map (kbd "C-M-f") 'sp-forward-sexp)
(define-key smartparens-mode-map (kbd "C-M-b") 'sp-backward-sexp)

(define-key smartparens-mode-map (kbd "C-M-d") 'sp-down-sexp)
(define-key smartparens-mode-map (kbd "C-M-a") 'sp-backward-down-sexp)
(define-key smartparens-mode-map (kbd "C-S-a") 'sp-beginning-of-sexp)
(define-key smartparens-mode-map (kbd "C-S-d") 'sp-end-of-sexp)

(define-key smartparens-mode-map (kbd "C-M-e") 'sp-up-sexp)
(define-key emacs-lisp-mode-map (kbd ")") 'sp-up-sexp)
(define-key smartparens-mode-map (kbd "C-M-u") 'sp-backward-up-sexp)
(define-key smartparens-mode-map (kbd "C-M-t") 'sp-transpose-sexp)

(define-key smartparens-mode-map (kbd "C-M-n") 'sp-next-sexp)
(define-key smartparens-mode-map (kbd "C-M-p") 'sp-previous-sexp)

(define-key smartparens-mode-map (kbd "C-M-k") 'sp-kill-sexp)
(define-key smartparens-mode-map (kbd "C-M-w") 'sp-copy-sexp)

(define-key smartparens-mode-map (kbd "M-<delete>") 'sp-unwrap-sexp)
(define-key smartparens-mode-map (kbd "M-<backspace>") 'sp-backward-unwrap-sexp)

(define-key smartparens-mode-map (kbd "C-<right>") 'sp-forward-slurp-sexp)
(define-key smartparens-mode-map (kbd "C-<left>") 'sp-forward-barf-sexp)
(define-key smartparens-mode-map (kbd "C-M-<left>") 'sp-backward-slurp-sexp)
(define-key smartparens-mode-map (kbd "C-M-<right>") 'sp-backward-barf-sexp)

(define-key smartparens-mode-map (kbd "M-D") 'sp-splice-sexp)
(define-key smartparens-mode-map (kbd "C-M-<delete>") 'sp-splice-sexp-killing-forward)
(define-key smartparens-mode-map (kbd "C-M-<backspace>") 'sp-splice-sexp-killing-backward)
(define-key smartparens-mode-map (kbd "C-S-<backspace>") 'sp-splice-sexp-killing-around)

;; Repeated C-] drills inward: the expression, then its insides, then its first
;; element.  C-M-] instead walks forward from sibling to sibling.  For the
;; backward direction give either one a negative argument -- M-- C-M-] selects
;; the previous thing.
(define-key smartparens-mode-map (kbd "C-]") 'sp-select-next-thing-exchange)
(define-key smartparens-mode-map (kbd "C-M-]") 'sp-select-next-thing)

(define-key smartparens-mode-map (kbd "M-F") 'sp-forward-symbol)
(define-key smartparens-mode-map (kbd "M-B") 'sp-backward-symbol)

(define-key smartparens-mode-map (kbd "H-t") 'sp-prefix-tag-object)
(define-key smartparens-mode-map (kbd "H-p") 'sp-prefix-pair-object)
(define-key smartparens-mode-map (kbd "H-s c") 'sp-convolute-sexp)
(define-key smartparens-mode-map (kbd "H-s a") 'sp-absorb-sexp)
(define-key smartparens-mode-map (kbd "H-s e") 'sp-emit-sexp)
(define-key smartparens-mode-map (kbd "H-s p") 'sp-add-to-previous-sexp)
(define-key smartparens-mode-map (kbd "H-s n") 'sp-add-to-next-sexp)
(define-key smartparens-mode-map (kbd "H-s j") 'sp-join-sexp)
(define-key smartparens-mode-map (kbd "H-s s") 'sp-split-sexp)

;;;;;;;;;;;;;;;;;;
;; pair management
;;
;; Pairs only -- no `sp-local-tag' calls.  Smartparens removed its tag system in
;; 2015; `sp-local-tag' still runs without error, but all it does is push onto
;; `sp-tags', which nothing in the package ever reads.  Anything defined that way
;; is silently inert, so don't reach for it.

(sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)

;;; markdown-mode
(sp-with-modes '(markdown-mode gfm-mode rst-mode)
  (sp-local-pair "*" "*" :bind "C-*"))

;;; html-mode
(sp-with-modes '(html-mode sgml-mode)
  (sp-local-pair "<" ">"))

;;; lisp modes
(sp-with-modes sp-lisp-modes
  (sp-local-pair "(" nil :bind "C-("))
