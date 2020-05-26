(setq user-full-name "Matt Westerburg"
      user-mail-address "matt@headerodoxy.com")

(setq gc-cons-threshold 50000000)
(setq large-file-warning-threshold 100000000)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))

(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(global-hl-line-mode +1)
(blink-cursor-mode -1)
(line-number-mode +1)
(global-display-line-numbers-mode 1)
(column-number-mode t)
(size-indication-mode t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-screen t)
(set-default 'truncate-lines t)

(use-package magit
  :ensure t)

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package ivy
  :ensure t
  :diminish (ivy-mode . "")
  :bind
  (:map ivy-mode-map
   ("C-'" . ivy-avy))
  :config
  (ivy-mode 1)
  ;; add ‘recentf-mode’ and bookmarks to ‘ivy-switch-buffer’.
  (setq ivy-use-virtual-buffers t)
  ;; number of result lines to display
  (setq ivy-height 10)
  ;; does not count candidates
  (setq ivy-count-format "")
  ;; no regexp by default
  (setq ivy-initial-inputs-alist nil)
  ;; configure regexp engine.
  (setq ivy-re-builders-alist
	;; allow input not in order
        '((t   . ivy--regex-ignore-order))))

(use-package counsel
  :ensure t)

(use-package swiper
  :ensure t)

(use-package evil
  :ensure t
  :defer t
  :config
  (progn
	(setq evil-overriding-maps nil)
	(setq evil-intercept-maps nil)
	(setq evil-auto-indent nil)
	(setq evil-regexp-search t)
	(evil-mode 0)))

(use-package god-mode
  :disabled t
  :ensure t
  :defer t
  :init
  (god-mode-all)
  (setq
   god-exempt-major-modes '(dired-mode grep-mode vc-annotate-mode eshell-mode shell-mode neotree-mode)
   god-exempt-predicates (list #'god-exempt-mode-p))
  :config
  (progn
	(global-set-key (kbd "<escape>") 'god-local-mode)
	))

;; (use-package neotree
;;   :ensure t
;;   :defer t
;;   :config
;;   (progn
;;     (setq projectile-switch-project-action 'neotree-projectile-action)))

(use-package powerline
  :ensure t
  :init
  (powerline-center-theme))
(add-hook 'after-init-hook 'powerline-reset)

(use-package expand-region
  :ensure t
  :defer t
  :bind ("C-=" . er/expand-region))

(use-package projectile
  :ensure t
  :config
  (define-key projectile-command-map (kbd "C-x p") 'projectile-command-map)
  (projectile-mode +1))

(use-package company
  :ensure t
  :config
  (global-company-mode))

(use-package ido
  :config
  (progn
	(setq ido-enable-flex-matching t)
	(setq ido-enable-prefix nil)
	(setq ido-everywhere t)
	(setq ido-create-new-buffer 'always)
	(setq ido-save-directory-list-file "~/.emacs.d/cache/ido/ido.last")
	(setq ido-enable-last-directory-history t)
	(setq ido-use-filename-at-point 'nil)
	(setq ido-case-fold t)
	(ido-mode 'both)
	(ido-everywhere t)))

(use-package recentf
  :ensure t
  :config
  (setq recentf-save-file (concat user-emacs-directory ".recentf"))
  (recentf-mode 1)
  (setq recentf-max-menu-items 40))

(use-package smex
  :ensure t
  :config
  (setq smex-save-file (concat user-emacs-directory ".smex-items"))
  (smex-initialize)
  (global-set-key (kbd "M-x") 'smex))

(use-package flycheck-rust
  :ensure t)

(use-package racer
  :ensure t)

(use-package cargo
  :ensure t)

(use-package rust-mode
	     :mode ("\\.rs\\'" . rust-mode)
	     :ensure t
	     :config
	     (require 'racer)
	     (require 'cargo)
	     (require 'flycheck-rust)
	     (add-hook 'rust-mode-hook #'racer-mode)
	     (add-hook 'racer-mode-hook #'eldoc-mode)
	     (add-hook 'racer-mode-hook #'company-mode)
	     (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
	     (add-hook 'rust-mode-hook
		       (lambda ()
			 (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)))
	     (add-hook 'rust-mode-hook 'cargo-minor-mode))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (company-lsp lsp-ui lsp-mode company rust-mode use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package lsp-mode :commands lsp :ensure t)
(use-package lsp-ui :commands lsp-ui-mode :ensure t)
(use-package company-lsp
  :ensure t
  :commands company-lsp
  :config (push 'company-lsp company-backends))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'cyberpunk-2019 t)
