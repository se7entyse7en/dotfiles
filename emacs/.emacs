;;-------------------;;
;; Packages Archives ;;
;;-------------------;;
;; Add .emacs.d to load-path
(add-to-list 'load-path "~/.emacs.d/")
;; Setup package archives
(setq package-enable-at-startup nil
      package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("marmalade" . "https://marmalade-repo.org/packages/")
	("melpa-stable" . "https://stable.melpa.org/packages/")
        ("melpa" . "http://melpa.org/packages/"))
      package-archive-priorities
      '(("gnu" . 10)
        ("marmalade" . 20)
	("melpa-stable" . 30)
	("melpa" . 40))
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
             :init (exec-path-from-shell-initialize))


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
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (setq aw-background nil))


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
  ("C-x F" . my/other-counsel-projectile-find-file)
  ("C-x C-f" . my/other-find-file)
  ("M-o" . my/other-ace-window)
  :config
  (add-hook 'after-save-hook 'magit-after-save-refresh-status)
  (setq magit-process-finish-apply-ansi-colors t))


(use-package magithub
  :after magit
  :bind
  ("C-c <C-m> c b" . magithub-comment-browse)
  ("C-c <C-m> c n" . magithub-comment-new)
  ("C-c <C-m> l a" . magithub-label-add)
  ("C-c <C-m> l r" . magithub-label-remove)
  :config
  (setq epa-pinentry-mode 'loopback)
  (magithub-feature-autoinject t))


;;--------;;
;; Python ;;
;;--------;;
;; Use elpy in python mode
(use-package elpy
             :init (add-hook 'python-mode-hook '(lambda ()
                                                  (setq python-indent-offset 4)))
             :config
	     (elpy-enable)
	     (setq elpy-test-django-with-manage t)
	     (setq elpy-modules (delq 'elpy-module-highlight-indentation elpy-modules))
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
;; YAML ;;
;;------;;
(use-package yaml-mode)


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
  )


;;----------;;
;; Web mode ;;
;;----------;;
(use-package web-mode
  :mode (("\\.html\\'" . web-mode)
         ("\\.hbs\\'" . web-mode))
  :config
  (setq web-mode-engines-alist
	'(("django"    . "/viralize-web/.*\\.html\\'"))
	)
  (setq web-mode-markup-indent-offset 2)
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


;;-------;;
;; TODOs ;;
;;-------;;
;; Octave
;; Julia
;; Ruby
;; Latex
