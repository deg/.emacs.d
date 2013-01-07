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

;; New bindings
(global-set-key (kbd "C-c TAB") 'browse-url)
(global-set-key (kbd "C-x !") 'shell)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Clever undo
(undo-tree-mode)
(global-set-key (kbd "C-x u") 'undo-tree-visualize)
(global-set-key [f9] 'undo-tree-undo)
(global-set-key [f10] 'undo-tree-redo)


