(use-package emacs
  :ensure nil
  :custom
  (column-number-mode t)
  (auto-save-default nil)
  (create-lockfiles nil)
  (display-line-numbers-type 'relative)
  (make-backup-files nil)
  (inhibit-startup-message t)
  (inhibit-scratch-message "")
  (tab-width 4)


  :hook
  (prog-mode . display-line-numbers-mode)

  :config
  ;; uncomment the next line if you want a custom var file
  ;; (setq custom-file (locate-user-emacs-file "custom-vars.el"))
  ;; (load custom-file 'noerror 'nomessage)

  :init
  (menu-bar-mode -1)
  (tool-bar-mode -1)

  (when scroll-bar-mode
    (scroll-bar-mode -1))

  (global-hl-line-mode 1)

  (setq org-todo-keywords
		'((sequence "TODO" "FEEDBACK" "CANCELED" "DONE" "|" "DELEGATED" "VERIFY")))

  (setq org-todo-keyword-faces
		'(("TODO" . org-warning)
		  ("DONE" . "green")
		  ("DELEGATED" . "yellow")
		  ("CANCELED" . (:foreground "blue"))
		  ("VERIFY" . "violet")))

  (setq org-directory "~/org")
  (setq org-agenda-files (list "~/org/work.org"
							   "~/org/life.org"))

  (require 'org)
  (define-key global-map "\C-ca" 'org-agenda)
  (define-key global-map "\C-cl" 'org-store-link)
  
  (modify-coding-system-alist 'file "" 'utf-8)

  (add-hook 'after-init-hook
	    (lambda ()
		  (message "Emacs Loaded")
	      (with-current-buffer (get-buffer-create "*scratch*")
		(insert (format
			 ";; Emacs Loaded man.
;; Loading Time: %s
"
			 (emacs-init-time)))))))

(use-package org
  :ensure nil
  :defer t)


(setq package-enable-at-startup nil) ;; Disables the default package manager.

;; Bootstraps `straight.el'
(setq straight-check-for-modifications nil)
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package '(project :type built-in))
(straight-use-package 'use-package)


;; Melpa Repo
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; load theme
;; I chose Catppuccin theme for now
(use-package catppuccin-theme
  :ensure t
  :straight t
  :config
  (custom-set-faces
   ;; Set the color for changes in the diff highlighting to blue.
   `(diff-hl-change ((t (:background unspecified :foreground ,(catppuccin-get-color 'blue))))))

  (custom-set-faces
   ;; Set the color for deletions in the diff highlighting to red.
   `(diff-hl-delete ((t (:background unspecified :foreground ,(catppuccin-get-color 'red))))))

  (custom-set-faces
   ;; Set the color for insertions in the diff highlighting to green.
   `(diff-hl-insert ((t (:background unspecified :foreground ,(catppuccin-get-color 'green))))))

  ;; Load the Catppuccin theme without prompting for confirmation.
  (load-theme 'catppuccin :no-confirm))


;; evil


;; Latex stuff
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)


;;; LSP
;; Emacs comes with an integrated LSP client called `eglot', which offers basic LSP functionality.
;; However, `eglot' has limitations, such as not supporting multiple language servers
;; simultaneously within the same buffer (e.g., handling both TypeScript, Tailwind and ESLint
;; LSPs together in a React project). For this reason, the more mature and capable
;; `lsp-mode' is included as a third-party package, providing advanced IDE-like features
;; and better support for multiple language servers and configurations.
;;
;; NOTE: To install or reinstall an LSP server, use `M-x install-server RET`.
;;       As with other editors, LSP configurations can become complex. You may need to
;;       install or reinstall the server for your project due to version management quirks
;;       (e.g., asdf or nvm) or other issues.
;;       Fortunately, `lsp-mode` has a great resource site:
;;       https://emacs-lsp.github.io/lsp-mode/
(use-package lsp-mode
  :ensure t
  :straight t
  :defer t
  :hook (;; Replace XXX-mode with concrete major mode (e.g. python-mode)
         (bash-ts-mode . lsp)                           ;; Enable LSP for Bash
         (typescript-ts-mode . lsp)                     ;; Enable LSP for TypeScript
         (tsx-ts-mode . lsp)                            ;; Enable LSP for TSX
         (js-mode . lsp)                                ;; Enable LSP for JavaScript
         (js-ts-mode . lsp)                             ;; Enable LSP for JavaScript (TS mode)
         (lsp-mode . lsp-enable-which-key-integration)) ;; Integrate with Which Key
  :commands lsp
  :custom
  (lsp-keymap-prefix "C-c l")                           ;; Set the prefix for LSP commands.
  (lsp-inlay-hint-enable t)                             ;; Enable inlay hints.
  (lsp-completion-provider :none)                       ;; Disable the default completion provider.
  (lsp-session-file (locate-user-emacs-file ".lsp-session")) ;; Specify session file location.
  (lsp-log-io nil)                                      ;; Disable IO logging for speed.
  (lsp-idle-delay 0)                                    ;; Set the delay for LSP to 0 (debouncing).
  (lsp-keep-workspace-alive nil)                        ;; Disable keeping the workspace alive.
  ;; Core settings
  (lsp-enable-xref t)                                   ;; Enable cross-references.
  (lsp-auto-configure t)                                ;; Automatically configure LSP.
  (lsp-enable-links nil)                                ;; Disable links.
  (lsp-eldoc-enable-hover t)                            ;; Enable ElDoc hover.
  (lsp-enable-file-watchers nil)                        ;; Disable file watchers.
  (lsp-enable-folding nil)                              ;; Disable folding.
  (lsp-enable-imenu t)                                  ;; Enable Imenu support.
  (lsp-enable-indentation nil)                          ;; Disable indentation.
  (lsp-enable-on-type-formatting nil)                   ;; Disable on-type formatting.
  (lsp-enable-suggest-server-download t)                ;; Enable server download suggestion.
  (lsp-enable-symbol-highlighting t)                    ;; Enable symbol highlighting.
  (lsp-enable-text-document-color nil)                  ;; Disable text document color.
  ;; Modeline settings
  (lsp-modeline-code-actions-enable nil)                ;; Keep modeline clean.
  (lsp-modeline-diagnostics-enable nil)                 ;; Use `flymake' instead.
  (lsp-modeline-workspace-status-enable t)              ;; Display "LSP" in the modeline when enabled.
  (lsp-signature-doc-lines 1)                           ;; Limit echo area to one line.
  (lsp-eldoc-render-all nil)                              ;; Render all ElDoc messages.
  ;; Completion settings
  (lsp-completion-enable t)                             ;; Enable completion.
  (lsp-completion-enable-additional-text-edit t)        ;; Enable additional text edits for completions.
  (lsp-enable-snippet nil)                              ;; Disable snippets
  (lsp-completion-show-kind t)                          ;; Show kind in completions.
  ;; Lens settings
  (lsp-lens-enable t)                                   ;; Enable lens support.
  ;; Headerline settings
  (lsp-headerline-breadcrumb-enable-symbol-numbers t)   ;; Enable symbol numbers in the headerline.
  (lsp-headerline-arrow "▶")                            ;; Set arrow for headerline.
  (lsp-headerline-breadcrumb-enable-diagnostics nil)    ;; Disable diagnostics in headerline.
  (lsp-headerline-breadcrumb-icons-enable nil)          ;; Disable icons in breadcrumb.
  ;; Semantic settings
  (lsp-semantic-tokens-enable nil))                     ;; Disable semantic tokens.


;;; LSP Additional Servers
;; You can extend `lsp-mode' by integrating additional language servers for specific
;; technologies. For example, `lsp-tailwindcss' provides support for Tailwind CSS
;; classes within your HTML files. By using various LSP packages, you can connect
;; multiple LSP servers simultaneously, enhancing your coding experience across
;; different languages and frameworks.
(use-package lsp-tailwindcss
  :ensure t
  :straight t
  :defer t
  :config
  (add-to-list 'lsp-language-id-configuration '(".*\\.erb$" . "html")) ;; Associate ERB files with HTML.
  :init
  (setq lsp-tailwindcss-add-on-mode t))


;;; COMPANY
;; Company Mode provides a text completion framework for Emacs.
;; It enhances the editing experience by offering context-aware
;; suggestions as you type. With support for multiple backends,
;; Company Mode is highly customizable and can be integrated with
;; various modes and languages.
(use-package company
  :defer t
  :straight t
  :ensure t
  :custom
  (company-tooltip-align-annotations t)      ;; Align annotations with completions.
  (company-minimum-prefix-length 1)          ;; Trigger completion after typing 1 character
  (company-idle-delay 0.2)                   ;; Delay before showing completion (adjust as needed)
  (company-tooltip-maximum-width 50)
  :config

  ;; While using C-p C-n to select a completion candidate
  ;; C-y quickly shows help docs for the current candidate
  (define-key company-active-map (kbd "C-y")
              (lambda ()
                (interactive)
                (company-show-doc-buffer)))
  (define-key company-active-map [tab] 'company-complete-selection)
  (define-key company-active-map (kbd "TAB") 'company-complete-selection)
  (define-key company-active-map [ret] 'company-complete-selection)
  (define-key company-active-map (kbd "RET") 'company-complete-selection)
  :hook
  (after-init . global-company-mode)) ;; Enable Company Mode globally after initialization.


;;; MARKDOWN-MODE
;; Markdown Mode provides support for editing Markdown files in Emacs,
;; enabling features like syntax highlighting, previews, and more.
;; It’s particularly useful for README files, as it can be set
;; to use GitHub Flavored Markdown for enhanced compatibility.
(use-package markdown-mode
  :defer t
  :straight t
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)            ;; Use gfm-mode for README.md files.
  :init (setq markdown-command "multimarkdown")) ;; Set the Markdown processing command.



(require 'auctex)

(setq TeX-PDF-mode t)

(setq Latex-section-hook
      '(Latex-section-heading
	Latex-section-title
	Latex-section-toc
	Latex-section-section
	Latex-section-label))

(add-hook 'plain-TeX-mode-hook
          (lambda () (setq-local TeX-electric-math
                                 (cons "$" "$"))))
(add-hook 'LaTeX-mode-hook
          (lambda () (setq-local TeX-electric-math
                                 (cons "\\(" "\\)"))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files '("/home/iman/org/life.org" "/home/iman/org/work.org"))
 '(package-selected-packages '(auctex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-hl-change ((t (:background unspecified :foreground "#89b4fa"))))
 '(diff-hl-delete ((t (:background unspecified :foreground "#f38ba8"))))
 '(diff-hl-insert ((t (:background unspecified :foreground "#a6e3a1")))))
(put 'downcase-region 'disabled nil)
