(load "~/.emacs.d/packages")

(load "~/.emacs.d/bindings")
;;(load "~/.emacs.d/clojure")
(load "~/.emacs.d/display")
(load "~/.emacs.d/irc")
(load "~/.emacs.d/linux")
(load "~/.emacs.d/windows")

;;; Look at
;;; -  https://github.com/technomancy/clojure-mode/blob/master/README.md
;;; -  https://github.com/technomancy/emacs-starter-kit
;;; -  http://blog.worldcognition.com/2012/07/setting-up-emacs-for-clojure-programming.html
;;; -  http://www.mail-archive.com/clojure@googlegroups.com/msg36929.html
;;; -  https://github.com/kingtim/nrepl.el (and obvious extensions)
;;;...


;; So lein, etc., find the right path.
;; See https://github.com/purcell/exec-path-from-shell
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(defun byte-compile-current-buffer ()
  "`byte-compile' current buffer if it's emacs-lisp-mode and compiled file exists."
  (interactive)
  (when (and (eq major-mode 'emacs-lisp-mode)
             (file-exists-p (byte-compile-dest-file buffer-file-name)))
    (byte-compile-file buffer-file-name)))

(add-hook 'after-save-hook 'byte-compile-current-buffer)


;;; Emacs behavior - I suppose my basic goal is to look like Epsilon and my memories of ZMacs.

;;; Version control
;;; See Magit documentation at http://magit.github.com/magit/magit.html
(global-set-key (kbd "C-c g") 'magit-status)


;; Dired
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)


;; Random utilities

(defun insert-date-string ()
  "Insert the current date"
  (interactive)
  (insert (format-time-string "%a %b %d %H:%M:%S %Y")))


;;; TODO
;; Disable c-Z behavior
;; Stop crazy window switching, or get used to Q command
;; Switch buffer as suffix to c-X 2 and c-X 3
;; For Windows use, look at:
;; - http://marmalade-repo.org/packages/w32-browser
;; - http://www.emacswiki.org/cgi-bin/wiki/w32-browser.el (linked from above)
;; c-X D should not prompt, unless given arg
;; See http://www.gnu.org/software/emacs/manual/html_mono/rcirc.html for doing rcirc right
;; Look at everything in https://github.com/bbatsov/prelude
;; Set fill column to 80, or maybe 90.
;; Auto enable auto-fill in .txt and .md files

