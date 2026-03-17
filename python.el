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

;; NOTE: use-package-always-ensure t means every use-package block will
;; automatically download and install the package if missing.  This is
;; convenient, but the setting is global — it affects every use-package call
;; in any file loaded after this one, not just the Python ones below.
;; If that ever causes a surprise (e.g. an unexpected package gets auto-installed
;; from another config file), the fix is to remove this line and add :ensure t
;; individually to each use-package block that needs it.
(setq use-package-always-ensure t)

;; Previously this block also hooked LSP startup onto python-mode:
;;
;;   (use-package python :hook (python-mode . lsp))
;;
;; That caused LSP to start *twice* on every Python file, because lsp-pyright
;; (further below) also starts LSP via its own hook.  Removed the hook here.
;; LSP startup is now handled entirely by the lsp-pyright block.
(use-package python)


;;; Python REPL Setup

(defun my-detect-python-repl ()
  "Detect the best available Python REPL (IPython preferred).
This function is called at REPL-launch time (inside my-python-repl),
not at load time.  That means: if you install IPython after starting
Emacs, it will be found the next time you launch the REPL without
needing to restart Emacs."
  (if (executable-find "ipython")
      '("ipython" "-i --simple-prompt")
    '("python" "")))

;; Previously, REPL detection ran at load time (i.e. when Emacs started)
;; via a let* block that looked like this:
;;
;;   (let* ((repl-settings (my-detect-python-repl))
;;          (repl-interpreter (car repl-settings))
;;          (repl-args (cadr repl-settings)))
;;     (setq python-shell-interpreter repl-interpreter
;;           python-shell-interpreter-args repl-args
;;           python-shell-completion-native-enable t
;;           python-shell-completion-native-disabled-interpreters '("python" "ipython")))
;;
;; Two problems were fixed by removing that block:
;;
;; 1. Detection ran only once at startup, so installing IPython after Emacs
;;    started had no effect until you restarted Emacs.  Detection now happens
;;    inside my-python-repl each time you launch the REPL.
;;
;; 2. python-shell-completion-native-enable was set to t (on), but
;;    python-shell-completion-native-disabled-interpreters immediately disabled
;;    it for both "python" and "ipython" — the only two interpreters we use.
;;    So the enable line had zero net effect.  It has been removed.
;;    The disabled-interpreters list is kept below, at its default (off) state.
(setq python-shell-completion-native-disabled-interpreters '("python" "ipython"))

;; REPL Launcher.  Detection now happens here, at launch time, so changes to
;; the environment are always picked up.
(defun my-python-repl ()
  "Start the preferred Python REPL (IPython if available).
Re-detects the right interpreter every time it is called, so installing
IPython after Emacs starts is picked up without restarting Emacs."
  (interactive)
  ;; Set interpreter variables immediately before launching, so
  ;; python-shell-calculate-command (called below) sees the right values.
  (let* ((repl-settings (my-detect-python-repl))
         (repl-interpreter (car repl-settings))
         (repl-args (cadr repl-settings)))
    (setq python-shell-interpreter repl-interpreter
          python-shell-interpreter-args repl-args))
  (run-python (python-shell-calculate-command) t t))


(use-package poetry
  :hook (python-mode . poetry-tracking-mode))

;; LSP (Language Server Protocol) provides IDE features: go-to-definition,
;; find-references, inline type errors, completions, etc.
;;
;; Previously lsp-mode had its own python-mode hook calling (lsp):
;;
;;   (use-package lsp-mode
;;     :hook ((python-mode . (lambda ()
;;                             (unless (eq major-mode 'inferior-python-mode)
;;                               (lsp)))))
;;     :commands lsp)
;;
;; But lsp-pyright's hook (below) already calls (lsp), making this a second
;; LSP startup per file.  Keeping lsp-mode configured as a library (so its
;; commands and variables are available) but without the redundant python hook.
(use-package lsp-mode
  :commands lsp)

;; lsp-pyright connects lsp-mode to Microsoft's Pyright type checker / language
;; server.  This is the single place that starts LSP for Python files.
(use-package lsp-pyright
  :after lsp-mode
  ;; :custom runs once at package-setup time — the correct place for settings
  ;; that apply globally rather than per-buffer.
  ;; Previously, lsp-pyright-python-executable-cmd was set *inside* the hook
  ;; body (the lambda below), which meant it was reset on every file open.
  ;; Moving it here has the same effect but is cleaner.
  :custom
  (lsp-pyright-python-executable-cmd "poetry run python")
  :hook ((python-mode . (lambda ()
                          ;; Don't start LSP in the *Python* REPL buffer itself
                          ;; (inferior-python-mode), only in source file buffers.
                          (unless (eq major-mode 'inferior-python-mode)
                            (require 'lsp-pyright)
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
  ;; Previously hardcoded as "/Users/deg/.emacs-flycheck-deg/", which breaks on
  ;; any machine where the home directory isn't /Users/deg (other Macs, Linux, etc.).
  ;; temporary-file-directory is set by Emacs to the OS temp dir automatically:
  ;; /tmp on Mac/Linux, %TEMP% on Windows.
  (setq-default flycheck-temp-prefix (concat temporary-file-directory "flycheck-deg")))

;; Ruff formatter — replaces Black + isort with a single, faster tool.
;; Ruff format is Black-compatible and handles import sorting too.
(defun ruff-format-buffer ()
  "Format the current Python buffer with ruff, preserving cursor position intelligently.
Works in both python-mode and python-ts-mode.

Background: Emacs 29 introduced python-ts-mode, a separate major mode that uses
the tree-sitter parser for better syntax highlighting.  python-mode and python-ts-mode
are entirely distinct modes with separate hook lists, so a check for just python-mode
would silently skip formatting if you were using python-ts-mode."
  (interactive)
  ;; Previously only checked (eq major-mode 'python-mode), so format-on-save
  ;; did nothing if you happened to be in python-ts-mode.  Now checks both.
  (when (or (eq major-mode 'python-mode)
            (eq major-mode 'python-ts-mode))
    (let* ((temp-file (make-temp-file "ruff-format" nil ".py"))
           (temp-buffer (generate-new-buffer " *ruff-format*"))
           (coding-system-for-read 'utf-8)
           (coding-system-for-write 'utf-8))
      (write-region (point-min) (point-max) temp-file nil 'silent)
      (if (zerop (call-process "ruff" nil nil nil "format" temp-file))
          (progn
            ;; Read formatted content into temp buffer
            (with-current-buffer temp-buffer
              (insert-file-contents temp-file))
            ;; Use replace-buffer-contents for intelligent cursor preservation.
            ;; This uses a diff algorithm to keep point at the semantically same location
            ;; rather than jumping to the top of the file.
            (replace-buffer-contents temp-buffer)
            (kill-buffer temp-buffer)
            (delete-file temp-file))
        (message "Ruff format failed")
        (kill-buffer temp-buffer)
        (delete-file temp-file)))))

;; Register format-on-save for python-mode ...
(add-hook 'python-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'ruff-format-buffer nil t)))
;; ... and also for python-ts-mode (the Emacs 29+ tree-sitter variant).
;; The nil t arguments mean: don't prepend (append instead), and make this
;; hook buffer-local so it only fires in Python buffers.
(add-hook 'python-ts-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'ruff-format-buffer nil t)))

;; OLD CONFIGURATION (replaced by Ruff):
;; (use-package blacken
;;   :ensure t
;;   :hook (python-mode . blacken-mode)
;;   :custom
;;   (blacken-line-length 100))
;;
;; (use-package py-isort
;;   :hook (before-save . py-isort-before-save))

;; Testing Integration
(use-package pytest
  :bind (:map python-mode-map
              ("C-c t" . pytest-one)
              ("C-c T" . pytest-all)))

;; eldoc shows function signatures and documentation in the minibuffer as you type.
;; It is built into Emacs and enabled by default — the use-package call below does
;; nothing useful.  Commented out, but left here as a reminder: if you ever need to
;; configure eldoc (e.g. set eldoc-echo-area-use-multiline-p), do it here.
;;- (use-package eldoc)

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
            ;; Fixups to smashed path: on Mac, activating a virtualenv can strip
            ;; /opt/homebrew/bin from exec-path, causing tools like ruff and pyright
            ;; to become unfindable.  Re-add it here as a safety measure.
            (add-to-list 'exec-path "/opt/homebrew/bin")))

;;- (defun my-pyvenv-fix-path ()
;;-   "Ensure Homebrew stays in exec-path after virtualenv activation."
;;-   (add-to-list 'exec-path "/opt/homebrew/bin"))
;;-
;;- (add-hook 'pyvenv-post-activate-hooks 'my-pyvenv-fix-path)



;;; The next few functions are from older Python tooling.
;;; Their interaction with the current Poetry-based setup is uncertain.

;; Automatically Activate Virtual Environment if .venv Exists
;;
;; This function searches upward from the current file for a .venv directory
;; and activates it.  Its add-hook was commented out on 10Mar25 after it was
;; found to interfere with poetry-tracking-mode, which handles venv activation
;; automatically for Poetry projects.  The function is kept here in case it
;; proves useful for non-Poetry projects in the future.
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
;;
;; NOTE: These two hooks fire on pyvenv-post-activate-hooks and
;; pyvenv-post-deactivate-hooks.  It is unclear whether poetry-tracking-mode
;; fires those hooks when it activates a Poetry virtualenv.  If it does not,
;; my-set-pythonpath never runs and has no effect.  Left here pending
;; verification; if confirmed dead, these can be removed.
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
