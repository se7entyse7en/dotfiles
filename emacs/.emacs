;;-------------------;;
;; Packages Archives ;;
;;-------------------;;
;; Add .emacs.d to load-path
(add-to-list 'load-path "~/.emacs.d/")
;; Setup package archives
(setq package-enable-at-startup nil
      package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("melpa-stable" . "https://stable.melpa.org/packages/")
        ("melpa" . "http://melpa.org/packages/"))
      package-archive-priorities
      '(("gnu" . 10)
	("melpa-stable" . 20)
	("melpa" . 30))
      )
(package-initialize)


;;-------------;;
;; Use-package ;;
;;-------------;;
;; Install `use-package` that simplifies handling packages configuration
;; github repo: https://github.com/jwiegley/use-package
(unless (require 'use-package nil t)
  (package-refresh-contents)
  (package-install 'use-package))
;; Ensure by default the presence of a package (install it if not present)
(setq use-package-always-ensure t)


;;------;;
;; PATH ;;
;;------;;
(use-package exec-path-from-shell
  :init
  (setq explicit-shell-file-name "zsh")
  (exec-path-from-shell-initialize)
  )


;;----------;;
;; Language ;;
;;----------;;
;; Setup language
(setq current-language-environment "English")


;;---------------------------------;;
;; Key Bindings - Control and Meta ;;
;;---------------------------------;;
(when (eq system-type 'darwin)
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta)
  )


;;---------;;
;; Utility ;;
;;---------;;
;; Automatically indent on newline
(global-set-key "\r" 'newline-and-indent)

;; Revert buffer without confirmation
(defun revert-buffer-no-confirm ()
  (interactive)
  (revert-buffer :ignore-auto :noconfirm))
(global-set-key (kbd "C-c r") 'revert-buffer-no-confirm)

;; Disable backup files creation
(setq make-backup-files nil)

;; Binding for goto-line
(global-set-key (kbd "M-g") 'goto-line)

;; Automatically delete trailing whitespaces on before-save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Show matching parenthesis
(add-hook 'prog-mode-hook 'show-paren-mode)

;; Avoid interpretig C-m as RET
(define-key input-decode-map [?\C-m] [C-m])

;; Always use spaces for indent
(setq-default indent-tabs-mode nil)

;; Colorize compilation buffer
(defun colorize-compilation-buffer ()
  (ansi-color-apply-on-region compilation-filter-start (point))
  )
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)


;;------------------;;
;; Windows & Frames ;;
;;------------------;;
;; Don't show the startup screen
(setq inhibit-startup-screen t)
;; Don't show the menu bar
(menu-bar-mode 0)
;; Don't show the tool bar
(tool-bar-mode 0)
;; Don't show the scroll bar
(scroll-bar-mode 0)
;; Specify the fringe width for both the left and right fringes to 10
(fringe-mode 10)
;; When the current line is as wide as the window and the point is at the end
;; of the line, avoid drawing the cursor over the right fringe.
(setq overflow-newline-into-fringe nil)
;; Each line of text gets one line on the screen (avoids wrapping around onto a
;; new line)
(setq-default truncate-lines t)
;; Truncate lines even in partial-width windows
(setq truncate-partial-width-windows t)
;; Display line numbers to the right of the window
(global-linum-mode t)

;; Show the current line and column numbers in the stats bar as well
(line-number-mode t)
(column-number-mode t)


;;------------;;
;; Navigation ;;
;;------------;;
;; Simplify navigation of files for a project
(use-package projectile)
(use-package counsel-projectile)
;; Simplify navigation between buffers
(use-package ace-window
  :config
  (setq aw-scope 'frame)
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (setq aw-background nil))


;;-----------;;
;; Multiterm ;;
;;-----------;;
(use-package multi-term
  :config
  (setq multi-term-program "/bin/zsh"))


;;-----;;
;; Git ;;
;;-----;;
;;------------------------------------------------;;
;;                                                ;;
;;          frame 1                  frame 2      ;;
;;  ***********************     ****************  ;;
;;  * window 1 * window 2 *     *    window3   *  ;;
;;  *          *          *     *              *  ;;
;;  *   file   *   file   *     * magit-status *  ;;
;;  * of proj1 * of proj2 *     *              *  ;;
;;  *          *          *     *              *  ;;
;;  ***********************     ****************  ;;
;;                                                ;;
;;------------------------------------------------;;
(defun magit-status-autorefresh (callee)
  (interactive)
  (if (fboundp 'magit-toplevel)
      (let ((project-previous (magit-toplevel)))
	(call-interactively callee)
	(let ((project (magit-toplevel)))
	  (when (and project (not (equal project-previous project)))
	    (let ((status-win
		   (cl-some (lambda (b)
			      (and (with-current-buffer b
				     (derived-mode-p 'magit-status-mode))
				   (get-buffer-window b 'visible)))
			    (buffer-list)))
		  (magit-display-buffer-noselect t)
		  (magit-display-buffer-function
		   (lambda (buffer)
		     (display-buffer buffer '(display-buffer-same-window)))))
	      (when status-win
		(with-selected-frame (window-frame status-win)
		  (with-selected-window status-win
		    (magit-status-internal project))))))))
    (call-interactively callee))
  )

(defun my/other-window ()
  (interactive)
  (magit-status-autorefresh 'other-window)
  )

(defun my/other-frame ()
  (interactive)
  (magit-status-autorefresh 'other-frame)
  )

(defun my/other-counsel-projectile-find-file ()
  (interactive)
  (magit-status-autorefresh 'counsel-projectile-find-file)
  )

(defun my/other-find-file ()
  (interactive)
  (magit-status-autorefresh 'find-file)
  )

(defun my/other-ace-window ()
  (interactive)
  (magit-status-autorefresh 'ace-window)
  )


(use-package magit
  :bind
  ("C-x g" . magit-status)
  ("C-c C-g b" . magit-blame)
  ("C-x o" . my/other-window)
  ("C-x 5 o" . my/other-frame)
  ("C-x F" . my/other-counsel-projectile-find-file)
  ("C-x C-f" . my/other-find-file)
  ("M-o" . my/other-ace-window)
  :config
  (add-hook 'after-save-hook 'magit-after-save-refresh-status)
  (setq magit-process-finish-apply-ansi-colors t)
  (setq magit-log-section-commit-count 50)
  )


(use-package magithub
  :after magit
  :bind
  ("C-c <C-m> c b" . magithub-comment-browse)
  ("C-c <C-m> c n" . magithub-comment-new)
  ("C-c <C-m> l a" . magithub-label-add)
  ("C-c <C-m> l r" . magithub-label-remove)
  :config
  (setq epa-pinentry-mode 'loopback)
  (setq auth-sources '("~/.authinfo.gpg"))
  (magithub-feature-autoinject t))


;;--------;;
;; Python ;;
;;--------;;
;; Use poetry
(use-package poetry
  :ensure t)

;; Use elpy in python mode
(use-package elpy
  :init
  (add-hook 'python-mode-hook '(lambda ()
                                 (setq python-indent-offset 4)))
  (add-hook 'before-save-hook 'elpy-format-code)
  :config
  (elpy-enable)
  (setq elpy-test-django-with-manage t)
  (setq elpy-modules (delq 'elpy-module-highlight-indentation elpy-modules))
  (setq elpy-rpc-virtualenv-path 'current)
  ;; Permits using pdb.set_trace() when running tests in buffer
  (defun elpy-test-run (working-directory command &rest args)
    (let ((default-directory working-directory))
      (compile (mapconcat #'shell-quote-argument
                          (cons command args)
                          " ")
               t))))

;; Use isort and auto sort imports on save
(use-package py-isort
  :init (add-hook 'before-save-hook 'py-isort-before-save))

;; Use pyenv to activate the correct conda environment
(use-package pyvenv
  :init
  (setenv "WORKON_HOME" "/Users/se7entyse7en/miniconda3/envs")
  (pyvenv-mode 1)
  (pyvenv-tracking-mode 1))


;;-------;;
;; Scala ;;
;;-------;;
(use-package ensime
  :ensure t
  :pin melpa-stable
  :init
  (setq ensime-startup-notification nil)
  )

;;------;;
;; Rust ;;
;;------;;
(use-package rust-mode
  :ensure t
  :pin melpa
  :init
  (add-hook 'rust-mode-hook (lambda () (setq indent-tabs-mode nil)))
  (setq rust-format-on-save t)
  (add-hook 'after-save-hook 'rust-check)
  )

(use-package cargo
  :ensure t
  :pin melpa
  :init
  (add-hook 'rust-mode-hook 'cargo-minor-mode)
  )

(use-package flycheck-rust
  :ensure t
  :pin melpa
  :init
  (with-eval-after-load 'rust-mode
    (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))
  )

;;---------;;
;; Arduino ;;
;;---------;;
(setq auto-mode-alist (cons '("\\.\\(pde\\|ino\\)$" . arduino-mode) auto-mode-alist))
(autoload 'arduino-mode "arduino-mode" "Arduino editing mode." t)

;;----;;
;; Go ;;
;;----;;
(use-package go-mode
  :ensure t
  :pin melpa-stable
  :bind (:map go-mode-map
              ("M-." . godef-jump))
  :init
  (setq lsp-gopls-staticcheck t)
  (setq lsp-eldoc-render-all t)
  (setq lsp-gopls-complete-unimported t))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :config (defun lsp-go-install-save-hooks ()
            (add-hook 'before-save-hook #'lsp-format-buffer t t)
            (add-hook 'before-save-hook #'lsp-organize-imports t t))
  :hook ((go-mode . lsp-deferred)
         (go-mode . lsp-go-install-save-hooks)))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :init
  :config (setq lsp-ui-doc-enable nil
                lsp-ui-peek-enable t
                lsp-ui-sideline-enable t
                lsp-ui-imenu-enable t
                lsp-ui-flycheck-enable t)
  )

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1))

(use-package company-lsp
  :ensure t
  :commands company-lsp)

(use-package yasnippet
  :ensure t
  :commands yas-minor-mode
  :hook (go-mode . yas-minor-mode))

;;----------;;
;; Flycheck ;;
;;----------;;
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))

(defun eslint-fix-file ()
  (interactive)
  (message "eslint --fixing the file" (buffer-file-name))
  (shell-command (concat "eslint --fix " (buffer-file-name))))

(defun eslint-fix-file-and-revert ()
  (interactive)
  (eslint-fix-file)
  (revert-buffer t t))


(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode)
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers
                        '(javascript-jshint)))
  (flycheck-add-mode 'javascript-eslint 'rjsx-mode)
  (flycheck-add-mode 'javascript-eslint 'js2-mode)
  (setq flycheck-checkers '(javascript-eslint))
  (setq-default flycheck-temp-prefix ".flycheck")
  (add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
  (add-hook 'js2-mode-hook
            (lambda ()
              (add-hook 'after-save-hook #'eslint-fix-file-and-revert)))
  (add-hook 'rjsx-mode-hook
            (lambda ()
              (add-hook 'after-save-hook #'eslint-fix-file-and-revert)))
  )


;;----------;;
;; Protobuf ;;
;;----------;;
(defconst my-protobuf-style
  '((c-basic-offset . 4)
    (indent-tabs-mode . nil)))

(use-package protobuf-mode
  :ensure t
  :config
  (add-hook 'protobuf-mode-hook
            (lambda () (c-add-style "my-style" my-protobuf-style t)))
  )


;;------;;
;; YAML ;;
;;------;;
(use-package yaml-mode)


;;--------;;
;; Groovy ;;
;;--------;;
(use-package groovy-mode)


;;----------;;
;; Markdown ;;
;;----------;;
(use-package markdown-mode
  :init (add-hook 'markdown-mode-hook '(lambda ()
                                         (setq truncate-lines nil)
                                         (setq truncate-partial-width-windows nil)))
  )


;;---;;
;; R ;;
;;---;;
(use-package ess
  :init
  (require 'ess-site)
  (ess-toggle-underscore nil))


;;------;;
;; JSON ;;
;;------;;
(use-package json-mode)

;;-----------;;
;; Terraform ;;
;;-----------;;
(use-package terraform-mode)


;;------------;;
;; Javascript ;;
;;------------;;
(defun my/npm-run-test ()
  """Execute npm tests for function/module under cursor"
  (interactive)
  (let* ((projdir (locate-dominating-file default-directory "node_modules"))
         (default-directory projdir)
         (cmd (combine-and-quote-strings (list "npm" "run" "test" buffer-file-name))))
    (compile cmd))
  )

(use-package js2-mode
  :bind
  ("C-c C-t" . my/npm-run-test)
  :init
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (add-to-list 'auto-mode-alist '("\\.es6\\'" . js2-mode))
  )


;;-----;;
;; JSX ;;
;;-----;;
(use-package rjsx-mode
  :bind
  ("C-c C-t" . my/npm-run-test)
  :config
  (setq js-indent-level 2)
  )


;;----------;;
;; Web mode ;;
;;----------;;
(use-package web-mode
  :mode (("\\.html\\'" . web-mode)
         ("\\.hbs\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 4)
  (setq web-mode-code-indent-offset 4)
  )


;;------------;;
;; Dockerfile ;;
;;------------;;
(use-package dockerfile-mode
  :init
  (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode)))


;;---------;;
;; Rainbow ;;
;;---------;;
(use-package rainbow-mode
  :init
  (add-hook 'prog-mode-hook 'rainbow-mode))


;;-------;;
;; Theme ;;
;;-------;;
;; Load custom theme
(load-theme 'se7entyse7en t)
(set-face-attribute 'default nil :height 130)


;;-------;;
;; TODOs ;;
;;-------;;
;; Octave
;; Julia
;; Ruby
;; Latex
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-flake8rc ".flake8")
 '(js-indent-level 2)
 '(package-selected-packages
   (quote
    (flycheck-rust cargo rust-mode arduino-mode dash terraform-mode flymd protobuf-mode flycheck go-eldoc auto-complete-config go-autocomplete auto-complete go-mode groovy-emacs-mode groovy-mode multi-term magithub magit yaml-mode web-mode use-package rjsx-mode rainbow-mode py-isort markdown-mode json-mode exec-path-from-shell ess ensime elpy dockerfile-mode counsel-projectile ace-window)))
 '(safe-local-variable-values
   (quote
    ((eval remove-hook
           (quote before-save-hook)
           (quote py-isort-before-save)
           t)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
