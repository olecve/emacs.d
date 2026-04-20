;; early-init.el --- Early initialization -*- lexical-binding: t -*-
;; Runs before package.el and the GUI is initialized.
;; Suppressing UI elements here prevents them from being drawn and then hidden,
;; reducing startup flicker.

(setq package-enable-at-startup nil)

;; Defer GC during startup; restore to a sane value after init completes.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)
                  gc-cons-percentage 0.1)))

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
