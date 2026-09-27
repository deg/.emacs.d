;;; early-init.el --- Settings needed before packages and the first frame  -*- lexical-binding: t; -*-

;; Emacs loads this file before `package-initialize' and before creating the
;; first frame, so anything here is in force for everything init.el does.


;; Native compilation on macOS 27.
;;
;; Emacs compiles Lisp to machine code on the fly with libgccjit, which calls
;; clang.  The libgccjit bundled with the emacsformacosx build guesses the macOS
;; version from the Darwin kernel version, and on macOS 27 (Darwin 27) it guesses
;; 18.0 -- a version that never existed, since Apple jumped from 15 to 26.  clang
;; rejects it ("invalid version number in '-mmacosx-version-min=18.0'"), every
;; compile fails, and init aborts at the first `fset' or advice on a built-in
;; function.  Setting MACOSX_DEPLOYMENT_TARGET gives the compiler a valid version
;; instead of the guess; `setenv' reaches the compiler because it runs as a
;; subprocess of this Emacs.
(when (eq system-type 'darwin)
  (setenv "MACOSX_DEPLOYMENT_TARGET" "26.0"))
