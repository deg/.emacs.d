;;; bindings.el --- Global key bindings  -*- lexical-binding: t; -*-

;; Reasonable scrolling behavior
(setq scroll-preserve-screen-position t)
(global-set-key (kbd "M-<up>") 'scroll-down)
(global-set-key (kbd "M-<down>") 'scroll-up)
(global-set-key (kbd "M-z") 'scroll-down-line)
(global-set-key (kbd "C-z") 'scroll-up-line)

;; Familiar bindings
(global-set-key (kbd "M-=") 'compare-windows)
(global-set-key (kbd "C-h a") 'apropos)
(global-set-key (kbd "C-h C-a") 'apropos-command)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-x g") 'goto-line)

;; New bindings
(global-set-key (kbd "C-c TAB") 'browse-url)
;; A real terminal emulator (see the ghostel block in packages.el), so ncurses
;; apps and color prompts work — unlike shell/ansi-term.  Starts in the current
;; buffer's directory; M-x ghostel-project starts at the project root instead.
(global-set-key (kbd "C-x !") 'ghostel)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Improve grep navigation
(global-set-key (kbd "M-n") 'next-error)
(global-set-key (kbd "M-p") 'previous-error)
(define-key compilation-mode-map (kbd "M-n") 'next-error)
(define-key compilation-mode-map (kbd "M-p") 'previous-error)


;;; Version control; see Magit documentation at http://magit.github.com/magit/magit.html
(global-set-key (kbd "C-c g") 'magit-status)

;; My functions
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)
(global-set-key (kbd "M-SPC") 'kill-whitespace)

;; Clever undo
(global-undo-tree-mode)
(global-set-key (kbd "C-x u") 'undo-tree-visualize)
(global-set-key [f9] 'undo-tree-undo)
(global-set-key [f10] 'undo-tree-redo)


;; Shell window
;; (much from https://snarfed.org/why_i_dont_run_shells_inside_emacs)
;; Using setq (not custom-set-variables) so these inline comments survive
;; a future Customize UI save — Customize rewrites its managed block from
;; scratch and drops all comments in the process.
(setq comint-scroll-to-bottom-on-input  t     ; always insert at the bottom
      comint-scroll-to-bottom-on-output t     ; always add output at the bottom
      comint-scroll-show-maximum-output t     ; scroll to show max possible output
      comint-completion-autolist        t     ; show completion list when ambiguous
      comint-input-ignoredups           t     ; no duplicates in command history
      comint-completion-addsuffix       t     ; insert space/slash after file completion
      comint-move-point-for-output      'all  ; always scroll to show new output
      comint-prompt-read-only           t)    ; prompt text is read only
; interpret and use ansi color codes in shell output windows
(ansi-color-for-comint-mode-on)
; make completion buffers disappear after 3 seconds.
(add-hook 'completion-setup-hook
  (lambda () (run-at-time 3 nil
    (lambda () (delete-windows-on "*Completions*")))))


;; Magit
(with-eval-after-load 'magit
  (define-key magit-mode-map (kbd "M-.") 'magit-diff-visit-file-other-window))


;; run a few shells.
;; (shell "*clojure-shell*")
;;(shell "*javascript-shell*")

