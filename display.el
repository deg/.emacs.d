;; Don't need circus-sized font. Reduce to 11pt
;  (set-face-attribute 'default nil :height 110)
;; Later:  Bring in Windows Consolas font as follows:
;;  Loosely per [http://superuser.com/questions/7904/installing-microsoft-ttf-fonts-on-ubuntu]
;;    $ cp *.ttff ~/.fonts
;;    $ fc-cache -fv
;;  Per [http://batsov.com/articles/2011/06/05/emacs-default-font/]:
;;    put "Emacs.font: Consolas-11" into ~/.Xdefaults
;;    $ xrdb -merge ~/.Xdefaults

;; Colors, etc.
;(add-to-list 'custom-theme-load-path "~/.emacs.d")  ;; already there by default
;(load-file "deg-tsdh-light-theme.el")
(load-theme 'deg-tsdh-light t)

;; Use cursor to show overwrite vs insert mode, etc.
(defun set-cursor-by-mode ()
  "change cursor type according to some minor modes."
  (setq cursor-type (if buffer-read-only 'hbar
		      (if overwrite-mode 'box 'bar))))
(add-hook 'post-command-hook 'set-cursor-by-mode)

;; Familiar behaviors
(show-paren-mode 1)

;; Show column pos, along with row (try this and decide if nice)
(setq column-number-mode t)

;; Remove screen clutter
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(menu-bar-mode -1)
(add-hook 'window-setup-hook (lambda () (tool-bar-mode -1)))
(defun x11-maximize-frame ()
  "Maximize the current frame (to full screen)"
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0)))
(x11-maximize-frame)

;; Remove cognitive clutter
(setq visible-bell t)
(defalias 'yes-or-no-p 'y-or-n-p)

;; Maybe more reasonable buffer behavior
(add-to-list 'same-window-buffer-names "*Apropos*")
(add-to-list 'same-window-buffer-names "*Backtrace*")
(add-to-list 'same-window-buffer-names "*Buffer List*")
(add-to-list 'same-window-buffer-names "*Deletions*")
(add-to-list 'same-window-buffer-names "*Help*")
(add-to-list 'same-window-buffer-names "*grep*")
(add-to-list 'same-window-buffer-names "*magit-edit-log*")
(add-to-list 'same-window-buffer-names "*nREPL Macroexpansion*")
(add-to-list 'same-window-buffer-names "*nREPL error*")
(add-to-list 'same-window-buffer-names "*nrepl*")
(setq pop-up-windows nil) ;; but see comment in [http://www.emacswiki.org/emacs/OneWindow]
