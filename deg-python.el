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
;; find-references, inline type errors, completions, etc.  lsp-pyright connects
;; lsp-mode to Microsoft's Pyright type checker / language server.
;;
;; Both packages are declared here only so they are installed and available.
;; Neither declares a hook: startup happens in `my-python-mode-setup' below, in
;; one place alongside the rest of the per-buffer Python setup.
;;
;; Be careful reintroducing use-package deferral keywords here.  ":commands lsp"
;; on lsp-mode plus ":after lsp-mode" on lsp-pyright is a deadlock: lsp-mode waits
;; for someone to call `lsp', lsp-pyright waits for lsp-mode to load, and the only
;; caller of `lsp' lives inside the lsp-pyright block that never runs.  Neither
;; package ever loads and LSP silently never starts.
;;
;; lsp-pyright finds the interpreter itself, via `lsp-pyright-python-search-functions',
;; whose first entry walks up from the current file looking for .venv — the same
;; search `my-python-tool' does.  So it needs no interpreter setting from us.
(use-package lsp-mode
  :defer t
  :custom
  ;; Without this, opening a Python file in a project lsp-mode has not seen
  ;; before pops a modal asking which directory is the project root.  With it,
  ;; lsp-mode uses the root it detects (the git/projectile root), which is where
  ;; a pyrightconfig.json belongs anyway.
  (lsp-auto-guess-root t)
  ;; lsp-mode asks the language server to watch every directory in the project
  ;; and blocks with a yes/no prompt once there are more than
  ;; lsp-file-watch-threshold of them (default 1000).  The repos here are far
  ;; over that even after the default ignore list: nutshell-mvp has ~12000
  ;; directories, ~3700 of them outside .git, .venv, node_modules and .beads.
  ;; So this would prompt on essentially every project, and answering yes would
  ;; register thousands of macOS file watchers.
  ;;
  ;; TRADEOFF: with watchers off, the language server does not learn about files
  ;; changed outside Emacs — by a git pull, or by an agent editing the tree —
  ;; until the workspace is restarted (M-x lsp-workspace-restart).  Diagnostics
  ;; for buffers open in Emacs are unaffected.  To trade back, set this to t and
  ;; raise lsp-file-watch-threshold above the project's directory count.
  (lsp-enable-file-watchers nil)
  ;; lsp-mode also ships a ruff language server client, which it launches as the
  ;; bare command "ruff server" — i.e. whatever ruff is first on PATH.  Here that
  ;; is a pyenv shim several minor versions behind what projects pin, so its
  ;; diagnostics disagree with the project's own lint run.  Flycheck's python-ruff
  ;; checker already runs the project's own ruff with the project's own config
  ;; (see `my-python-setup-flycheck'), so this client is redundant as well as
  ;; wrong.  Pyright still runs over LSP.
  (lsp-disabled-clients '(ruff))
  ;; Diagnostics stay with flycheck; lsp-mode is here for navigation, completion
  ;; and hover.
  ;;
  ;; The default, :auto, hands diagnostics to lsp-mode: it sets flycheck-checker
  ;; to `lsp' in managed buffers, which runs that checker and nothing else.  That
  ;; silences ruff and mypy, which the project's own lint run does execute.
  ;; Chaining them after `lsp' with flycheck-add-next-checker does not fix it —
  ;; the lsp checker reports asynchronously as the server pushes diagnostics
  ;; rather than driving flycheck's chain, so the next checker never runs.  This
  ;; was measured, not assumed: with the chain configured, three consecutive
  ;; checks reported lsp diagnostics only and never mypy's.
  ;;
  ;; So diagnostics come from flycheck, running the project's own ruff and mypy
  ;; with the project's own config.  Pyright's findings are not shown inline; it
  ;; still runs as a server, and `make lint' still runs it in full.
  (lsp-diagnostics-provider :none))

(use-package lsp-pyright
  :defer t
  :custom
  ;; One pyright server per project, each scoped to its own root.
  ;;
  ;; The default, t, makes a single server adopt every folder lsp-mode has ever
  ;; recorded in ~/.emacs.d/.lsp-session-v1.  That list only grows, and had reached
  ;; 18 roots — including projects since moved, two copies of the same one, and a
  ;; directory inside pyenv's Python 3.12 standard library.  Pyright then indexed
  ;; all of them at every startup, and could resolve a symbol to a stale copy of a
  ;; project rather than the one being edited.
  ;;
  ;; lsp-pyright reads this when it registers its client, i.e. when the package
  ;; loads, so it has to be set beforehand.  :custom does that correctly — it
  ;; expands to a customize-set-variable that runs at startup, well before the
  ;; deferred package is pulled in.
  (lsp-pyright-multi-root nil))

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

(defun my-python-venv-bin-dir ()
  "Return the bin directory of the project's virtualenv, or nil if there is none.
Searches upward from `default-directory' for a .venv directory."
  (let ((venv-dir (locate-dominating-file default-directory ".venv")))
    (when venv-dir
      (let ((bin (expand-file-name ".venv/bin" venv-dir)))
        (and (file-directory-p bin) bin)))))

(defun my-python-tool (name)
  "Return an absolute path to the Python tool NAME, or nil if not found.
Prefers NAME inside the project's virtualenv, so a project gets the tool version
it pins rather than whatever happens to be earliest on PATH.  Falls back to
`executable-find'."
  (let* ((bin (my-python-venv-bin-dir))
         (in-venv (and bin (expand-file-name name bin))))
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
              (my-python-config-file "^\\[tool\\.mypy\\]"))
  ;; lsp-mode puts its own `lsp' checker at the front of flycheck's list, and
  ;; flycheck runs the first usable one it finds.  Diagnostics here come from the
  ;; project's own tools instead (see `lsp-diagnostics-provider' above), so take
  ;; it out of the running in Python buffers.
  (setq-local flycheck-disabled-checkers (cons 'lsp flycheck-disabled-checkers))
  ;; Name the first checker rather than letting flycheck pick by list order,
  ;; which would land on mypy and stop — mypy declares no next checker, so ruff
  ;; would never run.  python-ruff chains to python-mypy, giving the same two
  ;; tools, in the same order, as the project's lint run.
  (setq-local flycheck-checker 'python-ruff))


;;; Per-buffer Python setup

(defun my-python-mode-setup ()
  "Buffer-local setup shared by `python-mode' and `python-ts-mode'."
  (my-python-setup-flycheck)
  ;; The nil t arguments mean: append rather than prepend, and make the hook
  ;; buffer-local so it only fires in Python buffers.
  (add-hook 'before-save-hook #'ruff-format-buffer nil t)
  (require 'lsp-pyright)
  ;; lsp-mode finds a language server with `executable-find', evaluated when it
  ;; spawns the process rather than here — so a buffer-local exec-path does not
  ;; reach it, and pyright-langserver resolves to a pyenv shim for a Python
  ;; version that does not have it installed.  The server then dies at startup
  ;; and lsp-mode prompts to restart it, repeatedly.
  ;;
  ;; `lsp-dependency' is the documented way to pin an absolute path: an absolute
  ;; path is returned as-is instead of being looked up.  Registration is global,
  ;; so it is redone here for each buffer, immediately before starting the server
  ;; for that buffer's project.
  (let ((server (my-python-tool "pyright-langserver")))
    (when server
      (lsp-dependency 'pyright (list :system server))))
  (lsp))

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
