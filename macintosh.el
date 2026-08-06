;;; macintosh.el --- macOS-specific settings  -*- lexical-binding: t; -*-

;; Loaded from init.el only when `system-type' is `darwin'.


;; `toggle-frame-fullscreen' normally hands the frame to macOS's own fullscreen,
;; which moves Emacs into a Space of its own: a slide animation on the way in,
;; the menu bar auto-hiding, and no way to put another window beside it.  Setting
;; this to nil keeps fullscreen within the current Space -- the frame simply
;; grows to fill the screen.
;;
;; `boundp' guards a build without the NS interface, since this file is also
;; reached by `emacs --batch -l init.el'.
(when (boundp 'ns-use-native-fullscreen)
  (setq ns-use-native-fullscreen nil))


;; Dired wants GNU ls for its `--dired' flag, which the BSD `ls' that macOS
;; ships does not support.  Homebrew's coreutils provides it as `gls', and Emacs
;; picks that up on its own: the `insert-directory-program' defcustom in files.el
;; runs `executable-find' for it at startup on macOS.  So there is nothing to set
;; here -- just a dependency on `brew install coreutils' worth knowing about.
