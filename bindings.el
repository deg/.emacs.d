;;; bindings.el --- Global key bindings  -*- lexical-binding: t; -*-

;; Declared, not defined.  A `defvar' with no value simply tells the byte
;; compiler that these names are real variables rather than typos; the owning
;; package still creates them and supplies their values when it loads.
(defvar compilation-mode-map)
(defvar magit-mode-map)
(defvar comint-scroll-to-bottom-on-input)
(defvar comint-scroll-to-bottom-on-output)
(defvar comint-scroll-show-maximum-output)
(defvar comint-completion-autolist)
(defvar comint-input-ignoredups)
(defvar comint-completion-addsuffix)
(defvar comint-move-point-for-output)
(defvar comint-prompt-read-only)


;;; Turn C-[ into a key of its own
;;
;; C-[ and ESC are the same character -- both are ASCII 27 -- so from the
;; character alone Emacs cannot tell which one you pressed.  That matters
;; because ESC ESC ESC runs `keyboard-escape-quit', which among other things
;; deletes all but the selected window.  Three C-[ in a row, from a finger that
;; missed C-p, would wipe out the window layout.
;;
;; Under a window system the two keys do arrive differently: the physical Escape
;; key sends the symbol `escape', while C-[ sends the raw character 27.  The
;; block below exploits that difference.  Emacs consults `function-key-map'
;; before `key-translation-map', so emptying the escape entry out of the earlier
;; map and recreating it in the later one lets the raw 27 be diverted without
;; the Escape key being caught along with it:
;;
;;   physical Esc -> `escape' -> key-translation-map -> ESC, as usual
;;   C-[          -> 27       -> key-translation-map -> C-<left_bracket>
;;
;; C-<left_bracket> is a synthetic key that nothing generates on its own, and
;; nothing is bound to it, so C-[ simply reports itself as undefined.
;;
;; That undefined report can take a moment to appear, which looks like a failure
;; but is not.  Character 27 is also `meta-prefix-char', so a lone C-[ is
;; ambiguous -- Emacs cannot yet tell whether a Meta sequence is starting.  It
;; echoes "ESC" and waits; a following keystroke resolves it.  C-h k reports ESC
;; for the same reason until a second key arrives.  Either way ESC ESC ESC is
;; never reached, which is the whole point.
;;
;; None of this can work on a terminal, where both keys arrive as byte 27 with
;; nothing to tell them apart -- there the translation would swallow the real
;; Escape key and ESC-as-Meta-prefix along with it.  Hence the
;; `display-graphic-p' guard.
;; From https://superuser.com/questions/173851/linux-remap-ctrl-key
(when (display-graphic-p)
  (define-key key-translation-map [?\C-\[] [(control left_bracket)])
  (define-key key-translation-map [escape] [?\e])
  (define-key function-key-map [escape] nil)
  (define-key function-key-map [?\e] nil)
  ;; `local-function-key-map' is per-terminal, so it has to be cleared as each
  ;; terminal comes up rather than once at load time.
  (defun remove-escape-from-local-function-key-map ()
    "Drop the escape entries from this terminal's `local-function-key-map'."
    (define-key local-function-key-map [?\e] nil)
    (define-key local-function-key-map [escape] nil))
  (add-hook 'term-setup-hook 'remove-escape-from-local-function-key-map))


;; Reasonable scrolling behavior
(setq scroll-preserve-screen-position t)
(global-set-key (kbd "M-<up>") 'scroll-down)
(global-set-key (kbd "M-<down>") 'scroll-up)
(global-set-key (kbd "M-z") 'scroll-down-line)
(global-set-key (kbd "C-z") 'scroll-up-line)

;; Familiar bindings
(global-set-key (kbd "M-=") 'compare-windows)
(global-set-key (kbd "C-h a") 'apropos)
(global-set-key (kbd "C-h C-a") 'apropos-command)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-x g") 'goto-line)

;; New bindings
(global-set-key (kbd "C-c TAB") 'browse-url)
;; A real terminal emulator (see the ghostel block in packages.el), so ncurses
;; apps and color prompts work — unlike shell/ansi-term.  Starts in the current
;; buffer's directory; M-x ghostel-project starts at the project root instead.
(global-set-key (kbd "C-x !") 'ghostel)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-c ;") 'comment-region)
;; Inert on this Mac: `ns-command-modifier' and `ns-alternate-modifier' are both
;; `meta', and nothing else is mapped to super, so no key can produce s-.  Kept
;; because it does work on Linux, where the Windows key supplies super.
(global-set-key (kbd "<s-backspace>") 'kill-backward-up-list)

;; Improve grep navigation
(global-set-key (kbd "M-n") 'next-error)
(global-set-key (kbd "M-p") 'previous-error)
(define-key compilation-mode-map (kbd "M-n") 'next-error)
(define-key compilation-mode-map (kbd "M-p") 'previous-error)


;;; Version control; see Magit documentation at http://magit.github.com/magit/magit.html
(global-set-key (kbd "C-c g") 'magit-status)

;; My functions
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)
(global-set-key (kbd "M-SPC") 'kill-whitespace)

;; Clever undo
(global-undo-tree-mode)
(global-set-key (kbd "C-x u") 'undo-tree-visualize)
(global-set-key [f9] 'undo-tree-undo)
(global-set-key [f10] 'undo-tree-redo)


;; Shell window
;; (much from https://snarfed.org/why_i_dont_run_shells_inside_emacs)
;; Using setq (not custom-set-variables) so these inline comments survive
;; a future Customize UI save — Customize rewrites its managed block from
;; scratch and drops all comments in the process.
(setq comint-scroll-to-bottom-on-input  t     ; always insert at the bottom
      comint-scroll-to-bottom-on-output t     ; always add output at the bottom
      comint-scroll-show-maximum-output t     ; scroll to show max possible output
      comint-completion-autolist        t     ; show completion list when ambiguous
      comint-input-ignoredups           t     ; no duplicates in command history
      comint-completion-addsuffix       t     ; insert space/slash after file completion
      comint-move-point-for-output      'all  ; always scroll to show new output
      comint-prompt-read-only           t)    ; prompt text is read only
; interpret and use ansi color codes in shell output windows
(ansi-color-for-comint-mode-on)
; make completion buffers disappear after 3 seconds.
(add-hook 'completion-setup-hook
  (lambda () (run-at-time 3 nil
    (lambda () (delete-windows-on "*Completions*")))))


;; Magit
(with-eval-after-load 'magit
  (define-key magit-mode-map (kbd "M-.") 'magit-diff-visit-file-other-window))


;; run a few shells.
;; (shell "*clojure-shell*")
;;(shell "*javascript-shell*")

