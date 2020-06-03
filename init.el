;;;;;;;;;;;;;;;;;;;;;;;;
;; EMACS CONFIGURATION ;
;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; USER INFORMATION
;;

(setq user-full-name "Matt Westerburg"
      user-mail-address "matt@headerodoxy.com")

;;
;; PERFORMANCE TWEAKS
;;

(setq gc-cons-threshold 50000000)
(setq large-file-warning-threshold 100000000)

;;
;; USE-PACKAGE SETUP
;;

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))

;;
;; UI CONFIGURATION
;;
(menu-bar-mode -1)
(if (display-graphic-p)
    (progn
      (toggle-scroll-bar -1)
      (tool-bar-mode -1)))
(global-hl-line-mode +1)
(blink-cursor-mode -1)
(line-number-mode +1)
(global-display-line-numbers-mode 1)
(column-number-mode t)
(size-indication-mode t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-screen t)
(set-default 'truncate-lines t)
(display-time-mode t)
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(global-auto-revert-mode 1)
(setq echo-keystrokes 0.1)
(auto-compression-mode t)
(transient-mark-mode 1)
(make-variable-buffer-local 'transient-mark-mode)
(put 'transient-mark-mode 'permanent-local t)
(setq-default transient-mark-mode t)
(setq enable-recursive-minibuffers t)
(setq visible-bell t)

;; theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'cherry-blossom t)

;; font
(set-face-attribute 'default nil
		    :family "Iosevka Light"
		    :height 130
		    :weight 'normal
		    :width 'normal)

;;
;; EDITOR CONFIGURATION
;;

(setq backup-directory-alist '(("." . "~/.emacs.d/.backups")))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Dired
(defvar global-auto-revert-non-file-buffers)
(setq global-auto-revert-non-file-buffers t)

(defvar auto-revert-verbose)
(setq auto-revert-verbose nil)

;;
;; PACKAGES
;;

(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package which-key
  :ensure t
  :config
  (which-key-setup-side-window-bottom)
  (which-key-mode))

(use-package magit
  :ensure t)

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package avy
  :ensure t)

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package nyan-mode
  :config
  (nyan-mode 1))

;; (use-package vterm
;;   :ensure t)

(use-package general
  :ensure t
  :config
  (general-define-key
   "M-d" 'dired
   "M-s" 'magit-status
   "M-C" 'uncomment-region
   "M-c" 'comment-region
   "M-b" 'counsel-compile
   "M-x" 'smex)
  (defconst leader-key "C-c")
  (general-create-definer leader-def :prefix leader-key)
  (leader-def
    "g" 'goto-line
    "f" 'counsel-projectile-find-file
    "i" 'ivy-resume
    "p" 'counsel-projectile-switch-project
    "r" 'counsel-projectile-rg
    "a" 'counsel-projectile-ag
    "b" 'counsel-projectile-switch-to-buffer
    "n" 'neotree-toggle
    "s" 'swiper))

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
  (setq ivy-height 30)
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

(use-package counsel-projectile
  :ensure t)

(use-package swiper
  :ensure t)

;; (use-package evil
;;   :ensure t
;;   :defer t
;;   :config
;;   (progn
;; 	(setq evil-overriding-maps nil)
;; 	(setq evil-intercept-maps nil)
;; 	(setq evil-auto-indent nil)
;; 	(setq evil-regexp-search t)
;; 	(defun toggle-evilmode ()
;; 	  (interactive)
;; 	  (if (bound-and-true-p evil-local-mode)
;; 	      (progn
;; 					; go emacs
;; 		(evil-local-mode (or -1 1))
;; 		(undo-tree-mode (or -1 1))
;; 		(SET-VARIABLE 'CURSOR-TYPE 'BAR)
;; 		)
;; 	    (progn
;; 					; go evil
;; 	      (evil-local-mode (or 1 1))
;; 	      (set-variable 'cursor-type 'box)
;; 	      )
;; 	    )
;; 	  )
 
;; 	(global-set-key (kbd "C-c u") 'toggle-evilmode)
;; 	(evil-mode 0)))

(use-package god-mode
  :ensure t
  :disabled t
  :defer t
  :init
  (god-mode-all)
  (setq
   god-exempt-major-modes '(dired-mode grep-mode vc-annotate-mode eshoell-mode shell-mode neotree-mode)
   god-exempt-predicates (list #'god-exempt-mode-p))
  :config
  (progn
	(global-set-key (kbd "<escape>") 'god-local-mode)
	))

(use-package dashboard
  :ensure t
  :config
  (setq dashboard-banner-logo-title "Westy's Emacs")
  (setq dashboard-startup-banner 'logo)
  ;(setq dashboard-center-content t)
  (setq dashboard-items '((recents . 5)
			  (projects . 5)))
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-set-navigator t)
  (setq dashboard-set-init-info t)
  (dashboard-setup-startup-hook))

(use-package neotree
  :ensure t
  :defer t
  :config
  (progn
    (setq projectile-switch-project-action 'neotree-projectile-action)))

(use-package doom-modeline
  :ensure t
  :config
  ;; How tall the mode-line should be. It's only respected in GUI.
  ;; If the actual char height is larger, it respects the actual height.
  (setq doom-modeline-height 25)

  ;; How wide the mode-line bar should be. It's only respected in GUI.
  (setq doom-modeline-bar-width 3)

  ;; The limit of the window width.
  ;; If `window-width' is smaller than the limit, some information won't be displayed.
  (setq doom-modeline-window-width-limit fill-column)

  ;; How to detect the project root.
  ;; The default priority of detection is `ffip' > `projectile' > `project'.
  ;; nil means to use `default-directory'.
  ;; The project management packages have some issues on detecting project root.
  ;; e.g. `projectile' doesn't handle symlink folders well, while `project' is unable
  ;; to hanle sub-projects.
  ;; You can specify one if you encounter the issue.
  (setq doom-modeline-project-detection 'project)

  ;; Determines the style used by `doom-modeline-buffer-file-name'.
  ;;
  ;; Given ~/Projects/FOSS/emacs/lisp/comint.el
  ;;   auto => emacs/lisp/comint.el (in a project) or comint.el
  ;;   truncate-upto-project => ~/P/F/emacs/lisp/comint.el
  ;;   truncate-from-project => ~/Projects/FOSS/emacs/l/comint.el
  ;;   truncate-with-project => emacs/l/comint.el
  ;;   truncate-except-project => ~/P/F/emacs/l/comint.el
  ;;   truncate-upto-root => ~/P/F/e/lisp/comint.el
  ;;   truncate-all => ~/P/F/e/l/comint.el
  ;;   truncate-nil => ~/Projects/FOSS/emacs/lisp/comint.el
  ;;   relative-from-project => emacs/lisp/comint.el
  ;;   relative-to-project => lisp/comint.el
  ;;   file-name => comint.el
  ;;   buffer-name => comint.el<2> (uniquify buffer name)
  ;;
  ;; If you are experiencing the laggy issue, especially while editing remote files
  ;; with tramp, please try `file-name' style.
  ;; Please refer to https://github.com/bbatsov/projectile/issues/657.
  (setq doom-modeline-buffer-file-name-style 'auto)

  ;; Whether display icons in the mode-line. Respects `all-the-icons-color-icons'.
  ;; While using the server mode in GUI, should set the value explicitly.
  (setq doom-modeline-icon (display-graphic-p))

  ;; Whether display the icon for `major-mode'. Respects `doom-modeline-icon'.
  (setq doom-modeline-major-mode-icon t)

  ;; Whether display the colorful icon for `major-mode'.
  ;; Respects `doom-modeline-major-mode-icon'.
  (setq doom-modeline-major-mode-color-icon t)

  ;; Whether display the icon for the buffer state. It respects `doom-modeline-icon'.
  (setq doom-modeline-buffer-state-icon t)

  ;; Whether display the modification icon for the buffer.
  ;; Respects `doom-modeline-icon' and `doom-modeline-buffer-state-icon'.
  (setq doom-modeline-buffer-modification-icon t)

  ;; Whether to use unicode as a fallback (instead of ASCII) when not using icons.
  (setq doom-modeline-unicode-fallback nil)

  ;; Whether display the minor modes in the mode-line.
  (setq doom-modeline-minor-modes t)

  ;; If non-nil, a word count will be added to the selection-info modeline segment.
  (setq doom-modeline-enable-word-count nil)

  ;; Major modes in which to display word count continuously.
  ;; Also applies to any derived modes. Respects `doom-modeline-enable-word-count'.
  ;; If it brings the sluggish issue, disable `doom-modeline-enable-word-count' or
  ;; remove the modes from `doom-modeline-continuous-word-count-modes'.
  (setq doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode))

  ;; Whether display the buffer encoding.
  (setq doom-modeline-buffer-encoding t)

  ;; Whether display the indentation information.
  (setq doom-modeline-indent-info nil)

  ;; If non-nil, only display one number for checker information if applicable.
  (setq doom-modeline-checker-simple-format t)

  ;; The maximum number displayed for notifications.
  (setq doom-modeline-number-limit 99)

  ;; The maximum displayed length of the branch name of version control.
  (setq doom-modeline-vcs-max-length 12)

  ;; Whether display the perspective name. Non-nil to display in the mode-line.
  (setq doom-modeline-persp-name t)

  ;; If non nil the default perspective name is displayed in the mode-line.
  (setq doom-modeline-display-default-persp-name nil)

  ;; If non nil the perspective name is displayed alongside a folder icon.
  (setq doom-modeline-persp-icon t)

  ;; Whether display the `lsp' state. Non-nil to display in the mode-line.
  (setq doom-modeline-lsp t)

  ;; Whether display the GitHub notifications. It requires `ghub' package.
  (setq doom-modeline-github nil)

  ;; The interval of checking GitHub.
  (setq doom-modeline-github-interval (* 30 60))

  ;; Whether display the modal state icon.
  ;; Including `evil', `overwrite', `god', `ryo' and `xah-fly-keys', etc.
  (setq doom-modeline-modal-icon t)

  ;; Whether display the mu4e notifications. It requires `mu4e-alert' package.
  (setq doom-modeline-mu4e nil)

  ;; Whether display the gnus notifications.
  (setq doom-modeline-gnus t)

  ;; Wheter gnus should automatically be updated and how often (set to 0 or smaller than 0 to disable)
  (setq doom-modeline-gnus-timer 2)

  ;; Wheter groups should be excludede when gnus automatically being updated.
  (setq doom-modeline-gnus-excluded-groups '("dummy.group"))

  ;; Whether display the IRC notifications. It requires `circe' or `erc' package.
  (setq doom-modeline-irc t)

  ;; Function to stylize the irc buffer names.
  (setq doom-modeline-irc-stylize 'identity)

  ;; Whether display the environment version.
  (setq doom-modeline-env-version t)
  ;; Or for individual languages
  (setq doom-modeline-env-enable-python t)
  (setq doom-modeline-env-enable-ruby t)
  (setq doom-modeline-env-enable-perl t)
  (setq doom-modeline-env-enable-go t)
  (setq doom-modeline-env-enable-elixir t)
  (setq doom-modeline-env-enable-rust t)

  ;; Change the executables to use for the language version string
  (setq doom-modeline-env-python-executable "python") ; or `python-shell-interpreter'
  (setq doom-modeline-env-ruby-executable "ruby")
  (setq doom-modeline-env-perl-executable "perl")
  (setq doom-modeline-env-go-executable "go")
  (setq doom-modeline-env-elixir-executable "iex")
  (setq doom-modeline-env-rust-executable "rustc")

  ;; What to dispaly as the version while a new one is being loaded
  (setq doom-modeline-env-load-string "...")

  ;; Hooks that run before/after the modeline version string is updated
  (setq doom-modeline-before-update-env-hook nil)
  (setq doom-modeline-after-update-env-hook nil)
  :init
  (doom-modeline-mode 1))

(use-package expand-region
   :ensure t
   :defer t
   :bind ("C-=" . er/expand-region))

(use-package projectile
  :ensure t
  :config
  (setq projectile-require-project-root nil)
  (setq projectile-globally-ignored-directories
	(cl-union projectile-globally-ignored-directories
		  '(".git" "node_modules" "target")))
  (define-key projectile-command-map (kbd "C-x p") 'projectile-command-map)
  (setq projectile-project-search-path '("~/Projects/"))
  (setq projectile-completion-system 'ivy)
  (projectile-mode))

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

(use-package racer
  :ensure t)

(use-package cargo
  :ensure t)

(use-package rustic
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
    (json-mode lsp-mode rustic which-key use-package tide smex rjsx-mode rainbow-delimiters racer powerline neotree magit lsp-ui general flycheck-rust expand-region exec-path-from-shell evil editorconfig dashboard counsel-projectile company-lsp cargo avy))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package json-mode
  :ensure t)

(use-package lsp-mode :commands lsp :ensure t)
(use-package lsp-ui :commands lsp-ui-mode :ensure t)
(use-package company-lsp
  :ensure t
  :commands company-lsp
  :config (push 'company-lsp company-backends))

(defun setup-tide-mode ()
"Setup function for tide."
(interactive)
(tide-setup)
(flycheck-mode +1)
(setq flycheck-check-syntax-automatically '(save mode-enabled))
(eldoc-mode +1)
(tide-hl-identifier-mode +1)
(company-mode +1))

(use-package tide
 :ensure t
 :config
 (defvar company-tooltip-align-annotations)
 (setq company-tooltip-align-annotations t)
 (add-hook 'js-mode-hook #'setup-tide-mode))

(use-package rjsx-mode
 :ensure t
 :config
 (setq indent-tabs-mode nil)
 (setq js-indent-level 2)
 (setq js2-strict-missing-semi-warning nil))

;;
;; KEYMAP CONFIGURATION
;;

;;
;; LOAD LOCAL CONFIGURATION
;;
(if (file-exists-p "~/.emacs.d/local.el")
    (load-file "~/.emacs.d/local.el"))
