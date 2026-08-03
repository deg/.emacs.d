;;; deg-python.el --- Emacs 29 Configuration for Python + Poetry Development

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

;;; Project tool and config discovery
;;
;; Python projects here keep their tools in a virtualenv rather than on PATH, and
;; the config governing a tool is not always in the nearest pyproject.toml.  In a
;; workspace such as marketbuzzr/nutshell-mvp, each sub-package carries its own
;; pyproject.toml with no [tool.ruff] or [tool.mypy] section, while the real
;; settings live further up next to the virtualenv.
;;
;; These are two separate questions — where is the tool, and where is the config
;; that governs it — so they get two separate helpers.  Deriving one from the
;; other would work for the projects here today, but only by coincidence.

(defun my-python-tool (name)
  "Return an absolute path to the Python tool NAME, or nil if not found.
Searches upward from `default-directory' for a .venv directory and prefers NAME
inside it, so a project gets the tool version it pins rather than whatever
happens to be earliest on PATH.  Falls back to `executable-find'."
  (let* ((venv-dir (locate-dominating-file default-directory ".venv"))
         (in-venv (and venv-dir
                       (expand-file-name (concat ".venv/bin/" name) venv-dir))))
    (if (and in-venv (file-executable-p in-venv))
        in-venv
      (executable-find name))))

(defun my-python-config-file (section)
  "Return the nearest pyproject.toml at or above `default-directory' with SECTION.
SECTION is a regexp matched against the file's contents; callers pass the
section header of the tool they are configuring.  Returns nil if no matching
file is found.

`locate-dominating-file' is usually handed a file name, but it also accepts a
predicate function, called with each directory as it walks upward.  That is what
lets this skip a pyproject.toml which exists but does not configure the tool in
question."
  (let ((dir (locate-dominating-file
              default-directory
              (lambda (dir)
                (let ((file (expand-file-name "pyproject.toml" dir)))
                  (and (file-readable-p file)
                       (with-temp-buffer
                         (insert-file-contents file)
                         (goto-char (point-min))
                         (re-search-forward section nil t))))))))
    (and dir (expand-file-name "pyproject.toml" dir))))


;;; Ruff formatter — replaces Black + isort with a single, faster tool.
;;; Ruff format is Black-compatible and handles import sorting too.

(defun my-python--first-line (file)
  "Return the first non-blank line of FILE, or nil if it has none."
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (when (re-search-forward "^.+$" nil t)
      (match-string 0))))

(defun ruff-format-buffer ()
  "Format the current Python buffer with ruff, preserving cursor position.
Works in both `python-mode' and `python-ts-mode', which are distinct major
modes with separate hook lists.

The buffer text is piped to ruff's standard input, with --stdin-filename giving
ruff the buffer's real path.  Ruff resolves its configuration by walking up from
the file it is formatting, so supplying the real path is what makes it find the
project's line-length setting rather than falling back to its built-in default.

On any failure the buffer is left untouched and the reason is shown in the echo
area."
  (interactive)
  (when (and (memq major-mode '(python-mode python-ts-mode))
             buffer-file-name
             (> (buffer-size) 0))
    (let ((ruff (my-python-tool "ruff")))
      (if (not ruff)
          (message "Ruff format skipped: ruff not found")
        (let ((formatted (generate-new-buffer " *ruff-format*"))
              (stderr-file (make-temp-file "ruff-format-stderr"))
              (coding-system-for-read 'utf-8)
              (coding-system-for-write 'utf-8))
          (unwind-protect
              ;; call-process-region feeds a buffer region to the program's
              ;; standard input.  A (BUFFER FILE) destination routes stdout to
              ;; BUFFER and stderr to FILE, so a failure can explain itself.
              (if (and (zerop (call-process-region
                               (point-min) (point-max) ruff
                               nil (list formatted stderr-file) nil
                               "format" "--stdin-filename" buffer-file-name "-"))
                       (> (buffer-size formatted) 0))
                  ;; replace-buffer-contents diffs the two buffers, keeping point
                  ;; and markers at the semantically same place instead of
                  ;; jumping to the top of the file.
                  (replace-buffer-contents formatted)
                (message "Ruff format failed: %s"
                         (or (my-python--first-line stderr-file) "no output")))
            (kill-buffer formatted)
            (delete-file stderr-file)))))))


;;; Flycheck checkers

(defun my-python-setup-flycheck ()
  "Point flycheck's Python checkers at the current project's tools and config.
These are buffer-local settings, so they fix what the editor runs without
touching `exec-path' or PYTHONPATH globally."
  (setq-local flycheck-python-ruff-executable (my-python-tool "ruff"))
  (setq-local flycheck-python-mypy-executable (my-python-tool "mypy"))
  ;; nil means "pass no --config", leaving ruff to search upward from the file
  ;; itself.  Flycheck's default finds the nearest pyproject.toml and passes it
  ;; explicitly; in a workspace that is the sub-package's file, which configures
  ;; nothing and, by being passed explicitly, suppresses ruff's own search.
  (setq-local flycheck-python-ruff-config nil)
  ;; mypy, unlike ruff, does not search upward for a config file, so nil would
  ;; leave it running on defaults.  It needs an explicit path, which flycheck
  ;; accepts in absolute form.
  (setq-local flycheck-python-mypy-config
              (my-python-config-file "^\\[tool\\.mypy\\]")))


;;; Per-buffer Python setup

(defun my-python-mode-setup ()
  "Buffer-local setup shared by `python-mode' and `python-ts-mode'."
  (my-python-setup-flycheck)
  ;; The nil t arguments mean: append rather than prepend, and make the hook
  ;; buffer-local so it only fires in Python buffers.
  (add-hook 'before-save-hook #'ruff-format-buffer nil t))

(add-hook 'python-mode-hook #'my-python-mode-setup)
(add-hook 'python-ts-mode-hook #'my-python-mode-setup)

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

(provide 'deg-init-python)
;;; deg-python.el ends here
