;;; Christopher Poenaru <kiambogo@gmail.com>

(require 'package)

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa-stable" . "https://melpa.milkbox.net/packages/")))

(package-initialize)

(setq package-list
  '(async buffer-move color-theme company ensime epl flycheck use-package
	  magit projectile haskell-mode helm helm-projectile markdown-mode monokai-theme
	  move-text neotree sbt-mode smartparens undo-tree))

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

; Hide stuff I don't need, and make fullscreen
(tool-bar-mode 0)
(menu-bar-mode 0)
(global-linum-mode t)
(toggle-frame-fullscreen)
(scroll-bar-mode 0)
(fset `yes-or-no-p `y-or-n-p)
(load-theme 'monokai t)

(require 'use-package)

; Package configurations
(use-package ensime
  :ensure t
  :commands ensime ensime-mode)

(use-package smartparens
  :diminish smartparens-mode
  :commands
  smartparens-strict-mode
  smartparens-mode
  sp-restrict-to-pairs-interactive
  sp-local-pair
  :init
  (setq sp-interactive-dwim t)
  :config
  (require 'smartparens-config)
  (sp-use-smartparens-bindings)
  (sp-pair "(" ")" :wrap "C-(") ;; how do people live without this?
  (sp-pair "[" "]" :wrap "s-[") ;; C-[ sends ESC
  (sp-pair "{" "}" :wrap "C-{")
  (bind-key "C-<left>" nil smartparens-mode-map)
  (bind-key "C-<right>" nil smartparens-mode-map))


; allow for commenting and uncommenting of blocks of code
(setq comment-start "/* "
	  comment-end " */"
	  comment-style 'multi-line
	  comment-empty-lines t)

(sp-local-pair 'scala-mode "(" nil :post-handlers '(("||\n[i]" "RET")))
(sp-local-pair 'scala-mode "{" nil :post-handlers '(("||\n[i]" "RET") ("| " "SPC")))

(require 'haskell-mode)
(require 'helm-config)
(require 'company)
(require 'neotree)
(require 'helm-projectile)

(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

; Enable modes
(helm-mode 1)
(projectile-mode 1)

(global-flycheck-mode t)
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;;; text-mode
(add-hook 'fundamental-mode-hook 'flyspell-mode)      ; spellcheck text
(add-hook 'fundamental-mode-hook 'turn-on-auto-fill)  ; autofill text

;;;Company Mode
(global-company-mode t)
(global-set-key (kbd "M-/") 'company-complete)
(setq-default
 company-idle-delay nil
 company-minimum-prefix-length 2
 company-selection-wrap-around t
 company-show-numbers t
 company-tooltip-align-annotations t)

;;; Hooks
(add-hook 'scala-mode-hook
	  (lambda ()
	    (scala-mode:goto-start-of-code)
	    (company-mode)
	    (git-gutter-mode)
	    (show-paren-mode)	   
	    (smartparens-mode)
	    (ensime-mode)))

(add-hook 'haskell-mode-hook
	  (lambda ()
	    (company-mode)))
	    
; Key Bindings
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-/") 'completion-at-point)

; Reindent entire buffer
(defun indent-buffer ()
  "Indent the entire buffer."
  (interactive)
  (save-excursion
    (delete-trailing-whitespace)
    (indent-region (point-min) (point-max) nil)
    (untabify (point-min) (point-max))))

(when (eq system-type 'darwin)
  (require 'ls-lisp)
  (setq ls-lisp-use-insert-directory-program nil))

;;; Move Text blocks
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

(setq exec-path '("/usr/local/bin"))
(setq backup-directory-alist `(("." . "~/.saves")))

; Neotree open highlighted file in split
(global-set-key [f8] 'neotree-toggle)
(define-key neotree-mode-map (kbd "i") #'neotree-enter-horizontal-split)
(define-key neotree-mode-map (kbd "I") #'neotree-enter-vertical-split)
