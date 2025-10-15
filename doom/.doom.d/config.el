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

;; Copy git-relative file path with @ prefix for Claude Code references
(defun copy-git-relative-path-with-prefix ()
  "Copy the current file's path relative to git root with @ prefix to clipboard."
  (interactive)
  (if-let* ((file-path (buffer-file-name))
            (git-root (locate-dominating-file file-path ".git")))
      (let* ((relative-path (file-relative-name file-path git-root))
             (prefixed-path (concat "@" relative-path)))
        (kill-new prefixed-path)
        (message "Copied: %s" prefixed-path))
    (message "Not in a git repository or no file associated with buffer")))

(map! :leader
      :desc "Copy git-relative path with @"
      "f Y" #'copy-git-relative-path-with-prefix)

;; Bash + term
;; (defun source-bashrc ()
;; ;;   (interactive)
;; ;;   (vterm-send-string "source ~/.bash_profile")
;; ;;   (vterm-send-return)
;; ;;   (vterm-clear-scrollback)
;; ;;   (vterm-clear)
;; ;;   )

;; (add-hook 'vterm-mode-hook 'source-bashrc)

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

(after! (evil copilot)
  ;; Define the custom function that either accepts the completion or does the default behavior
  (defun my/copilot-tab-or-default ()
    (interactive)
    (if (and (bound-and-true-p copilot-mode)
             ;; Add any other conditions to check for active copilot suggestions if necessary
             )
        (copilot-accept-completion)
      (evil-insert 1))) ; Default action to insert a tab. Adjust as needed.

  ;; Bind the custom function to <tab> in Evil's insert state
  (evil-define-key 'insert 'global (kbd "<tab>") 'my/copilot-tab-or-default))

;; Claude Code IDE keybindings
(use-package! claude-code-ide
  :init
  (map! :leader
        (:prefix-map ("a" . "claude-code-ide")
         :desc "Start Claude Code"           "a" #'claude-code-ide
         :desc "Resume Claude Code"          "r" #'claude-code-ide-resume
         :desc "Stop Claude Code"            "s" #'claude-code-ide-stop
         :desc "Switch to Claude buffer"     "b" #'claude-code-ide-switch-to-buffer
         :desc "List Claude sessions"        "l" #'claude-code-ide-list-sessions
         :desc "Check Claude status"         "?" #'claude-code-ide-check-status
         :desc "Insert selected text"        "i" #'claude-code-ide-insert-at-mentioned
         :desc "Send escape key"             "e" #'claude-code-ide-send-escape
         :desc "Insert newline"              "n" #'claude-code-ide-insert-newline
         :desc "Show debug buffer"           "d" #'claude-code-ide-show-debug
         :desc "Clear debug buffer"          "D" #'claude-code-ide-clear-debug)))
