;;-------------------------- PACKAGE INITIALISE ------------------------
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package (NON-LINUX)
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)

;;-------------------------- SETTINGS --------------------------------
;;inhibit landing page
(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)          ; Disable the menu bar

(global-hl-line-mode +1)    ; highlight line

(show-paren-mode 1) ;show matching paren

;; Set up the visible bell for backspace
(setq visible-bell t)


(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
		treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


;;---------------------------- THEMES ---------------------------------
;;all the fonts
;;need to run all-the-icons-install-fonts
(use-package all-the-icons
  :ensure t)

;;doom theme 
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-dracula t))

;;doom modeline
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))


;;------------------------- DASHBOARD ---------------------------------
(use-package dashboard
  :ensure t
  :init
  (progn
    (setq dashboard-items '((recents  . 5)
                            (bookmarks . 5)
                            (projects . 5)))
    (setq dashboard-banner-logo-title "Welcome Connor. Remember to smile more :)")
    (setq dashboard-footer-messages '("PLEASE NOTE: Try your hardest, but remember to have fun. Nothing matters, so no stress :)"))
    (setq dashboard-set-file-icons t)
    (setq dashboard-set-heading-icons t)
    (setq dashboard-startup-banner 'logo))
  :config
  (dashboard-setup-startup-hook))

;;-------------------------- PACKAGES ----------------------------------

;;search history
(use-package smex
  :ensure t)

;;search
(use-package swiper
  :ensure t)

;;enables use of counsel (which is used by ivy)
(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

;;similar to HELM (used for completion, searching etc)
(use-package ivy
  :ensure t
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;;which key bindings are available and what they map to
(use-package which-key
  :ensure t
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

;;gives extra info for desribing functions e.g. with M-
(use-package ivy-rich
  :ensure t
  :init
  (ivy-rich-mode 1))

;;better help functions
(use-package helpful
  :ensure t
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;;managing projects
(use-package projectile
  :ensure t
  :diminish projectile-mode
  :config
  (projectile-mode)
  :custom (projectile-completion-system 'ivy)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Can set this to where you keep your git repos
  (when (file-directory-p "~/personal")
    (setq projectile-project-search-path '("~/personal/projects")))
  (when (file-directory-p "~/work")
   (setq projectile-project-search-path '("~/work/projects")))
   (setq projectile-switch-project-action #'projectile-dired))

;;now when you use M-o when switching project etc.
;;counsel-projectile-rg
(use-package counsel-projectile
  :ensure t
  :config (counsel-projectile-mode))

;;managing git
(use-package magit
  :ensure t
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;;smart parens
(use-package smartparens
  :ensure t
  :delight
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t)
  :init
  (smartparens-global-mode t)
  :bind
  ("C-<right>" . sp-forward-slurp-sexp)
  ("C-<left>" . sp-forward-barf-sexp))


;;expand region - for expanding highlighted text
(use-package expand-region
  :ensure t
  :bind
  ("C-." . er/expand-region)
  ("C-," . er/contract-region))

;;general - for custom keybindings
(use-package general
  :ensure t
  :config
  (general-auto-unbind-keys t)
    (general-define-key
     :prefix "C-;"
     :non-normal-prefix "C-;"
     "" '(:ignore t :which-key "description for SPC")
     ;; Javascript:
     "j" '(:ignore t :which-key "JavaScript")
     "j d" '(lsp-find-definition :which-key "Definition")
     "j r" '(lsp-find-references :which-key "References")
     "j a" '(lsp-execute-code-action :which-key "Action")

     ;;projectile:
     "p" '(:ignore t :which-key "Projectile")
     "p r" '(projectile-run-project :which-key "Run")
     "p t" '(projectile-test-project :which-key "Test")
     "p f" '(projectile-find-file :which-key "Find File")
     "p s" '(projectile-grep :which-key "Search")
     "p p" '(projectile-switch-project :which-key "Project switch")

     "t" '(:ignore t :which-key "Treemacs")
     "t t" '(treemacs-select-window :which-key "Open Treemacs")
     "t d" '(treemacs-create-dir :which-key "Create Dir")
     "t f" '(treemacs-create-file :which-key "Create File")
     "t r" '(treemacs-rename :which-key "Rename")
     "t k" '(treemacs-delete :which-key "Delete")
     "t m" '(treemacs-move-file :which-key "Move")))

;;drag-stuff - for moving lines/selected regions
(use-package drag-stuff
  :ensure t
  :config
  (drag-stuff-mode t)
  (drag-stuff-global-mode 1)
  :bind
  ("M-n" . drag-stuff-down)
  ("M-p" . drag-stuff-up))

;;auto completing
(use-package company
  :ensure t
  :config (global-company-mode t)
  :init (global-company-mode t)
  :bind
  (:map company-active-map
        ("<tab>" . company-complete-selection))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0)) 



(use-package company-box
  :ensure t
  :hook (company-mode . company-box-mode))



;;------------------------------- LANGUAGES ----------------------------
(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :ensure t
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package treemacs
  :ensure t
  :bind
  (:map global-map
	([f8] . treemacs)
	("C-<f8>" . treemacs-select-window))
  :config
  (setq treemacs-is-never-other-window t))

(use-package lsp-treemacs
  :ensure t
  :after lsp)

(use-package lsp-ivy
  :ensure t)

;;(use-package typescript-mode
;;  :mode "\\.tsx?\\'"
;;  :hook (typescript-mode . lsp-deferred)
;;  :config
;;  (setq typescript-indent-level 2))

(use-package web-mode
  :ensure t
  :mode (("\\.js\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         ("\\.ts\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.html\\'" . web-mode)
         ("\\.vue\\'" . web-mode)
	 ("\\.json\\'" . web-mode)
	 ("\\.css\\'" . web-mode))
  :hook (web-mode . lsp-deferred)
  :commands web-mode
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  :config
  (setq web-mode-content-types-alist
	'(("jsx" . "\\.js[x]?\\'")))
  (setq create-lockfiles nil))


(use-package prettier-js
  :ensure t
    :config
    (setq prettier-js-args '(
                          "--trailing-comma" "es5"
                          "--single-quote" "false"
                          "--print-width" "100"
                          ))
    (add-hook 'web-mode-hook 'prettier-js-mode))



 ;;clojure mode
(use-package clojure-mode
  :ensure t
  :mode (("\\.clj\\'" . clojure-mode)
	 ("\\.cljs\\'" . clojure-mode)
         ("\\.edn\\'" . clojure-mode)))

;;add clojure refactoring 
(use-package clj-refactor
  :ensure t
  :diminish clj-refactor-mode
  :config (cljr-add-keybindings-with-prefix "C-c C-l"))


(use-package cider
  :ensure t
  :init (add-hook 'cider-mode-hook #'clj-refactor-mode)
  :diminish subword-mode
  :config
  (setq nrepl-log-messages t                  
        cider-repl-display-in-current-window t
        cider-repl-use-clojure-font-lock t    
        cider-prompt-save-file-on-load 'always-save
        cider-font-lock-dynamically '(macro core function var)
        nrepl-hide-special-buffers t            
        cider-overlays-use-font-lock t)         
  (cider-repl-toggle-pretty-printing))

;;------------------------------- extras ---------------------------------------------
(setq backup-directory-alist
          `((".*" . ,temporary-file-directory)))
    (setq auto-save-file-name-transforms
          `((".*" ,temporary-file-directory t)))


;;------------------------------- CUSTOM THINGS ---------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(prettier-js clj-refactor clojure-mode web-mode lsp-ivy lsp-treemacs treemacs lsp-ui lsp-mode company-box company drag-stuff general expand-region smartparens magit counsel-projectile projectile helpful ivy-rich which-key counsel swiper smex dashboard rainbow-delimiters doom-modeline doom-themes all-the-icons use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
