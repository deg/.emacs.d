;; [TODO]
;; - Disable c-Z behavior
;; - Stop crazy window switching, or get used to Q command
;; - Switch buffer as suffix to c-X 2 and c-X 3
;; - For Windows use, look at:
;;   - http://marmalade-repo.org/packages/w32-browser
;;   - http://www.emacswiki.org/cgi-bin/wiki/w32-browser.el (linked from above)
;; - c-X D should not prompt, unless given arg
;; - See http://www.gnu.org/software/emacs/manual/html_mono/rcirc.html for doing rcirc right
;; - Look at everything in https://github.com/bbatsov/prelude
;; - Auto enable auto-fill in .txt and .md files
;; - Get mode where word commands respect camel-case
;; - Figure out why completion presents all-lowercase misspelling of names
;; - Play with smarter grep tools.  See:
;;   - https://www.reddit.com/r/emacs/comments/1aaguk/configuring_rgrep_to_ignore_special_folders_like/
;;   - http://stackoverflow.com/questions/2148575/default-string-for-grep-find-in-emacs
;;   - https://mindlev.wordpress.com/2009/09/26/excluding-directories-from-rgrep-in-emacs/



;; To load on Mac with debugging of this init:
;; $ open -a /Applications/Emacs.app --args --debug-init

(load "~/.emacs.d/packages")

(load "~/.emacs.d/clojure")
(load "~/.emacs.d/display")
(load "~/.emacs.d/irc")
(load "~/.emacs.d/linux")
(load "~/.emacs.d/windows")

(load "~/.emacs.d/bindings")
(load "~/.emacs.d/bindings-smartparens")

;;; Look at
;;; -  https://github.com/technomancy/clojure-mode/blob/master/README.md
;;; -  https://github.com/technomancy/emacs-starter-kit
;;; -  http://blog.worldcognition.com/2012/07/setting-up-emacs-for-clojure-programming.html
;;; -  http://www.mail-archive.com/clojure@googlegroups.com/msg36929.html
;;; -  https://github.com/kingtim/nrepl.el (and obvious extensions)
;;; -  https://github.com/mordocai/.emacs.d
;;;...


;; So lein, etc., find the right path.
;; See https://github.com/purcell/exec-path-from-shell
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; (3Nov16 - byte-compile-dest-file seems to be undefined suddenly.  So, instead of this
;; code, for now, do a manual M-x byte-recompile-directory after editing)
;;=;; (defun byte-compile-current-buffer ()
;;=;;   "`byte-compile' current buffer if it's emacs-lisp-mode and compiled file exists."
;;=;;   (interactive)
;;=;;   (when (and (eq major-mode 'emacs-lisp-mode)
;;=;;              (file-exists-p (byte-compile-dest-file buffer-file-name)))
;;=;;     (byte-compile-file buffer-file-name)))
;;=;;
;;=;; (add-hook 'after-save-hook 'byte-compile-current-buffer)

;;; Enable completion globally
(add-hook 'after-init-hook 'global-company-mode)

;;; Emacs behavior - I suppose my basic goal is to look like Epsilon and my memories of ZMacs.

;; Dired
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)


;; Random utilities

(defun insert-date-string ()
  "Insert the current date"
  (interactive)
  (insert (format-time-string "%a %b %d %H:%M:%S %Y")))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(comint-completion-addsuffix t)
 '(comint-completion-autolist t)
 '(comint-input-ignoredups t)
 '(comint-move-point-for-output t)
 '(comint-prompt-read-only nil)
 '(comint-scroll-show-maximum-output t)
 '(comint-scroll-to-bottom-on-input t)
 '(exec-path
   (quote
    ("/usr/local/sbin" "/usr/local/bin" "/usr/sbin" "/usr/bin" "/sbin" "/bin" "/usr/games" "/usr/local/games" "/snap/bin" "/usr/lib/emacs/24.5/x86_64-linux-gnu" "~/bin")))
 '(fill-column 88)
 '(git-commit-summary-max-length 72)
 '(grep-find-ignored-directories
   (quote
    ("SCCS" "RCS" "CVS" "MCVS" ".svn" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "node_modules" "out")))
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(magit-diff-paint-whitespace t)
 '(magit-diff-toggle-refine-hunk t)
 '(magit-log-arguments (quote ("--graph" "--color" "--decorate")))
 '(magit-tag-arguments (quote ("--annotate")))
 '(quote
   (safe-local-variable-values
    (quote
     ((css-indent-offset . 2)))))
 '(sp-successive-kill-preserve-whitespace 0))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:foreground "dark magenta" :slant italic))))
 '(font-lock-function-name-face ((t (:distant-foreground "black" :foreground "Blue1" :weight semi-bold))))
 '(font-lock-string-face ((t (:foreground "dark slate gray" :weight normal)))))
