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

;; Enable company mode globally. [TODO] Maybe disable soon
(add-hook 'after-init-hook 'global-company-mode)


(add-hook 'rjsx-mode-hook #'company-mode)
(add-hook 'rjsx-mode-hook #'prettier-mode)
(add-hook 'rjsx-mode-hook #'exec-path-from-shell-initialize)

;; Enable Flycheck globally
(add-hook 'after-init-hook #'global-flycheck-mode)

;; Use ESLint with Flycheck
(declare-function flycheck-add-mode "ext:flycheck" (checker mode))
(defvar flycheck-disabled-checkers)
(flycheck-add-mode 'javascript-eslint 'rjsx-mode)
(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(javascript-jshint)))

(setq-default flycheck-temp-prefix "/Users/deg/.emacs-flycheck-deg/")


(provide 'deg-init-javascript)
;;; javascript.el ends here
