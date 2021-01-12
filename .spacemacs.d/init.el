;; -*- mode: emacs-lisp -*-

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   dotspacemacs-distribution 'spacemacs
   dotspacemacs-enable-lazy-installation 'unused
   dotspacemacs-ask-for-lazy-installation t
   dotspacemacs-configuration-layer-path '()
   dotspacemacs-configuration-layers
   '(rust
     (auto-completion :variables auto-completion-enable-sort-by-usage t)
     better-defaults
     csv
     emacs-lisp
     python
     (haskell :variables
              haskell-enable-hindent t
              haskell-completion-backend 'lsp)
     html
     javascript
     markdown
     helm
     osx
     lsp
     (terraform :variables
                terraform-auto-format-on-save t)
     (go :variables
         go-backend 'lsp
         gofmt-command "goimports"
         go-use-gocheck-for-testing t
         go-tab-width 4
         go-format-before-save t
         go-use-golangci-lint t
         go-use-test-args "-p 100 -coverprofile=coverage.tmp"
         godoc-at-point-function 'godoc-gogetdoc
         go-test-command "ENV=test go test"
         )
     git
     (markdown :variables markdown-live-preview-engine 'vmd)
     org
     sql
     yaml
     spell-checking
     syntax-checking
     themes-megapack
     (version-control :variables version-control-global-margin t)
     )
   dotspacemacs-additional-packages '(exec-path-from-shell)
   dotspacemacs-frozen-packages '()
   dotspacemacs-excluded-packages '()
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  (server-start)
  (setq-default
   ns-auto-hide-menu-bar t
   dotspacemacs-elpa-https t
   dotspacemacs-elpa-timeout 5
   dotspacemacs-check-for-update nil
   dotspacemacs-elpa-subdirectory nil
   dotspacemacs-editing-style 'vim
   dotspacemacs-verbose-loading nil
   dotspacemacs-startup-banner 'official
   dotspacemacs-startup-lists '((projects . 7) (recents . 5) (todos . 5))
   dotspacemacs-startup-buffer-responsive t
   dotspacemacs-scratch-mode 'text-mode
   dotspacemacs-mode-line-theme 'gruvbox
   dotspacemacs-themes '(gruvbox
                         spacemacs-dark
                         spacemacs-light)
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-default-font '("Fira Code"
                               :size 13
                               :weight normal
                               :width normal
                               :powerline-scale 0.5)
   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-command-key "SPC"
   dotspacemacs-ex-command-key ":"
   dotspacemacs-emacs-leader-key "M-m"
   dotspacemacs-major-mode-leader-key ","
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   dotspacemacs-distinguish-gui-tab nil
   dotspacemacs-remap-Y-to-y$ nil
   dotspacemacs-retain-visual-state-on-shift t
   ;; If non-nil, J and K move lines up and down when in visual mode.
   ;; (default nil)
   dotspacemacs-visual-line-move-text nil
   dotspacemacs-ex-substitute-global nil
   dotspacemacs-default-layout-name "Default"
   dotspacemacs-display-default-layout nil
   dotspacemacs-auto-resume-layouts nil
   dotspacemacs-large-file-size 1
   dotspacemacs-auto-save-file-location 'nil ;; (Options: `original', `cache', `nil'. Default: `cache')
   dotspacemacs-max-rollback-slots 5
   dotspacemacs-helm-resize nil
   dotspacemacs-helm-no-header nil
   dotspacemacs-helm-position 'bottom;; (Options: `bottom', `top', `right', `left'. Default: `bottom')
   dotspacemacs-helm-use-fuzzy 'always
   dotspacemacs-enable-paste-transient-state nil
   dotspacemacs-which-key-delay 0.4
   dotspacemacs-which-key-position 'bottom
   dotspacemacs-loading-progress-bar t
   dotspacemacs-fullscreen-at-startup nil
   dotspacemacs-fullscreen-use-non-native nil
   dotspacemacs-maximized-at-startup nil
   dotspacemacs-active-transparency 90
   dotspacemacs-inactive-transparency 90
   dotspacemacs-show-transient-state-title t
   dotspacemacs-show-transient-state-color-guide t
   dotspacemacs-mode-line-unicode-symbols nil
   dotspacemacs-smooth-scrolling t
   dotspacemacs-line-numbers t
   dotspacemacs-folding-method 'evil ;; (Options: `evil', `origami'. Default: `evil')
   dotspacemacs-smartparens-strict-mode nil
   dotspacemacs-highlight-delimiters 'all
   dotspacemacs-persistent-server nil
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   dotspacemacs-default-package-repository nil
   dotspacemacs-whitespace-cleanup nil
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."

  (global-flycheck-mode)

  (exec-path-from-shell-copy-env "GOPATH")
  (exec-path-from-shell-initialize)

  ;; Use pgformatter (brew install pgformatter)
  (setq sqlfmt-executable "pg_format")
  (setq sqlfmt-options '())

  (setq-default fill-column 120)
  (setq truncate-lines t)

  ;; Trigger completion immediately.
  (setq company-idle-delay 0)

  ;; Number the candidates (use M-1, M-2 etc to select completions).
  (setq company-show-numbers t)

  ;; Ensure Super-c/v work
  (define-key global-map [?\s-x] 'kill-region)
  (define-key global-map [?\s-c] 'kill-ring-save)
  (define-key global-map [?\s-v] 'yank)

  ; Remap the git rebase move line commands as the defaults interfere with chunkwm
  (with-eval-after-load 'git-rebase
    (define-key git-rebase-mode-map
      (kbd "M-[") 'git-rebase-move-line-up)
    (define-key git-rebase-mode-map
      (kbd "M-]") 'git-rebase-move-line-down))

  (defun my-go-mode-hook ()
    ; Don't require confirmation on build command
    (setq compilation-read-command nil)

    ; Set go build command
    (if (not (string-match "go" compile-command))
        (set (make-local-variable 'compile-command)
             "go build && go vet"))

    ; Compile Go code with ,c
    (spacemacs/set-leader-keys-for-major-mode 'go-mode "c"
      (lambda () (interactive) (compile "go build && go vet")))
  )

  (add-hook 'go-mode-hook 'my-go-mode-hook)

  ; Scale text size for all buffers
  (defadvice text-scale-increase(around all-buffers (arg) activate)
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        ad-do-it)))
  (defadvice text-scale-set(around all-buffers (arg) activate)
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        ad-do-it)))

  ; Clean recently used files after 5 mins
  '(recentf-auto-cleanup 300)

  ;; (set-face-attribute 'default nil :family "Source Code Pro")
  ;; (set-face-attribute 'default nil :height 135)
  (setq ns-right-command-modifier 'none)   ;; original value is 'left'
  (setq ns-right-alternate-modifier 'none) ;; original value is 'left'
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-want-Y-yank-to-eol nil)
 '(package-selected-packages
   (quote
    (company-go yapfify terraform-mode hcl-mode reveal-in-osx-finder pyvenv pytest pyenv-mode py-isort pip-requirements pbcopy osx-trash osx-dictionary live-py-mode launchctl hy-mode helm-pydoc autothemer cython-mode csv-mode company-anaconda anaconda-mode pythonic writeroom-mode zenburn-theme zen-and-art-theme white-sand-theme web-mode web-beautify underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme toxi-theme toml-mode tao-theme tangotango-theme tango-plus-theme tango-2-theme tagedit sunny-day-theme sublime-themes subatomic256-theme subatomic-theme spacegray-theme soothe-theme solarized-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme slim-mode seti-theme scss-mode sass-mode reverse-theme rebecca-theme railscasts-theme racer purple-haze-theme pug-mode professional-theme planet-theme phoenix-dark-pink-theme phoenix-dark-mono-theme organic-green-theme omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme noctilux-theme naquadah-theme mustang-theme monokai-theme monochrome-theme molokai-theme moe-theme minimal-theme material-theme majapahit-theme madhat2r-theme lush-theme livid-mode skewer-mode simple-httpd light-soap-theme json-mode json-snatcher json-reformat js2-refactor multiple-cursors js2-mode js-doc jbeans-theme jazz-theme ir-black-theme inkpot-theme heroku-theme hemisu-theme helm-css-scss hc-zenburn-theme haml-mode gruber-darker-theme grandshell-theme gotham-theme gandalf-theme flycheck-rust flatui-theme flatland-theme farmhouse-theme exotica-theme transient espresso-theme emmet-mode dracula-theme django-theme darktooth-theme darkokai-theme darkmine-theme darkburn-theme dakrone-theme cyberpunk-theme company-web web-completion-data company-tern dash-functional color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized coffee-mode clues-theme cherry-blossom-theme cargo rust-mode busybee-theme bubbleberry-theme birds-of-paradise-plus-theme badwolf-theme apropospriate-theme anti-zenburn-theme ample-zen-theme ample-theme alect-themes afternoon-theme gruvbox-theme yaml-mode vmd-mode unfill smeargle orgit org-projectile org-category-capture org-present org-pomodoro alert log4e gntp org-mime org-download noflet mwim markdown-toc markdown-mode magit-gitflow htmlize helm-gitignore helm-company helm-c-yasnippet go-guru go-eldoc gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter gh-md fuzzy flyspell-correct-helm flyspell-correct flycheck-pos-tip pos-tip flycheck evil-magit magit magit-popup git-commit with-editor ensime sbt-mode scala-mode go-mode auto-yasnippet auto-dictionary ac-ispell auto-complete sql-indent diff-hl mmm-mode yasnippet company-statistics company ws-butler winum which-key volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spaceline powerline restart-emacs request rainbow-delimiters popwin persp-mode pcre2el paradox spinner org-plus-contrib org-bullets open-junk-file neotree move-text macrostep lorem-ipsum linum-relative link-hint indent-guide hydra hungry-delete hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation helm-themes helm-swoop helm-projectile helm-mode-manager helm-make projectile pkg-info epl helm-flx helm-descbinds helm-ag google-translate golden-ratio flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist highlight evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg undo-tree eval-sexp-fu elisp-slime-nav dumb-jump f dash s diminish define-word column-enforce-mode clean-aindent-mode bind-map bind-key auto-highlight-symbol auto-compile packed aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line helm avy helm-core popup async))))
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-term-color-vector
   [unspecified "#14191f" "#d15120" "#81af34" "#deae3e" "#7e9fc9" "#a878b5" "#7e9fc9" "#dcdddd"])
 '(evil-want-Y-yank-to-eol nil)
 '(fci-rule-character-color "#192028")
 '(hl-todo-keyword-faces
   (quote
    (("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#4f97d7")
     ("OKAY" . "#4f97d7")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#86dc2f")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX" . "#dc752f")
     ("XXXX" . "#dc752f"))))
 '(package-selected-packages
   (quote
    (tern company-go yapfify terraform-mode hcl-mode reveal-in-osx-finder pyvenv pytest pyenv-mode py-isort pip-requirements pbcopy osx-trash osx-dictionary live-py-mode launchctl hy-mode helm-pydoc autothemer cython-mode csv-mode company-anaconda anaconda-mode pythonic writeroom-mode zenburn-theme zen-and-art-theme white-sand-theme web-mode web-beautify underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme toxi-theme toml-mode tao-theme tangotango-theme tango-plus-theme tango-2-theme tagedit sunny-day-theme sublime-themes subatomic256-theme subatomic-theme spacegray-theme soothe-theme solarized-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme slim-mode seti-theme scss-mode sass-mode reverse-theme rebecca-theme railscasts-theme racer purple-haze-theme pug-mode professional-theme planet-theme phoenix-dark-pink-theme phoenix-dark-mono-theme organic-green-theme omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme noctilux-theme naquadah-theme mustang-theme monokai-theme monochrome-theme molokai-theme moe-theme minimal-theme material-theme majapahit-theme madhat2r-theme lush-theme livid-mode skewer-mode simple-httpd light-soap-theme json-mode json-snatcher json-reformat js2-refactor multiple-cursors js2-mode js-doc jbeans-theme jazz-theme ir-black-theme inkpot-theme heroku-theme hemisu-theme helm-css-scss hc-zenburn-theme haml-mode gruber-darker-theme grandshell-theme gotham-theme gandalf-theme flycheck-rust flatui-theme flatland-theme farmhouse-theme exotica-theme transient espresso-theme emmet-mode dracula-theme django-theme darktooth-theme darkokai-theme darkmine-theme darkburn-theme dakrone-theme cyberpunk-theme company-web web-completion-data company-tern dash-functional color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized coffee-mode clues-theme cherry-blossom-theme cargo rust-mode busybee-theme bubbleberry-theme birds-of-paradise-plus-theme badwolf-theme apropospriate-theme anti-zenburn-theme ample-zen-theme ample-theme alect-themes afternoon-theme gruvbox-theme yaml-mode vmd-mode unfill smeargle orgit org-projectile org-category-capture org-present org-pomodoro alert log4e gntp org-mime org-download noflet mwim markdown-toc markdown-mode magit-gitflow htmlize helm-gitignore helm-company helm-c-yasnippet go-guru go-eldoc gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter gh-md fuzzy flyspell-correct-helm flyspell-correct flycheck-pos-tip pos-tip flycheck evil-magit magit magit-popup git-commit with-editor ensime sbt-mode scala-mode go-mode auto-yasnippet auto-dictionary ac-ispell auto-complete sql-indent diff-hl mmm-mode yasnippet company-statistics company ws-butler winum which-key volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spaceline powerline restart-emacs request rainbow-delimiters popwin persp-mode pcre2el paradox spinner org-plus-contrib org-bullets open-junk-file neotree move-text macrostep lorem-ipsum linum-relative link-hint indent-guide hydra hungry-delete hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation helm-themes helm-swoop helm-projectile helm-mode-manager helm-make projectile pkg-info epl helm-flx helm-descbinds helm-ag google-translate golden-ratio flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist highlight evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg undo-tree eval-sexp-fu elisp-slime-nav dumb-jump f dash s diminish define-word column-enforce-mode clean-aindent-mode bind-map bind-key auto-highlight-symbol auto-compile packed aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line helm avy helm-core popup async)))
 '(pdf-view-midnight-colors (quote ("#b2b2b2" . "#292b2e"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
