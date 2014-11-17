;; IRC setup

;; Useful IRC commands:
;;
;; Focus/blur certain people
;; /ignore real-pain
;; /dim annoying
;; /bright neat-dude
;;
;; Silence status messages. (Do M-X Rcirc-Omit-Mode or (c-C c-O)
;; (setq rcirc-omit-responses '("JOIN" "PART" "QUIT" "NICK" "AWAY"))

(require 'rcirc)

(setq rcirc-default-nick "deg")
(setq rcirc-default-user-name "deg")
(setq rcirc-default-full-name "David Goldfarb")
(setq rcirc-authinfo
                '(("freenode" nickserv "deg" "eagle749")))

(rcirc-track-minor-mode 1)

(setq rcirc-server-alist
      '(("irc.freenode.net"
	 :channels ("#clojure"
		    "#clojure-emacs"
		    "#clojurescript"
		    "#leiningen"
		    ;; "#emacs"
		    ;; "#git"
		    ;; "#lisp"
		    ))))

;;(setq rcirc-time-format "%Y-%m-%d %H:%M:%S ")
(setq rcirc-time-format "%a %H:%M: ")

(add-hook 'rcirc-mode-hook
	  (lambda ()
	    (set (make-local-variable 'scroll-conservatively)
		 8192)))

 (add-hook 'rcirc-mode-hook (lambda ()
			      (flyspell-mode 1)))


;; Dim entire line
(defadvice rcirc-format-response-string (after dim-entire-line)
  "Dim whole line for senders whose nick matches `rcirc-dim-nicks'."
  (when (and rcirc-dim-nicks sender
             (string-match (regexp-opt rcirc-dim-nicks 'words) sender))
    (setq ad-return-value (rcirc-facify ad-return-value 'rcirc-dim-nick))))
(ad-activate 'rcirc-format-response-string)

;; /reconnect command
(eval-after-load 'rcirc
  '(defun-rcirc-command reconnect (arg)
     "Reconnect the server process."
     (interactive "i")
     (unless process
       (error "There's no process for this target"))
     (let* ((server (car (process-contact process)))
	    (port (process-contact process :service))
	    (nick (rcirc-nick process))
	    channels query-buffers)
       (dolist (buf (buffer-list))
	 (with-current-buffer buf
	   (when (eq process (rcirc-buffer-process))
	     (remove-hook 'change-major-mode-hook
			  'rcirc-change-major-mode-hook)
	     (if (rcirc-channel-p rcirc-target)
		 (setq channels (cons rcirc-target channels))
	       (setq query-buffers (cons buf query-buffers))))))
       (delete-process process)
       (rcirc-connect server port nick
		      rcirc-default-user-name
		      rcirc-default-full-name
		      channels))))

;; ;; HT to http://www.emacswiki.org/emacs/ErcFilling
;; Not directly relevant, but hints on how to do dynamice column width
;; (make-variable-buffer-local 'erc-fill-column)
;; (add-hook 'window-configuration-change-hook
;; 	  '(lambda ()
;; 	     (save-excursion
;; 	       (walk-windows
;; 		(lambda (w)
;; 		  (let ((buffer (window-buffer w)))
;; 		    (set-buffer buffer)
;; 		    (when (eq major-mode 'erc-mode)
;; 		      (setq erc-fill-column (- (window-width w) 2)))))))))
