(load "~/.emacs.d/packages")
(load "~/.emacs.d/bindings")
(load "~/.emacs.d/display")
(load "~/.emacs.d/clojure")

;;; Look at
;;; -  https://github.com/technomancy/clojure-mode/blob/master/README.md
;;; -  https://github.com/technomancy/emacs-starter-kit
;;; -  http://blog.worldcognition.com/2012/07/setting-up-emacs-for-clojure-programming.html
;;; -  http://www.mail-archive.com/clojure@googlegroups.com/msg36929.html
;;; -  https://github.com/kingtim/nrepl.el (and obvious extensions)
;;;...


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
