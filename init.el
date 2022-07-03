;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(setq inhibit-startup-message t)

;; Turn off unneeded UI elements
(when (display-graphic-p)
  (menu-bar-mode -1)
  (tool-bar-mode -1))

(scroll-bar-mode -1)

;; Display line number in every buffer
(global-display-line-numbers-mode t)

(setq system-specific-font
      (cond
       ((eq system-type 'windows-nt)
	(progn
	  (set-face-attribute 'default nil :family "Consolas" :height 100)
	  (set-face-attribute 'italic nil :underline nil)))
       (t nil)))

(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))
(setq auto-save-default nil)

(load-theme 'modus-vivendi t)

(setq recentf-save-file (concat user-emacs-directory ".recentf"))
(setq recentf-max-menu-items 25)
(recentf-mode 1)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(setq history-length 25)
(savehist-mode 1)

;; Remember and restore the last cursor location of opened files
(save-place-mode 1)

;; Don't pop up UI dialogs when promting
(setq use-dialog-box nil)

;; Revert the buffer when the underlying file has changed
(global-auto-revert-mode 1)

;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

(setq-default indicate-buffer-boundaries 'left)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))
