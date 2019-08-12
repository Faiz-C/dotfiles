;;
;; P A C K A G E   M A N A G E M E N T
;;

(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(setq package-enable-at-startup nil)
(package-initialize)

;; Have use-package auto download
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; SHORTCUTS
(global-set-key (kbd "C-c C-l") '(lambda () (interactive)(load-file user-init-file)))
(global-set-key (kbd "M-p e") 'neotree-toggle)
(global-set-key (kbd "C-c e") '(lambda () (interactive)(find-file user-init-file)))
(global-set-key (kbd "C-c C-t") '(lambda () (interactive)
                             (split-window-vertically)
                             (other-window 1)
                             (ansi-term "/bin/bash")))
                             
;;
;; G E N E R A L   S E T T I N G S
;;

(display-battery-mode)

(setq inhibit-splash-screen t
      inhibit-startup-message t)
(setq initial-scratch-message "") ; No scratch text
(fset 'yes-or-no-p 'y-or-n-p) ; y/n instead of yes/no
(column-number-mode t) ; show column number in mode line
(global-linum-mode t) ; show line number
(delete-selection-mode 1) ; Replace selection on insert
(setq vc-follow-symlinks t) ; Always follow symlinks
(setq custom-file "~/.emacs.d/custom.el") ; Set custom file
(load custom-file 'noerror) ; Load custom file
(setq org-pretty-entities t ; Make latex symbols auto display
      org-src-fontify-natively t ; Highlight src code block in org mode
      org-src-tab-acts-natively t ; Tabs work properly on src blocks
      save-interprogram-paste-before-kill t ; Move last kill to sys clipboard on exit
      visible-bell t ; Visually indicate bell
      load-prefer-newer t ; Load newer source over compiled
      ediff-window-setup-function 'ediff-setup-windows-plain) ; Cleaner diff
(show-paren-mode 1) ; Show matching parens
(add-hook 'window-setup-hook 'toggle-frame-fullscreen t)
(custom-set-variables '(default-frame-alist '((undercorated . t)))
											'(neo-window-position (quote right)))

;; Indentation
(defun setup-indentation(level)
  (setq-default indent-tabs-mode t) ; Use spaces instead of tabs
  (setq-default tab-width level)
  (setq-default python-indent-offset level)
  (setq-default c-basic-offset level) ; covers C, C++, Java
  (setq-default javascript-indent-level level)
  (setq-default js-indent-level level)
  (setq-default coffee-tab-width level)
  (setq-default web-mode-markup-indent-offset level)
  (setq-default web-mode-css-indent-offset level)
  (setq-default web-mode-code-indent-offset level)
  (setq-default css-indent-offset level)
  )
(setup-indentation 2)

;; Don't show any of the graphical bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(horizontal-scroll-bar-mode -1)

(require 'uniquify) ; Better unique buffer names
(setq uniquify-buffer-name-style 'forward)

(require 'saveplace) ; Remember file placement
(setq-default save-place t)
(setq save-place-file (concat user-emacs-directory "places"))
(setq org-export-with-section-numbers nil)
(setq org-export-with-toc nil)

;;
;; P A C K A G E S
;;

;; My Enjoyed Themes
;(use-package soothe-theme
;  :config
;  (load-theme 'soothe t))

(use-package clues-theme
  :config
  (load-theme 'clues t))

;(use-package distinguished-theme
;  :config
;  (load-theme 'distinguished t))

;(use-package color-theme-sanityinc-tommorrow
;  :config
;  (load-theme 'color-theme-sanityinc-tommorrow t))

;; Auto Complete
(use-package company
  :config
  (global-company-mode t))

;; Error Checking
(use-package flycheck
  :config
  (global-flycheck-mode t))

;; Project Management, Tree Structure
(use-package neotree)
(use-package all-the-icons)
(setq all-the-icons-color-icons t)
(setq all-the-icons-for-buffer t)
(setq neo-smart-open t)
(setq projectile-switch-project-action 'neotree-projectile-action)
(add-hook 'neotree-mode-hook
  (lambda()
		(define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
		(define-key evil-normal-state-local-map (kbd "SPC") 'neotree-quick-look)
		(define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
		(define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)
		(define-key evil-normal-state-local-map (kbd "g") 'neotree-refresh)
		(define-key evil-normal-state-local-map (kbd "n") 'neotree-next-line)
		(define-key evil-normal-state-local-map (kbd "p") 'neotree-previous-line)
		(define-key evil-normal-state-local-map (kbd "A") 'neotree-stretch-toggle)
		(define-key evil-normal-state-local-map (kbd "H") 'neotree-hidden-file-toggle)))
(add-hook 'neo-after-create-hook (lambda (&optional dummy) (global-linum-mode -1)))


;; Java Setup
(use-package eclim)
(use-package eclimd)
(add-hook 'java-mode-hook 'eclim-mode)
(use-package company-emacs-eclim
	:config
	(company-emacs-eclim-setup))
(define-key eclim-mode-map (kbd "C-c C-c") 'eclim-problems-correct)
(define-key eclim-mode-map (kbd "C-c C-r") 'eclim-java-refactor-rename-symbol-at-point)

(use-package omnisharp
  :after company
  :config
  (add-hook 'csharp-mode-hook 'omnisharp-mode)
  (add-to-list 'company-backends 'company-omnisharp))

(use-package latex-preview-pane
  :config
  (latex-preview-pane-enable))

(use-package sx
  :bind
  ("C-c C-s" . sx-search))

;; Multiple Curs
(use-package multiple-cursors
  :bind
  (("C-M-c" . mc/edit-lines)))

;; Better completion at point
(use-package ivy
  :bind ("C-x k" . kill-buffer)
  (:map ivy-minibuffer-map
        ("RET" . ivy-alt-done)
        ("<tab>" . ivy-next-line)
        ("<backtab>" . ivy-previous-line))
  :init
  (use-package smex)
  (use-package counsel)
  :config
  (ivy-mode 1)
  (counsel-mode 1))

;; Better looking org headers
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; Keypress suggestions
(use-package which-key
  :config
  (which-key-mode))

;;
;; E V I L   M O D E
;;
(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump t)
  :config
  (evil-mode t)
  (setq evil-split-window-below t)
  (setq evil-vsplit-window-right t)
  (setq-default evil-symbol-word-search t))

;;
;; B A C K U P S
;;
(setq backup-by-copying t) ; Stop shinanigans with links
(setq backup-directory-alist '((".*" . "~/.bak.emacs/backup/")))
;; Creates directory if it doesn't already exist
(if (eq nil (file-exists-p "~/.bak.emacs/")) 
    (make-directory "~/.bak.emacs/"))
;; Creates auto directory if it doesn't already exist
(if (eq nil (file-exists-p "~/.bak.emacs/auto"))
    (make-directory "~/.bak.emacs/auto"))
;; backup in one place. flat, no tree structure
(setq auto-save-file-name-transforms '((".*" "~/.bak.emacs/auto/" t)))
