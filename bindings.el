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
(global-set-key (kbd "C-x !") 'shell)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x !") 'ansi-term)

;;; Version control; see Magit documentation at http://magit.github.com/magit/magit.html
(global-set-key (kbd "C-c g") 'magit-status)

;; My functions
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)
(global-set-key (kbd "s-SPC") 'kill-whitespace)

;; Clever undo
(undo-tree-mode)
(global-set-key (kbd "C-x u") 'undo-tree-visualize)
(global-set-key [f9] 'undo-tree-undo)
(global-set-key [f10] 'undo-tree-redo)


;; Deal with MacBook keyboard
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta
	mac-option-modifier 'super))
