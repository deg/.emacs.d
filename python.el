;;; python.el --- Emacs 29 Configuration for Python + Poetry Development

;;; Commentary:
;; This file sets up Python development with Poetry, LSP, and related tools.
;; It integrates virtual environment management, syntax highlighting, linting,
;; formatting, and testing features tailored for Emacs 29.

;;; Code:

;; Ensure use-package is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package python
  :hook (python-mode . lsp))

;;; Python REPL Setup
(defun my-detect-python-repl ()
  "Detect the best available Python REPL (IPython preferred)."
  (if (executable-find "ipython")
      '("ipython" "-i --simple-prompt")
    '("python" "")))

;; Apply REPL settings globally
(let* ((repl-settings (my-detect-python-repl))
       (repl-interpreter (car repl-settings))
       (repl-args (cadr repl-settings)))
  (setq python-shell-interpreter repl-interpreter
        python-shell-interpreter-args repl-args
        python-shell-completion-native-enable t
        python-shell-completion-native-disabled-interpreters '("python" "ipython")))

;; REPL Launcher
(defun my-python-repl ()
  "Start the preferred Python REPL (IPython if available)."
  (interactive)
  (run-python (python-shell-calculate-command) t t))

(use-package poetry
  :hook (python-mode . poetry-tracking-mode))

;; LSP for Python (Enabled only for regular development, not in REPL mode)
(use-package lsp-mode
  :hook ((python-mode . (lambda ()
                          (unless (eq major-mode 'inferior-python-mode)
                            (lsp)))))
  :commands lsp)

(use-package lsp-pyright
  :after lsp-mode
  :hook ((python-mode . (lambda ()
                          (unless (eq major-mode 'inferior-python-mode)
                            (require 'lsp-pyright)
                            (setq lsp-pyright-python-executable-cmd "poetry run python")
                            (lsp))))))

;; Tree-sitter for Syntax Highlighting
(use-package tree-sitter
  :hook (python-mode . tree-sitter-mode)
  :config
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :after tree-sitter)

;; Code Navigation and Project Management
(use-package projectile
  :init (projectile-mode +1)
  :bind ("C-c p" . projectile-command-map))

(use-package consult
  :bind (("C-S-s" . consult-line)))  ; Shift+Ctrl+S for consult-line

;; Linting and Formatting
(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (setq-default flycheck-temp-prefix "/Users/deg/.emacs-flycheck-deg/"))

;; Ruff formatter - replaces Black + isort with a single, faster tool
(defun ruff-format-buffer ()
  "Format the current Python buffer with ruff."
  (interactive)
  (when (eq major-mode 'python-mode)
    (let* ((temp-file (make-temp-file "ruff-format" nil ".py"))
           (coding-system-for-read 'utf-8)
           (coding-system-for-write 'utf-8))
      (write-region (point-min) (point-max) temp-file nil 'silent)
      (if (zerop (call-process "ruff" nil nil nil "format" temp-file))
          (progn
            (erase-buffer)
            (insert-file-contents temp-file)
            (delete-file temp-file))
        (message "Ruff format failed")
        (delete-file temp-file)))))

(add-hook 'python-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'ruff-format-buffer nil t)))


;; Testing Integration
(use-package pytest
  :bind (:map python-mode-map
              ("C-c t" . pytest-one)
              ("C-c T" . pytest-all)))

;; Optional Enhancements
(use-package eldoc)
(use-package which-key
  :init (which-key-mode))

;; Custom Function to Clear Shell Buffer
(defun clear-python-shell ()
  "Clear the current Python shell buffer."
  (interactive)
  (let ((process (get-buffer-process (current-buffer))))
    (when process
      (with-current-buffer (process-buffer process)
        (comint-clear-buffer)))))


;;; Bindings

(global-set-key (kbd "C-c #") 'clear-python-shell)


(add-hook 'python-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-z") 'my-python-repl)
            (local-set-key (kbd "C-c r") 'consult-ripgrep)
            ;; Fixups to smashed path
            (add-to-list 'exec-path "/opt/homebrew/bin")))

;;- (defun my-pyvenv-fix-path ()
;;-   "Ensure Homebrew stays in exec-path after virtualenv activation."
;;-   (add-to-list 'exec-path "/opt/homebrew/bin"))
;;- 
;;- (add-hook 'pyvenv-post-activate-hooks 'my-pyvenv-fix-path)



;;; The next few functions are from my old Python tooling. I don't know if they are
;;; still needed.

;; Automatically Activate Virtual Environment if .venv Exists
(defun my-pyvenv-activate-dir ()
  "Search for .venv directory and activate virtualenv if found."
  (let ((venv-dir (locate-dominating-file default-directory ".venv")))
    (when venv-dir
      (pyvenv-activate (concat venv-dir ".venv")))))

;;; Commented out, 10Mar25.  ChatGPT
;;; (https://chatgpt.com/g/g-p-67bf5bc6c9c0819194ca6a3b49f71267-blogscraper/c/67cea266-9890-8009-a1e3-78f5a5a6862d)
;;; claims that it is not needed and interferes with poetry-tracking-mode
;;;- (add-hook 'python-mode-hook 'my-pyvenv-activate-dir)

;; Fix PYTHONPATH for Local Imports
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
  "Setup PYTHONPATH when virtualenv is activated."
  (let ((project-root (my-bounded-locate-dominating-file
                       default-directory
                       (locate-dominating-file default-directory ".git") ".venv")))
    (when project-root
      (setenv "PYTHONPATH" (expand-file-name project-root)))))

(add-hook 'pyvenv-post-activate-hooks 'my-set-pythonpath)
(add-hook 'pyvenv-post-deactivate-hooks 'my-set-pythonpath)

(provide 'deg-init-python)
;;; python.el ends here
