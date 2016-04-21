(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade.ferrier.me.uk/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)
(tool-bar-mode 0)
(menu-bar-mode 0)
(global-linum-mode t)
(toggle-frame-fullscreen)
(scroll-bar-mode 0)
(fset `yes-or-no-p `y-or-n-p)
(load-theme 'monokai t)

(use-package ensime :commands ensime ensime-mode)

(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(add-hook 'scala-mode-hook 'ensime-mode)
(setq exec-path (append exec-path '("/usr/local/bin")))
