;;-------------------;;
;; Packages Archives ;;
;;-------------------;;
;; Add .emacs.d to load-path
(add-to-list 'load-path "~/.emacs.d/lisp/")
;; Setup package archives
(setq package-enable-at-startup nil
      package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("marmalade" . "https://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
	("melpa-stable" . "https://stable.melpa.org/packages/"))
      package-archive-priorities
      '(("gnu" . 10)
        ("marmalade" . 20)
        ("melpa" . 30)
	("melpa-stable" . 40))
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
;; (when (eq system-type 'darwin)
;;   (setq mac-option-modifier 'alt)
;;   (setq mac-command-modifier 'meta)
;;   )


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


(add-hook 'before-save-hook 'delete-trailing-whitespace)


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
;; (global-linum-mode t)

;; Show the current line and column numbers in the stats bar as well
(line-number-mode t)
(column-number-mode t)


;;------------;;
;; Navigation ;;
;;------------;;
;; Simplify navigation of files for a project
(use-package projectile)
(use-package counsel-projectile
             :bind ("C-x F" . counsel-projectile-find-file))
(use-package ace-window
             :bind ("M-o" . ace-window)
             :config
             (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
             (setq aw-background nil))


;;--------;;
;; Python ;;
;;--------;;
;; Use elpy in python mode
(use-package elpy
             :init (add-hook 'python-mode-hook '(lambda ()
                               (setq python-indent-offset 4)
                               (setq indent-tabs-mode nil)))
             :config
	     (elpy-enable)
	     (setq elpy-modules (delq 'elpy-module-highlight-indentation elpy-modules)))

;; Use isort and auto sort imports on save
(use-package py-isort
             :init (add-hook 'before-save-hook 'py-isort-before-save))


;;------;;
;; YAML ;;
;;------;;
(use-package yaml-mode)


;;----------;;
;; Markdown ;;
;;----------;;
(use-package markdown-mode)


;;-------------;;
;; R and Julia ;;
;;-------------;;
;; (use-package ess
;;  :init
;;  (require 'ess-site)
;;  (ess-toggle-underscore nil)
;;  )


;;-------;;
;; Theme ;;
;;-------;;
;; Load custom theme
;; (load-theme 'se7entyse7en t)

;; No tab indentation
(setq-default indent-tabs-mode nil)

(require 'whitespace)
(setq whitespace-line-column 80) ;; limit line length
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)
;; (setq whitespace-style '(face lines-tail))
;; (add-hook 'prog-mode-hook 'whitespace-mode)


;; whitespace cleanup before saving
(add-hook 'before-save-hook 'whitespace-cleanup)


;;------------;;
;; Javascript ;;
;;------------;;
 (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;;----------------------;;
;; DJANGO HTML Template ;;
;;----------------------;;
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(setq web-mode-engines-alist
      '(("django"    . "\\.html\\'")))
(setq web-mode-markup-indent-offset 2)
(setq web-mode-code-indent-offset 2)

;;-------;;
;; TODOs ;;
;;-------;;
;; Git
;; Octave
;; Ruby
;; HTML
;; CSS
;; Json
;; Latex
