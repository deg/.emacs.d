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


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(load "~/.emacs.d/packages")
(load "~/.emacs.d/python")
(load "~/.emacs.d/javascript")
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
;;(exec-path-from-shell-copy-env "_JAVA_OPTIONS")
;;(when (memq window-system '(mac ns x))
;;  (exec-path-from-shell-initialize))

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

;; See https://github.com/facebook/create-react-app/issues/9056
;; Until this is fixed:
(setq create-lockfiles nil)


;; Emacs got very noisy, seemingly after Mac OS upgrade, Dec20.  Silenced, per
;; https://emacsredux.com/blog/2016/02/14/disable-annoying-audio-notifications/
(setq visible-bell t)
(setq ring-bell-function 'ignore)


;; Backup outside of work directories (for cleanliness and to avoid Python Flask restarts on each key typed!)
;; See https://stackoverflow.com/questions/151945/how-do-i-control-how-emacs-makes-backup-files
(setq backup-directory-alist `(("." . "~/.emacs-saves")))
(setq delete-old-versions t
  kept-new-versions 10
  kept-old-versions 2
  version-control t)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cider-font-lock-dynamically t)
 '(comint-completion-addsuffix t)
 '(comint-completion-autolist t)
 '(comint-input-ignoredups t)
 '(comint-move-point-for-output t)
 '(comint-prompt-read-only nil)
 '(comint-scroll-show-maximum-output t)
 '(comint-scroll-to-bottom-on-input t)
 '(custom-safe-themes
   '("fe230d2861a13bb969b5cdf45df1396385250cc0b7933b8ab9a2f9339b455f5c" default))
 '(elpy-project-ignored-directories
   '(".tox" "build" "dist" ".cask" ".ipynb_checkpoints" "venv"))
 '(exec-path
   '("/usr/local/sbin" "/usr/local/bin" "/usr/sbin" "/usr/bin" "/sbin" "/bin" "/usr/games" "/usr/local/games" "/snap/bin" "/usr/lib/emacs/24.5/x86_64-linux-gnu" "~/bin"))
 '(fill-column 100)
 '(flycheck-python-ruff-maximum-line-length 100)
 '(git-commit-summary-max-length 72)
 '(grep-find-ignored-directories
   '("SCCS" "RCS" "CVS" "MCVS" ".svn" ".git" ".hg" ".bzr" ".venv" "_MTN" "_darcs" "{arch}" "node_modules" "out" "compiled" "target" "build" "embeddings" ".mypy_cache" "model_repository" "production_model_repository" "mongo_data_db" "tests_tasks" "META-INF" ".yalc" "releases" "dist" "venv"))
 '(grep-find-ignored-files
   '(".#*" "*.o" "*~" "*.bin" "*.lbin" "*.so" "*.a" "*.ln" "*.blg" "*.bbl" "*.elc" "*.lof" "*.glo" "*.idx" "*.lot" "*.fmt" "*.tfm" "*.class" "*.fas" "*.lib" "*.mem" "*.x86f" "*.sparcf" "*.dfsl" "*.pfsl" "*.d64fsl" "*.p64fsl" "*.lx64fsl" "*.lx32fsl" "*.dx64fsl" "*.dx32fsl" "*.fx64fsl" "*.fx32fsl" "*.sx64fsl" "*.sx32fsl" "*.wx64fsl" "*.wx32fsl" "*.fasl" "*.ufsl" "*.fsl" "*.dxl" "*.lo" "*.la" "*.gmo" "*.mo" "*.toc" "*.aux" "*.cp" "*.fn" "*.ky" "*.pg" "*.tp" "*.vr" "*.cps" "*.fns" "*.kys" "*.pgs" "*.tps" "*.vrs" "*.pyc" "*.pyo" "*.map"))
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(line-move-visual nil)
 '(magit-diff-paint-whitespace t)
 '(magit-diff-refine-hunk 'all)
 '(magit-diff-toggle-refine-hunk t)
 '(magit-log-arguments '("--graph" "--color" "--decorate"))
 '(magit-tag-arguments '("--annotate"))
 '(ns-command-modifier 'meta)
 '(package-selected-packages
   '(vterm flycheck prettier json-mode web-mode which-key undo-tree smartparens rjsx-mode rainbow-delimiters markdown-mode magit exec-path-from-shell company clojure-cheatsheet auto-complete))
 '(quote (safe-local-variable-values '((css-indent-offset . 2))))
 '(rainbow-delimiters-max-face-count 4)
 '(safe-local-variable-values
   '((cider-shadow-cljs-default-options . "app")
     (cider-default-cljs-repl . shadow)))
 '(sort-fold-case t)
 '(sp-successive-kill-preserve-whitespace 0))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-delimiter-face ((t (:foreground "#505050" :background "#F8F8FF" :slant italic))))
 '(font-lock-comment-face ((t (:foreground "#505050" :background "#F8F8FF" :slant italic))))
 '(font-lock-doc-face ((t (:foreground "#505050" :background "#F8F8FF" :slant italic))))
 '(font-lock-function-name-face ((t (:distant-foreground "black" :foreground "Blue1" :weight semi-bold))))
 '(font-lock-string-face ((t (:foreground "dark slate gray" :weight normal))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "dark green"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "dark red"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "medium blue")))))

;; Avoid spewing tmp files everywhere whenever I touch a file
;; See https://www.reddit.com/r/emacs/comments/tejte0/undotree_bug_undotree_files_scattering_everywhere/
(setq undo-tree-auto-save-history nil)
;; untested altermative to save centrally:
;;- (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

;; (add-hook 'after-init-hook #'global-prettier-mode)

;;; 14May16 - I don't remember why this next stuff is here, nor if I ever want to use it.
;;; For now: comment out, but retain for a while.

;;;- ;;; TEMP from way back
;;;- 
;;;- (unless (package-installed-p 'use-package)
;;;-   (package-refresh-contents)
;;;-   (package-install 'use-package))
;;;- 
;;;- (setq use-package-verbose t)
;;;- 
;;;- (use-package multi-term
;;;-   :ensure t
;;;-   :bind (("C-x M" . multi-term)
;;;-          ("C-x m" . switch-to-term-mode-buffer))
;;;-   :config
;;;-   ;; (setq multi-term-dedicated-select-after-open-p t
;;;-   ;;       multi-term-dedicated-window-height 25
;;;-   ;;       multi-term-program "/bin/bash")
;;;- 
;;;-   ;; ;; Enable compilation-shell-minor-mode in multi term.
;;;-   ;; ;; http://www.masteringemacs.org/articles/2012/05/29/compiling-running-scripts-emacs/
;;;- 
;;;-   ;; ;; TODO: WTF? Turns off colors in terminal.
;;;-   ;; ;; (add-hook 'term-mode-hook 'compilation-shell-minor-mode)
;;;-   (add-hook 'term-mode-hook
;;;-             (lambda ()
;;;-               (dolist
;;;-                   (bind '(("<S-down>" . multi-term)
;;;-                           ("<S-left>" . multi-term-prev)
;;;-                           ("<S-right>" . multi-term-next)
;;;-                           ("C-<backspace>" . term-send-backward-kill-word)
;;;-                           ("C-<delete>" . term-send-forward-kill-word)
;;;-                           ("C-<left>" . term-send-backward-word)
;;;-                           ("C-<right>" . term-send-forward-word)
;;;-                           ("C-c C-j" . term-line-mode)
;;;-                           ("C-c C-k" . term-char-mode)
;;;-                           ("C-v" . scroll-up)
;;;-                           ("C-y" . term-paste)
;;;-                           ("C-z" . term-stop-subjob)
;;;-                           ("M-DEL" . term-send-backward-kill-word)
;;;-                           ("M-d" . term-send-forward-kill-word)))
;;;-                 (add-to-list 'term-bind-key-alist bind)))))
;;;- 
;;;- (defun last-term-mode-buffer (list-of-buffers)
;;;-   "Returns the most recently used term-mode buffer."
;;;-   (when list-of-buffers
;;;-     (if (eq 'term-mode (with-current-buffer (car list-of-buffers) major-mode))
;;;-         (car list-of-buffers) (last-term-mode-buffer (cdr list-of-buffers)))))
;;;- 
;;;- (defun switch-to-term-mode-buffer ()
;;;-   "Switch to the most recently used term-mode buffer, or create a
;;;- new one."
;;;-   (interactive)
;;;-   (let ((buffer (last-term-mode-buffer (buffer-list))))
;;;-     (if (not buffer)
;;;-         (multi-term)
;;;-       (switch-to-buffer buffer))))
