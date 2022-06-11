(setq inhibit-startup-message t)

;; Turn off unneeded UI elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Display line number in every buffer
(global-display-line-numbers-mode 1)

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
