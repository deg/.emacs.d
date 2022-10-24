;;; Python and friends
;;; See https://realpython.com/emacs-the-best-python-editor/


(elpy-enable)

;;; Prevent spurious warning. See https://github.com/brittAnderson/psych363Practice/issues/124
(setq python-shell-completion-native-disabled-interpreters '("pypy" "python3"))

;;; Enable Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))


;;; See https://github.com/jorgenschaefer/elpy/issues/1355
(defun elpy-shell-clear-shell ()
  "Clear the current shell buffer."
  (interactive)
  (with-current-buffer (process-buffer (elpy-shell-get-or-create-process))
    (comint-clear-buffer)))
;;; [TODO] Really should only byind in Python buffers, but I don't have the patience to check how right now
(global-set-key (kbd "C-c #") 'elpy-shell-clear-shell)
