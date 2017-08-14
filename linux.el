;;; [TODO] How can I load this file only under Linux?


;;; Setting Super and Hyper keys:
;;; See http://ergoemacs.org/emacs/emacs_hyper_super_keys.html
;;; On Linuxes, you should define Super ＆ Hyper key in the OS. For example, in
;;; Ubuntu 11.04, it's under 〖System▸Preferences▸keyboard〗 then “Layout” tap,
;;; “Options…” button.

;;; To get the Windows (Super) key, see also:
;;; http://askubuntu.com/questions/29553/how-can-i-configure-unity

;;; Also see http://stevelosh.com/blog/2012/10/a-modern-space-cadet/ for some
;;; serious keyboard tweaking.



;; From https://superuser.com/questions/173851/linux-remap-ctrl-key
;; Prevent c-[ c-[ c-[ from closing all windows when my finger misses c-p
(define-key key-translation-map [?\C-\[] [(control left_bracket)])
(define-key key-translation-map [escape] [?\e])
(define-key function-key-map [escape] nil)
(define-key function-key-map [?\e] nil)
(when (boundp 'local-function-key-map)
  ;;(define-key local-function-key-map [escape] nil)
  (defun remove-escape-from-local-function-key-map ()
    (define-key local-function-key-map [?\e] nil)
    (define-key local-function-key-map [escape] nil))
  (add-hook 'term-setup-hook 'remove-escape-from-local-function-key-map))
