;;
;; PACKAGE MANAGEMENT
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
                            
;;
;; GENERAL SETTINGS
;;

;; Set font (I like Fira Code, feel free to change)
(set-frame-font "Fira Code-16")

;; Use recentf
(recentf-mode 1)
(setq recentf-max-menu-items 10)

;; Set default directory (update it to your wanted directory)
(setq default-directory "~")

;; Turn off splash screen and startup screen
(setq inhibit-splash-screen t
      inhibit-startup-message t)

;; No scratch file text
(setq initial-scratch-message "")

;; Show line numbers
(global-display-line-numbers-mode)

;; y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; Show column number in mode line
(column-number-mode t)

;; Replace selection on insert
(delete-selection-mode 1)

;; Follow Symlinks
(setq vc-follow-symlinks t)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; I prefer tab with of 2, you can update it to your preference
(setq-default tab-width 2)

;; show matching parenthesis to the one you are on
(show-paren-mode 1)

(cond ((eq system-type `darwin) ;; Real Full Screen for Mac OSX
       (set-frame-parameter nil `fullscreen `fullboth))
      ((or (eq system-type `windows-nt) (eq system-type `cygwin) ;; Real Full Screen for Windows
           (progn (add-to-list `initial-frame-alist '(fullscreen . maximized))
                  (add-to-list `default-frame-alist '(undecorated . t))
                  (menu-bar-mode -1)
                  (tool-bar-mode -1)
                  (scroll-bar-mode -1)
                  (horizontal-scroll-bar-mode -1)))))

;; Orgmode and Latex
(setq-default org-pretty-entities t ; Make latex symbols auto display
      org-src-fontify-natively t ; Highlight src code block in org mode
      org-src-tab-acts-natively t ; Tabs work properly on src blocks
      save-interprogram-paste-before-kill t ; Move last kill to sys clipboard on exit
      visible-bell t ; Visually indicate bell
      load-prefer-newer t ; Load newer source over compiled
      ediff-window-setup-function 'ediff-setup-windows-plain ; Cleaner diff
      org-export-with-section-numbers nil ; No section numbers on export
      org-export-with-toc nil) ; No toc on export

;; Pretty Symbols
(global-prettify-symbols-mode 1)

;; Have exec-path match PATH for Windows and Mac 
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;;
;; PACKAGES
;;

(use-package zoom
  :ensure t
  :config
  (custom-set-variables
   `(zoom-mode t)
   `(zoom-size `(0.80 . 0.80))))

(use-package ace-window
  :ensure t
  :config
  (global-set-key (kbd "M-o") 'ace-window)
  (global-set-key (kbd "C-x o") 'ace-window))

(use-package treemacs
  :ensure t
  :defer t
  :config
  (progn
    (setq treemacs-silent-refresh t
          treemacs-silent-filewatch t
          treemacs-is-never-other-window t
          treemacs-change-root-without-asking t)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)

    (pcase (cons (not (null (executable-find "git")))
                 (not (null (executable-find "python3"))))
      (`(t . t)
       (treemacs-git-mode 'extended))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("C-c f" . treemacs-select-window)
        ("C-x t t" . treemacs)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

;; Better unique buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; Remember file placements
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (concat user-emacs-directory "places"))

;; Themes
;; (use-package clues-theme
;;  :config
;;  (load-theme 'clues t))

(use-package afternoon-theme
  :config
  (load-theme `afternoon t))

;; Latex Previews
(use-package latex-preview-pane
  :config
  (latex-preview-pane-enable))

;; SX Searching
(use-package sx
  :bind
  ("C-c C-s" . sx-search))

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

;; Evil (vim)
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
;; Languages, Auto Complete and Linting
;;

;; YAML
(use-package yaml-mode
  :ensure t
  :config
  (add-to-list `auto-mode-alist '("\\.yml\\'" . yaml-mode)))

;; Kotlin
(use-package kotlin-mode
  :ensure t)

;; Auto Complete via Company Start
(use-package company
  :ensure t
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0)
  (setq company-tooltip-align-annotations t)
  (global-company-mode 1))

(use-package company-box
  :ensure t
  :hook (company-mode . company-box-mode)
  :config (add-to-list 'company-box-frame-parameters '(font . "Fira Code-16")))

(use-package company-quickhelp
  :ensure t
  :config (company-quickhelp-mode))

;; Company End

;; Flycheck linting
(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

;; LSP Start
(use-package lsp-mode
  :ensure t
  :after (treemacs)
  :init (setq lsp-keymap-prefix "C-c l")
  :hook
  ((python-mode . lsp)
   (typescript-mode . lsp)
   (javascript-mode . lsp)
   (kotlin-mode . lsp)
   (java-mode . lsp)
   (js2-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ivy
  :ensure t
  :commands
  (lsp-ivy-workspace-symbol))

(use-package lsp-ui
  :ensure t
  :commands (lsp-ui-mode))

(use-package lsp-treemacs
  :ensure t
  :after (lsp-mode treemacs)
  :config
  (lsp-treemacs-sync-mode 1))
;; LSP End

;; Web Mode for TSX and JSX
(use-package web-mode
  :ensure t
  :mode (("\\.jsx\\'" . web-mode) 
         ("\\.tsx\\'" . web-mode) 
         ("\\.vue\\'" . web-mode)
	       ("\\.json\\'" . web-mode))
  :commands web-mode)

;;
;; SHORTCUTS
;;

(global-set-key (kbd "C-c C-l") '(lambda () (interactive)(load-file user-init-file)))
(global-set-key (kbd "C-c e") '(lambda () (interactive)(find-file user-init-file)))
(global-set-key "\C-c\ r" 'counsel-recentf)
 
;;
;; BACKUPS
;;

;; Stop weird things with backing up and linking
(setq backup-by-copying t)

;; Where to backup to
(setq backup-directory-alist '((".*" . "~/.bak.emacs/backup/")))

;; Creates directory if it doesn't already exist
(if (eq nil (file-exists-p "~/.bak.emacs/"))
    (make-directory "~/.bak.emacs/"))

;; Creates auto directory if it doesn't already exist
(if (eq nil (file-exists-p "~/.bak.emacs/auto"))
    (make-directory "~/.bak.emacs/auto"))

;; backup in one place. flat, no tree structure
(setq auto-save-file-name-transforms '((".*" "~/.bak.emacs/auto/" t)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(fira-code-mode zoom company-tabnine company-lsp lsp-treemacs lsp-ui lsp-ivy javascript-eslint typescript-eslint lsp-mode tide tide-mode web-mode rjsx-mode typescript-mode kotlin-mode disable-mouse afternoon-theme company-quickhelp-terminal treemacs-magit treemacs-icons-dired treemacs-projectile treemacs-evil treemacs which-key use-package sx smex org-bullets omnisharp neotree latex-preview-pane jdee indium go-mode exec-path-from-shell evil elpy counsel clues-theme cask ansible all-the-icons))
 '(zoom-mode t nil (zoom))
 '(zoom-size `(0.8 . 0.8)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
