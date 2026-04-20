;;; javascript.el --- Part of my emacs init

;;; Commentary:

;; Support for editing JavaScript/React/TypeScript files

;;; Code:

;; Install packages
(unless (and (package-installed-p 'rjsx-mode)
             (package-installed-p 'company)
             (package-installed-p 'flycheck)
             (package-installed-p 'prettier))
  (package-refresh-contents)
  (package-install 'rjsx-mode)
  (package-install 'company)
  (package-install 'flycheck)
  (package-install 'prettier))

;; Enable rjsx-mode for .js and .jsx files
(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . rjsx-mode))

(add-hook 'rjsx-mode-hook #'company-mode)
(add-hook 'rjsx-mode-hook #'prettier-mode)
(add-hook 'rjsx-mode-hook #'exec-path-from-shell-initialize)

;;; Set current directory for all tools to find configs, etc.
; [LATER] This does not seem to be needed. Save just in case.
; (defun my/set-js-default-directory ()
;   "Set the default directory to the one containing package.json."
;   (let ((package-root (locate-dominating-file buffer-file-name "package.json")))
;     (when package-root
;       (setq default-directory package-root))))
; (add-hook 'rjsx-mode-hook 'my/set-js-default-directory)
; (add-hook 'js-mode-hook 'my/set-js-default-directory)


;;; ;; Use project's ESLint configuration
;;; [LATER] This does not seem to be needed. Save just in case.
; (defun my/use-local-eslint ()
;   "Configure Flycheck to use local ESLint."
;   (let* ((root (locate-dominating-file
;                 (or (buffer-file-name) default-directory)
;                 "package.json"))
;          (eslint (and root
;                       (expand-file-name "node_modules/.bin/eslint"
;                                         root))))
;     (when (and eslint (file-executable-p eslint))
;       (setq-local flycheck-javascript-eslint-executable eslint)
;       (setq-local flycheck-eslintrc (expand-file-name ".eslintrc" root)))))
; (add-hook 'flycheck-mode-hook #'my/use-local-eslint)


;;; Suppress js2 warning about browser-specific names
;;; [TODO] Should only be enabled in browser projects, etc.
(with-eval-after-load 'js2-mode
  (setq js2-global-externs '(;; Browser
                             "AbortController" "Blob" "chrome" "document" "FileReader"
                             "FormData" "localStorage" "Storage" "MutationObserver"
                             "URL" "URLSearchParams" "window"
                             ;; Google Sheets Apps Script
                             "GmailApp" "Logger" "MailApp" "PropertiesService"
                             "ScriptApp" "Session" "SpreadsheetApp" "UrlFetchApp"
                             "Utilities"
                             ;; My magic
                             "__APP_VERSION__"
                             )))


;; Use ESLint with Flycheck
(declare-function flycheck-add-mode "ext:flycheck" (checker mode))
(defvar flycheck-disabled-checkers)
(flycheck-add-mode 'javascript-eslint 'rjsx-mode)
(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(javascript-jshint)))


(provide 'deg-init-javascript)
;;; javascript.el ends here
