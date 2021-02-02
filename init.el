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
(setq use-package-always-ensure t)

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

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

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
(use-package all-the-icons)

;;doom theme 
(use-package doom-themes
  :config
  (load-theme 'doom-dracula t))

;;doom modeline
(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

(use-package rainbow-delimiters
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
(use-package smex)

;;search
(use-package swiper)

;;enables use of counsel (which is used by ivy)
(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

;;similar to HELM (used for completion, searching etc)
(use-package ivy
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
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

;;gives extra info for desribing functions e.g. with M-
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;;better help functions
(use-package helpful
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
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Can set this to where you keep your git repos
  ;;(when (file-directory-p "~/Projects/Code")
   ;; (setq projectile-project-search-path '("~/Projects/Code")))
  ;;(setq projectile-switch-project-action #'projectile-dired))
  )

;;now when you use M-o when switching project etc.
;;counsel-projectile-rg
(use-package counsel-projectile
  :config (counsel-projectile-mode))

;;managing git
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;;smart parens
(use-package smartparens
  :config
  (smartparens-global-mode t)
  :bind
  (("C-M-f" . sp-forward-sexp)
   ("C-M-b" . sp-backward-sexp)
   ("C-M-d" . sp-down-sexp)
   ("C-M-a" . sp-backward-down-sexp)
   ("C-M-e" . sp-up-sexp)
   ("C-M-u" . sp-backward-up-sexp)
   ("C-M-t" . sp-transpose-sexp)
   ("C-M-n" . sp-next-sexp)
   ("C-M-p" . sp-previous-sexp)
   ("C-M-k" . sp-kill-sexp)
   ("C-M-w" . sp-copy-sexp)
   ("C-<right>" . sp-forward-slurp-sexp)
   ("C-<left>" . sp-forward-barf-sexp)
   ("C-]" . sp-select-next-thing-exchange)
   ("C-<left_bracket>" . sp-select-previous-thing)
   ("C-M-]" . sp-select-next-thing)
   ("M-F" . sp-forward-symbol)
   ("M-B" . sp-backward-symbol)))


;;expand region - for expanding highlighted text
(use-package expand-region
  :ensure t
  :bind
  ("C-." . er/expand-region)
  ("C-," . er/contract-region))

;;general - for custom keybindings
(use-package general
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

     "t" '(:ignore t :which-key "Treemacs")
     "t t" '(treemacs-select-window :which-key "Open Treemacs")
     "t d" '(treemacs-create-dir :which-key "Create Dir")
     "t f" '(treemacs-create-file :which-key "Create File")
     "t r" '(treemacs-rename :which-key "Rename")
     "t k" '(treemacs-delete :which-key "Delete")
     "t m" '(treemacs-move-file :which-key "Move")))

;;drag-stuff - for moving lines/selected regions
(use-package drag-stuff
  :config
  (drag-stuff-mode t)
  (drag-stuff-global-mode 1)
  :bind
  ("M-n" . drag-stuff-down)
  ("M-p" . drag-stuff-up))



;;------------------------------- LANGUAGES ----------------------------
(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package treemacs
  :bind
  (:map global-map
	([f8] . treemacs)
	("C-<f8>" . treemacs-select-window))
  :config
  (setq treemacs-is-never-other-window t))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy)

;;(use-package typescript-mode
;;  :mode "\\.tsx?\\'"
;;  :hook (typescript-mode . lsp-deferred)
;;  :config
;;  (setq typescript-indent-level 2))

;;auto completing
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package web-mode  :ensure t
  :mode (("\\.js\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         ("\\.ts\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.html\\'" . web-mode)
         ("\\.vue\\'" . web-mode)
	 ("\\.json\\'" . web-mode))
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
  :defer t
  :ensure t
  :diminish clj-refactor-mode
  :config (cljr-add-keybindings-with-prefix "C-c C-l"))


(use-package cider
  :ensure t
  :defer t
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
(setq make-backup-files nil)
;;------------------------------- CUSTOM THINGS ---------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("77113617a0642d74767295c4408e17da3bfd9aa80aaa2b4eeb34680f6172d71a" default))
 '(package-selected-packages
   '(drag-stuff prettier-js prettier-js-mode web-mode dashboard expand-region smartparens lsp-ivy lsp-treemacs lsp-ui company-box company smex visual-fill-column org-bullets magit counsel-projectile hydra evil general helpful counsel ivy-rich which-key rainbow-delimiters swiper use-package ivy doom-themes doom-modeline command-log-mode))
 '(safe-local-variable-values
   '((git-commit-prefix . "[RACOON-1]")
     (cljr-magic-requires)
     (css-indent-offset . 2)
     (cider-default-cljs-repl . cursive-compatible-figwheel-main)
     (cider-clojure-cli-parameters . "-A:dev:server:client:nrepl -m nrepl.cmdline --middleware '[\"cider.nrepl/cider-middleware\"]'")
     (eval cider-register-cljs-repl-type 'cursive-compatible-figwheel-main "(do (require 'cljs) (ns cljs) (start-figwheel!) (repl))")
     (git-commit-prefix . "[KOI-1]"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

