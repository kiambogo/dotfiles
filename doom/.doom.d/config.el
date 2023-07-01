;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Christopher Poenaru"
      user-mail-address "kiambogo@gmail.com")
(setq doom-font (font-spec :family "Fira Code" :size 12)
     doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
(setq doom-theme 'doom-monokai-classic)
(setq display-line-numbers-type t)
(setq org-directory "~/org/")

;; Custom functions
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Bash + term
(defun source-bashrc ()
  (interactive)
  (vterm-send-string "source ~/.bash_profile")
  (vterm-send-return)
  (vterm-clear-scrollback)
  (vterm-clear)
  )

(add-hook 'vterm-mode-hook 'source-bashrc)

;; Go
(defun my-go-mode-hook ()
  (setq tab-width 2)
  (setq indent-tabs-mode nil)

  (setq lsp-go-goimports-local-prefixes '("abnormal"))
  (defun lsp-go-install-save-hooks ()
    (add-hook 'before-save-hook #'lsp-format-buffer t t)
    (add-hook 'before-save-hook #'lsp-organize-imports t t))
  (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

                                        ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
                                        ; Customize compile command to run go build
  (setq compile-command "go generate && go build -v && go test -v && go vet")
  (set (make-local-variable 'compile-command)
       "go generate && go build -v && go test -v && go vet")
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)



  ;; Bazel integration to override Go tooling
  (map! :leader
        (:prefix-map ("m" . "my-maps") :desc "Run bazel-test" "t a" #'bazel-test)
        (:prefix-map ("m" . "my-maps") :desc "Run bazel-test" "t t" #'bazel-test-at-point)
        (:prefix-map ("m" . "my-maps") :desc "Run bazel-test" "b b" #'bazel-build)
        (:prefix-map ("m" . "my-maps") :desc "Run bazel-test" "b g" #'bazel-run "//:gazelle")
        )


  )
(add-hook 'go-mode-hook 'my-go-mode-hook)

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))
