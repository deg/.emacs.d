;;; windows.el --- Windows-specific settings  -*- lexical-binding: t; -*-

;;; [TODO] How can I load this file only under Windows?
;;; Possibly like this code fragment I found:
;; (cond
;;  ((string-equal system-type "windows-nt")
;;   (global-set-key (kbd "<apps>") 'execute-extended-command)
;;   )
;;  ((string-equal system-type "darwin")
;;   t )
;;  ((string-equal system-type "gnu/linux")
;;   t ) )

;; setting the PC keyboard's various keys to
;; Super or Hyper, for emacs running on Windows.
(setq w32-pass-lwindow-to-system nil
      w32-pass-rwindow-to-system nil
      w32-pass-apps-to-system nil
      w32-lwindow-modifier 'super ; Left Windows key
      w32-rwindow-modifier 'super ; Right Windows key
      w32-apps-modifier 'hyper) ; Menu key
