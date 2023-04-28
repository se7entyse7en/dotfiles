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

;; Use isort and auto sort imports on save
(use-package py-isort
  :init (add-hook 'before-save-hook 'py-isort-before-save))

;; Use pyenv to activate the correct conda environment
;; TODO: How to support conda, virtual-env, poetry
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
(use-package cargo
  :ensure t
  :pin melpa)

(use-package rust-mode
  :ensure t
  :pin melpa
  :after (cargo)
  :config
  (add-hook 'rust-mode-hook (lambda ()
                              (setq indent-tabs-mode nil)
                              (setq rust-format-on-save t)
                              (add-hook 'after-save-hook 'rust-check nil 'make-it-local)
                              ))
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

;;----------;;
;; Flycheck ;;
;;----------;;
(use-package flycheck
  :init (global-flycheck-mode))

;;-----------------;;
;; JS/JSX - TS/TSX ;;
;;-----------------;;
(use-package add-node-modules-path)
(use-package prettier-js)

(use-package js
  :defines
  lsp-javascript-format-enable
  :init
  (define-derived-mode js/jsx-mode js-mode "js/jsx"
    "Major mode for JS/JSX"
    (add-node-modules-path)
    (add-hook 'before-save-hook 'prettier-js 100 t))
  :config
  (add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js/jsx-mode))
  (setq lsp-javascript-format-enable nil))

(use-package typescript-mode
  :defines
  lsp-typescript-format-enable
  :init
  (define-derived-mode ts/tsx-mode typescript-mode "ts/tsx"
    "Major mode for TS/TSX"
    (add-node-modules-path)
    (add-hook 'before-save-hook 'prettier-js 100 t))
  :config
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . ts/tsx-mode))
  (setq lsp-typescript-format-enable nil))

;;-------------;;
;; Tree Sitter ;;
;;-------------;;
;; TODO: Add other programming languages:
;;   https://github.com/emacs-tree-sitter/tree-sitter-langs/tree/master/repos
(use-package tree-sitter
  :hook ((js/jsx-mode . tree-sitter-hl-mode)
	 (ts/tsx-mode . tree-sitter-hl-mode)))

(use-package tree-sitter-langs
  :after tree-sitter
  :config
  (tree-sitter-require 'tsx)
  (add-to-list 'tree-sitter-major-mode-language-alist '(js/jsx-mode . tsx))
  (add-to-list 'tree-sitter-major-mode-language-alist '(ts/tsx-mode . tsx)))

;;-----;;
;; LSP ;;
;;-----;;
(use-package python
  :defines
  lsp-pylsp-plugins-pydocstyle-enabled
  lsp-pylsp-plugins-pycodestyle-enabled
  lsp-pylsp-plugins-mccabe-enabled
  lsp-pylsp-plugins-pyflakes-enabled
  lsp-pylsp-plugins-pylint-enabled
  lsp-pylsp-plugins-yapf-enabled
  lsp-pylsp-plugins-autopep8-enabled
  :config
  (setq lsp-pylsp-plugins-pydocstyle-enabled nil)
  (setq lsp-pylsp-plugins-pycodestyle-enabled nil)
  (setq lsp-pylsp-plugins-mccabe-enabled nil)
  (setq lsp-pylsp-plugins-pyflakes-enabled nil)
  (setq lsp-pylsp-plugins-pylint-enabled nil)
  (setq lsp-pylsp-plugins-yapf-enabled nil)
  (setq lsp-pylsp-plugins-autopep8-enabled t)
  (lsp-register-custom-settings '(("pyls.plugins.pyls_mypy.enabled" t t)
                                  ("pyls.plugins.pyls_mypy.live_mode" nil t)
                                  ("pylsp.plugins.pylsp_mypy.enabled" t t)
                                  ("pylsp.plugins.pylsp_mypy.live_mode" nil t)))
  )

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :commands (lsp lsp-deferred)
  :config
  (defun lsp-install-before-save-hooks ()
    (add-hook 'before-save-hook #'lsp-format-buffer t t)
    (add-hook 'before-save-hook #'lsp-organize-imports t t))
  :hook ((lsp-mode . lsp-enable-which-key-integration)
         (lsp-mode . lsp-install-before-save-hooks)
         (go-mode . lsp-deferred)
         (js/jsx-mode . lsp-deferred)
         (ts/tsx-mode . lsp-deferred)
         (python-mode . lsp-deferred)))

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package which-key
    :config
    (which-key-mode))

;;-------------;;
;; Development ;;
;;-------------;;
(global-set-key (kbd "C-c t") (lambda () (interactive) (insert "[@se7entyse7en] TODO: ")))

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
   '(typescript javascript-mode js-mode flycheck-rust cargo rust-mode arduino-mode dash terraform-mode flymd protobuf-mode flycheck go-eldoc auto-complete-config go-autocomplete auto-complete go-mode groovy-emacs-mode groovy-mode multi-term magithub magit yaml-mode web-mode use-package rjsx-mode rainbow-mode py-isort markdown-mode json-mode exec-path-from-shell ess ensime elpy dockerfile-mode counsel-projectile ace-window))
 '(safe-local-variable-values
   '((eval remove-hook 'before-save-hook 'py-isort-before-save t)))
 '(typescript-indent-level 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
