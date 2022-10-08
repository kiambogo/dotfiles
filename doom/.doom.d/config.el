;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Christopher Poenaru"
      user-mail-address "kiambogo@gmail.com")
(setq doom-font (font-spec :family "Fira Code" :size 12)
     doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
(setq doom-theme 'doom-peacock)
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
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  (setq gofmt-args '("-local" "abnormal"))
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (setq compile-command "go generate && go build -v && go test -v && go vet")
  (set (make-local-variable 'compile-command)
           "go generate && go build -v && go test -v && go vet")
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
)
(add-hook 'go-mode-hook 'my-go-mode-hook)
