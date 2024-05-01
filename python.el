;;; python.el --- Part of my emacs init

;;; Commentary:

;; Support for editing Python files

;;; Code:

;;; Python and friends
;;; See https://realpython.com/emacs-the-best-python-editor/

(declare-function elpy-shell-get-or-create-process "ext:elpy")
(declare-function comint-clear-buffer "ext:comint")
(defvar elpy-modules)
(defvar python-shell-completion-native-disabled-interpreters)

(elpy-enable)

;;; Prevent spurious warning. See https://github.com/brittAnderson/psych363Practice/issues/124
(setq python-shell-completion-native-disabled-interpreters '("pypy" "python3"))

;;; Enable Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode)
  (setq-default flycheck-temp-prefix "/Users/deg/.emacs-flycheck-deg/"))


;;; See https://github.com/jorgenschaefer/elpy/issues/1355
(defun elpy-shell-clear-shell ()
  "Clear the current shell buffer."
  (interactive)
  (with-current-buffer (process-buffer (elpy-shell-get-or-create-process))
    (comint-clear-buffer)))
;;; [TODO] Really should only byind in Python buffers, but I don't have the patience to check how right now
(global-set-key (kbd "C-c #") 'elpy-shell-clear-shell)


;; Automatically activate project venv, if it exists
(defun my-pyvenv-activate-dir ()
  "Search for venv directory and activate virtualenv there if found."
  (let ((venv-dir (locate-dominating-file default-directory ".venv")))
    (when venv-dir
      (pyvenv-activate (concat venv-dir ".venv")))))

(add-hook 'python-mode-hook 'my-pyvenv-activate-dir)


;; Fix problem with Elpy not finding local imports.
(defun my-bounded-locate-dominating-file (dir bound file-name)
  "Search upwards from DIR for FILE-NAME until reaching BOUND.
Return the directory containing FILE-NAME or BOUND if not found."
  (let* ((expanded-dir (expand-file-name dir))
         (expanded-bound (expand-file-name bound))
         (file-path (expand-file-name file-name expanded-dir)))
    (cond ((equal expanded-dir expanded-bound) expanded-bound)
          ((file-exists-p file-path) expanded-dir)
          (t (my-bounded-locate-dominating-file
              (file-name-directory
               (directory-file-name expanded-dir))
              expanded-bound file-name)))))

(defun my-set-pythonpath ()
  "Setup python path when venv activated."
  (let ((project-root (my-bounded-locate-dominating-file
                       default-directory
                       (locate-dominating-file default-directory ".git") ".venv")))
    (when project-root
      (setenv "PYTHONPATH" (expand-file-name project-root)))))

(add-hook 'pyvenv-post-activate-hooks 'my-set-pythonpath)
(add-hook 'pyvenv-post-deactivate-hooks 'my-set-pythonpath)

;; Enable Black formatter.
(add-hook 'python-mode-hook 'blacken-mode)

(provide 'deg-init-python)
;;; python.el ends here

