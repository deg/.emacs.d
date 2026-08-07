;;; windows.el --- Windows-specific settings  -*- lexical-binding: t; -*-

;; Declared, not defined.  A `defvar' with no value simply tells the byte
;; compiler that these names are real variables rather than typos.  Emacs
;; creates them only on Windows, so off Windows they never gain a value --
;; harmless, since this file is only loaded when `system-type' is windows-nt.
(defvar w32-pass-lwindow-to-system)
(defvar w32-pass-rwindow-to-system)
(defvar w32-pass-apps-to-system)
(defvar w32-lwindow-modifier)
(defvar w32-rwindow-modifier)
(defvar w32-apps-modifier)

;; setting the PC keyboard's various keys to
;; Super or Hyper, for emacs running on Windows.
(setq w32-pass-lwindow-to-system nil
      w32-pass-rwindow-to-system nil
      w32-pass-apps-to-system nil
      w32-lwindow-modifier 'super ; Left Windows key
      w32-rwindow-modifier 'super ; Right Windows key
      w32-apps-modifier 'hyper) ; Menu key
