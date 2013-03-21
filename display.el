;; Don't need circus-sized font. Reduce to 11pt
;  (set-face-attribute 'default nil :height 110)
;; Later:  Bring in Windows Consolas font as follows:
;;  Loosely per [http://superuser.com/questions/7904/installing-microsoft-ttf-fonts-on-ubuntu]
;;    $ cp *.ttff ~/.fonts
;;    $ fc-cache -fv
;;  Per [http://batsov.com/articles/2011/06/05/emacs-default-font/]:
;;    put "Emacs.font: Consolas-11" into ~/.Xdefaults
;;    $ xrdb -merge ~/.Xdefaults

;; See also http://ergoemacs.org/emacs/emacs_list_and_set_font.html

;; From http://ergoemacs.org/emacs/emacs_switching_fonts.html
(defun cycle-font (num)
  "Change font in current frame.
Each time this is called, font cycles thru a predefined set of fonts.
If NUM is 1, cycle forward.
If NUM is -1, cycle backward.
Warning: tested on Windows Vista only."
  (interactive "p")
  ;; this function sets a property “state”. It is a integer. Possible values are any index to the fontList.
  (let (fontList fontToUse currentState nextState)
    (setq fontList (list "Courier New-10" "DejaVu Sans Mono-9" "DejaVu Sans-10" "Consolas-11" "Consolas-10" "Consolas-9"))
    ;; fixed-width "Courier New" "Unifont"  "FixedsysTTF" "Miriam Fixed" "Lucida Console" "Lucida Sans Typewriter"
    ;; variable-width "Code2000"
    (setq currentState (if (get 'cycle-font 'state) (get 'cycle-font 'state) 0))
    (setq nextState (% (+ currentState (length fontList) num) (length fontList)))

    (setq fontToUse (nth nextState fontList))
    (set-frame-parameter nil 'font fontToUse)
    (redraw-frame (selected-frame))
    (message "Current font is: %s" fontToUse )

    (put 'cycle-font 'state nextState)))


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
(unless (string-equal system-type "windows-nt")
  (defun x11-maximize-frame ()
    "Maximize the current frame (to full screen)"
    (interactive)
    (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
    (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0)))  (x11-maximize-frame))


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


;; Improved completion/matching for buffers and files
(ido-mode 1)


;; Remember recent files
;; See http://www.masteringemacs.org/articles/2011/01/27/find-files-faster-recent-files-package/
(recentf-mode 1)
(setq recentf-max-menu-items 20)
;;(global-set-key "\C-x\ \C-r" 'recentf-open-files)
;; Use this instead (bound in bindings.el)
(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))


;;; [TODO] Play with this someday
(defun toggle-line-spacing ()
  "Toggle line spacing between no extra space to extra half line height."
  (interactive)
  (if (eq line-spacing nil)
      (setq-default line-spacing 0.2) ; add 0.2 height between lines
    (setq-default line-spacing nil)   ; no extra heigh between lines
    )
  (redraw-display))


;;; Remove whitespace. Binding in bindings.el
;;; From http://www.emacswiki.org/emacs/DeletingWhitespace
(defun kill-whitespace ()
  "Kill the whitespace between two non-whitespace characters"
  (interactive "*")
  (save-excursion
    (save-restriction
      (save-match-data
	(progn
	  (re-search-backward "[^ \t\r\n]" nil t)
	  (re-search-forward "[ \t\r\n]+" nil t)
	  (replace-match "" nil nil))))))

