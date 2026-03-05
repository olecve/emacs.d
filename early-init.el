;; early-init.el --- Early initialization -*- lexical-binding: t -*-
;; Runs before package.el and the GUI is initialized.
;; Suppressing UI elements here prevents them from being drawn and then hidden,
;; reducing startup flicker.

(setq package-enable-at-startup nil)

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
