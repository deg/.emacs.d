;;; Look at
;;; -  https://github.com/technomancy/clojure-mode/blob/master/README.md
;;; -  https://github.com/technomancy/emacs-starter-kit
;;; -  http://blog.worldcognition.com/2012/07/setting-up-emacs-for-clojure-programming.html
;;; -  http://www.mail-archive.com/clojure@googlegroups.com/msg36929.html
;;; -  https://github.com/kingtim/nrepl.el (and obvious extensions)
;;;...



;;;; Stuff I understand ... start of real future init file

;;; Load packages
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))
(defvar my-packages '(;; Good
		      clojure-mode       ;; Clojure editing
		      nrepl              ;; New interface to leiningen
		      undo-tree	         ;; Tree-based undo
		      elein              ;; Interface to leiningen commands
		      rainbow-delimiters ;; Subtle parens colorization
		      auto-complete      ;; Auto completion
		      popup              ;; Popups for auto-complete (I think)
		      ac-nrepl           ;; Auto completion for nrepl

		      ;; Maybe drop
		      paredit
		      ))
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;;; Emacs behavior - I suppose my basic goal is to look like Epsilon and my memories of ZMacs.

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

;; Reasonable scrolling behavior
(setq scroll-preserve-screen-position t)
(global-set-key (kbd "M-<up>") 'scroll-down)
(global-set-key (kbd "M-<down>") 'scroll-up)
(global-set-key (kbd "M-z") 'scroll-down-line)
(global-set-key (kbd "C-z") 'scroll-up-line)

;; Use cursor to show overwrite vs insert mode, etc.
(defun set-cursor-by-mode ()
  "change cursor type according to some minor modes."
  (setq cursor-type (if buffer-read-only 'hbar
		      (if overwrite-mode 'box 'bar))))
(add-hook 'post-command-hook 'set-cursor-by-mode)

;; Maybe more reasonable buffer behavior
(add-to-list 'same-window-buffer-names "*Apropos*")
(add-to-list 'same-window-buffer-names "*Buffer List*")
(add-to-list 'same-window-buffer-names "*Deletions*")
(add-to-list 'same-window-buffer-names "*Help*")
(add-to-list 'same-window-buffer-names "*magit-edit-log*")
(add-to-list 'same-window-buffer-names "*nrepl*")
(setq pop-up-windows nil) ;; but see comment in [http://www.emacswiki.org/emacs/OneWindow]

;; Familiar bindings
(global-set-key (kbd "M-=") 'compare-windows)
(global-set-key (kbd "C-h a") 'apropos)
(global-set-key (kbd "C-h C-a") 'apropos-command)

;; Familiar behaviors
(show-paren-mode 1)

;; Clever undo
(undo-tree-mode)
(global-set-key (kbd "C-x u") 'undo-tree-visualize)
(global-set-key [f9] 'undo-tree-undo)
(global-set-key [f10] 'undo-tree-redo)

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


;;; Version control
;;; See Magit documentation at http://magit.github.com/magit/magit.html
(global-set-key (kbd "C-c g") 'magit-status)


;;; Clojure and friends

;; rainbow delimiters
(global-rainbow-delimiters-mode)

;; CamelCase support for Java names
(add-hook 'nrepl-mode-hook 'subword-mode) 
(add-hook 'clojure-mode-hook 'subword-mode)

;; Useful bindings
(global-set-key (kbd "C-c i") 'indent-region)
(global-set-key (kbd "C-c ;") 'comment-region)


;; paredit
;(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'nrepl-mode-hook 'paredit-mode)
(global-set-key [f7] 'paredit-mode)

;; nrepl
(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
;; MAYBE ;(setq nrepl-popup-stacktraces nil)
;(add-hook 'nrepl-mode-hook 'paredit-mode)
(global-set-key [f8] 'nrepl-jack-in)
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


;;; TODO
;; Disable c-Z behavior
;; Stop crazy window switching, or get used to Q command
;; Switch buffer as suffix to c-X 2 and c-X 3
;; For Windows use, look at:
;; - http://marmalade-repo.org/packages/w32-browser
;; - http://www.emacswiki.org/cgi-bin/wiki/w32-browser.el (linked from above)
;; c-X D should not prompt, unless given arg

;; Old crap




(require 'rcirc)
 
 
(setq rcirc-default-nick "deg")
(setq rcirc-default-full-name "David Goldfarb")
(setq rcirc-authinfo
      '(("freenode" nickserv freenode-nickserv-nick freenode-nickserv-password)
        ("freenode" chanserv "deg" "#hiddenchan" "eagle749")))
 
(setq rcirc-server-alist
      '(("irc.freenode.net"
         :port 7000
         :channels ("#emacs" "#lisp" "#clojure #emacs"))))
