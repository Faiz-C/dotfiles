;;
;; P A C K A G E   M A N A G E M E N T
;
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
(global-set-key (kbd "C-c e") '(lambda () (interactive)(find-file user-init-file)))
(global-set-key (kbd "C-c C-t") '(lambda () (interactive)
                             (split-window-vertically)
                             (other-window 1)
                             (ansi-term "/bin/zsh")))
                             
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-c\ r" 'counsel-recentf)

;;
;; G E N E R A L   S E T T I N G S
;;

(display-battery-mode)

(setq explicit-shell-file-name "/bin/zsh")

(setq inhibit-splash-screen t
      inhibit-startup-message t)
(setq initial-scratch-message "") ; No scratch text
(fset 'yes-or-no-p 'y-or-n-p) ; y/n instead of yes/no
(column-number-mode t) ; show column number in mode line
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
(setq-default indent-tabs-mode nil) ; Use spaces instead of tabs
(setq default-tab-width 2)
(setq-default c-basic-offset 2)
(show-paren-mode 1) ; Show matching parens
;(custom-set-variables '(initial-frame-alist (quote ((fullscreen . maximized))))) ; Start in maximum windows mode
(add-hook 'window-setup-hook 'toggle-frame-fullscreen t)
(custom-set-variables '(default-frame-alist '((undercorated . t))))
(custom-set-variables
 '(python-guess-indent nil)
 '(python-indent 2))


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

;;
;; My Enjoyed Themes
;;

(set-frame-font "Hermit 14")

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


;; AUTO COMPLETE
(use-package company
  :config
  (global-company-mode t))

(use-package flycheck
  :config
  (global-flycheck-mode t))

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

;; MULTIPLE CURSORS
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
;; C SHARP BOI
;;

(eval-after-load
 'company
 '(add-to-list 'company-backends 'company-omnisharp))

(add-hook 'csharp-mode-hook #'company-mode)

(use-package omnisharp
  :config
  (add-hook 'csharp-mode-hook 'omnisharp-mode))

;;
;; Java BOI
;;

;(use-package company-emacs-eclim
;  :config
;  (company-emacs-eclim-setup))

;(use-package eclim
;  :config
;  (add-hook 'java-mode-hook 'eclim-mode))

(add-hook 'java-mode-hook (lambda () (setq c-default-style "bsd"))) 

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
