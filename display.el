;;; display.el --- Fonts, theme and UI settings  -*- lexical-binding: t; -*-

;; Declared, not defined.  A `defvar' with no value simply tells the byte
;; compiler that these names are real variables rather than typos; recentf
;; still creates them and supplies their values when it loads.
(defvar recentf-max-menu-items)
(defvar recentf-list)

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

;(set-frame-font "Consolas-13")
;(set-frame-font "Menlo-12")
;(set-frame-font "Inconsolata-14")
;; CommitMono Nerd Font — patched variant with broader Unicode coverage.
;; Falls back to plain CommitMono if the Nerd Font is unavailable.
(let ((nerd-font-file "~/Library/Fonts/CommitMonoNerdFontMono-Regular.otf"))
  (when (and (not (file-exists-p nerd-font-file))
             (executable-find "brew"))
    (message "Installing CommitMono Nerd Font...")
    (call-process "brew" nil nil nil "install" "--cask" "font-commit-mono-nerd-font"))
  (set-frame-font (if (file-exists-p nerd-font-file)
                      "CommitMono Nerd Font Mono-13"
                    "CommitMono-13")))

;; Fix line-height bouncing in terminal buffers: Claude Code's spinners use
;; Unicode symbols (e.g. ✶ U+2736, ⏺ U+23FA) that CommitMono/Nerd don't cover,
;; so Emacs falls back to Arial Unicode MS or STIX Two Math, which have taller
;; line metrics.  Map all common symbol blocks to Menlo, whose metrics match.
(dolist (range '((#x2300 . #x23FF)   ; Miscellaneous Technical (⏺ etc.)
                 (#x25A0 . #x25FF)   ; Geometric Shapes
                 (#x2600 . #x26FF)   ; Miscellaneous Symbols
                 (#x2700 . #x27BF)   ; Dingbats (✶ etc.)
                 (#x2800 . #x28FF))) ; Braille Patterns (used by some spinners)
  (set-fontset-font "fontset-default" range (font-spec :family "Menlo")))

;; Colors, etc.
;(add-to-list 'custom-theme-load-path "~/.emacs.d")  ;; already there by default
;(load-file "deg-tsdh-light-theme.el")
(load-theme 'deg-tsdh-light t)
;;(load-theme 'material-light t)


;; Use cursor to show overwrite vs insert mode, etc.
(defun set-cursor-by-mode ()
  "change cursor type according to some minor modes."
  (setq cursor-type (if buffer-read-only 'hbar
		      (if overwrite-mode 'box 'bar))))
(add-hook 'post-command-hook 'set-cursor-by-mode)


;; Familiar behaviors
(show-paren-mode 1)


;; Show column pos, along with row
(setq column-number-mode t)


;; Remove screen clutter
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(menu-bar-mode -1)
(add-hook 'window-setup-hook (lambda () (tool-bar-mode -1)))
;; The two frame-geometry blocks below only work under a window system, so both
;; are gated on `display-graphic-p'.  That is nil under `emacs --batch' and in a
;; terminal Emacs, where `x-display-pixel-width' and `x-send-client-message'
;; signal rather than return.  The guard keeps `emacs --batch -l init.el' usable
;; as a smoke test that the whole config still loads.
(when (and (display-graphic-p) (string-equal system-type "gnu/linux"))
  (defun x11-maximize-frame ()
    "Maximize the current frame (to full screen)"
    (interactive)
    (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
    (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0)))
  (x11-maximize-frame))
(when (and (display-graphic-p) (string-equal system-type 'darwin))
  (cond ((> (x-display-pixel-width) 2500)
         ;; Fill most of middle screen (assuming Mac is on right, per my home setup)
         (setq default-frame-alist
               '((top + -750) (left + -2500)  (width . 340) (height . 220))))
        (t
         (toggle-frame-maximized)))
  ;; (add-hook 'window-setup-hook
  ;;        (lambda ()
  ;;	      (set-frame-parameter nil 'fullscreen 'fullboth)))
  )


;; Remove cognitive clutter
;; LATER: turn off visible bell.  Leaves turd in center of window on Mac.
;; (setq visible-bell t)
(defalias 'yes-or-no-p 'y-or-n-p)

;; Maybe more reasonable buffer behavior
(add-to-list 'same-window-buffer-names "*Apropos*")
(add-to-list 'same-window-buffer-names "*Backtrace*")
(add-to-list 'same-window-buffer-names "*Buffer List*")
(add-to-list 'same-window-buffer-names "*Deletions*")
(add-to-list 'same-window-buffer-names "*Help*")
; (add-to-list 'same-window-buffer-names "*grep*")
(add-to-list 'same-window-buffer-names "*magit-edit-log*")
(setq pop-up-windows nil) ;; but see comment in [http://www.emacswiki.org/emacs/OneWindow]

;; Let help-like buffers split the current frame instead of opening a new
;; frame, even though pop-up-windows is nil.  Without this override, C-h v
;; from a window that display-buffer can't reuse falls back to a new frame.
;; Full rationale in bead emacs-atz.
(add-to-list 'display-buffer-alist
             '("\\*\\(Help\\|Apropos\\|[Ii]nfo\\|Backtrace\\)\\*"
               (display-buffer-reuse-window
                display-buffer-pop-up-window
                display-buffer-use-some-window)))


;; Use c-c right and c-c left to go back to remembered window configs
(when (fboundp 'winner-mode)
  (winner-mode 1))

;; Letter-based window picker.  Overlays a home-row letter on each window;
;; press the letter to jump there.  2-window layouts are an instant toggle;
;; 3+ windows show the picker.  Dispatch keys (press after C-x o and before
;; picking a window) apply an operation instead of selecting — x delete,
;; m swap, v split-v, b split-h, o maximize, ? full list.
(use-package ace-window
  :bind ("C-x o" . ace-window)
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; Colour each nesting level of brackets differently, in every programming
;; mode.  The depth-1/2/3 colours and `rainbow-delimiters-max-face-count' are
;; set in init.el's Customize block; this hook is what actually turns the mode
;; on, so without it those settings never take effect.
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)


;; Improved completion/matching for buffers and files
(ido-mode 1)


;; Remember recent files
;; See http://www.masteringemacs.org/articles/2011/01/27/find-files-faster-recent-files-package/
(recentf-mode 1)
(setq recentf-max-menu-items 25)
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



;;; Display directory as part of buffer name, when multiple files have the same name.
;;; (Way better than hoary old <2>)!
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets) ; Or 'forward, 'reverse, 'post-forward

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
