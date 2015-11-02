;;;;
;; Packages
;;;;
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; packages to install
(defvar my-packages
  '(rainbow-delimiters
    volatile-highlights
    undo-tree
    smex
    sr-speedbar
    solarized-theme
    saveplace
    recentf
    discover-my-major
    projectile
    helm
    helm-projectile
    clojure-mode
    clojure-mode-extra-font-locking
    paredit
    cider
    swiper))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;;;;
;;  Navigation
;;;;

;; ido-mode allows you to more easily navigate choices. For example,
;; when you want to switch buffers, ido presents you with a list
;; of buffers in the the mini-buffer. As you start to type a buffer's
;; name, ido will narrow down the list of buffers to match the text
;; you've typed in
;; http://www.emacswiki.org/emacs/InteractivelyDoThings
(ido-mode 1)

;; This allows partial matches, e.g. "tl" will match "Tyrion Lannister"
(setq ido-enable-flex-matching t)

(setq ido-everywhere t)

;; Shows a list of buffers
(global-set-key (kbd "C-x C-b") 'ibuffer)

(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; When you visit a file, point goes to the last place where it
;; was when you previously visited the same file.
;; http://www.emacswiki.org/emacs/SavePlace
(require 'saveplace)
(setq-default save-place t)
;; keep track of saved places in ~/.emacs.d/places
(setq save-place-file (concat user-emacs-directory "places"))

;; Turn on recent file mode so that you can more easily switch to
;; recently edited files when you first start emacs
(setq recentf-save-file (concat user-emacs-directory ".recentf"))
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 40)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-split-window-default-side 'below)
(setq helm-always-two-windows t)

;; swiper
(require 'swiper)
(setq ivy-use-virtual-buffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key "\C-r" 'swiper)

;;;;
;;  UI
;;;;
(scroll-bar-mode -1)              ;; disable scroll bars
(tool-bar-mode -1)
(setq inhibit-startup-message t)
(setq-default cursor-type 'bar)   ;; tiny cursor
(setq ring-bell-function 'ignore) ;; no bell

;; Linum
(require 'linum)
(line-number-mode   t)
(global-linum-mode  t)
(column-number-mode t)
(setq linum-format " %d")

;; Scrolling settings
(setq scroll-step                     1)
(setq scroll-margin                  10)
(setq scroll-conservatively       10000)
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse       't) ;; scroll window under mouse

;; Fonts
(set-face-attribute 'default nil :family "Consolas" :height 100)

;; full path in title bar
(setq-default frame-title-format "%b (%f)")

;; Highlight current line
(global-hl-line-mode t)

;; See matching pairs of parentheses and other characters
(show-paren-mode t)

;; No blinking cursor
(blink-cursor-mode 0)

;; Highlight trailing whitespaces in lines
(setq-default show-trailing-whitespace t)

;; Show tab as 2 spaces
(setq-default tab-width 2)

;;;;
;;  Theme
;;;;

;; Solizrized costomizations
;; Don't change the font for some headings and titles
(setq solarized-use-variable-pitch nil)
;; Don't change size of org-mode headlines (but keep other size-changes)
(setq solarized-scale-org-headlines nil)
(load-theme 'solarized-light t)

;;;;
;;  Minor modes
;;;;

;; Enable projectile
(require 'projectile)
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)
(setq projectile-use-native-indexing t)
(setq projectile-globally-ignored-directories
	  (append projectile-globally-ignored-directories '(".git" ".hg" "target" ".sass-cache" "node_modules")))

;; Typing text replaces active selection
(delete-selection-mode t)

;; Enable auto pairing of brackets and quotation marks
(electric-pair-mode 1)

;; UndoTree
(require 'undo-tree)
(global-undo-tree-mode)

(require 'volatile-highlights)
(volatile-highlights-mode t)

;;;;
;;  Misc
;;;;
(require 'misc)

(require 'sr-speedbar)
(setq speedbar-show-unknown-files t)

;; Save typing chars when answering yes-or-no-p questions
(defalias 'yes-or-no-p 'y-or-n-p)

;; Emacs can automatically create backup files. This tells Emacs to
;; put all backups in ~/.emacs.d/backups. More info:
;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Backup-Files.html
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))
(setq auto-save-default nil)

;; A quick major mode help with discover-my-major
;; original "C-h h" displays "hello world" in different languages
(global-unset-key (kbd "C-h h"))
(define-key 'help-command (kbd "h m") 'discover-my-major)

;;;;
;;  Functions
;;;;
(require 'cl)
(defun olecve/pretty-print-xml-region (begin end)
  (interactive "r")
  (save-excursion
    (nxml-mode)
    ;; split <foo><bar> or </foo><bar>, but not <foo></foo>
    (goto-char begin)
    (while (search-forward-regexp ">[ \t]*<[^/]" end t)
      (backward-char 2) (insert "\n") (incf end))
    ;; split <foo/></foo> and </foo></foo>
    (goto-char begin)
    (while (search-forward-regexp "<.*?/.*?>[ \t]*<" end t)
      (backward-char) (insert "\n") (incf end))
    ;; put xml namespace decls on newline
    (goto-char begin)
    (while (search-forward-regexp "\\(<\\([a-zA-Z][-:A-Za-z0-9]*\\)\\|['\"]\\) \\(xmlns[=:]\\)" end t)
      (goto-char (match-end 0))
      (backward-char 6) (insert "\n") (incf end))
    (indent-region begin end nil))
  (message "All indented!"))


(defun olecve/xml-pretty-print-buffer ()
  "pretty print the XML in a buffer."
  (interactive)
  (olecve/pretty-print-xml-region (point-min) (point-max)))

(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

;;;;
;;  Key bindings
;;;;
(global-set-key (kbd "C--")            'text-scale-decrease)
(global-set-key (kbd "C-=")            'text-scale-increase)
(global-set-key (kbd "S-<down>")       'windmove-down)
(global-set-key (kbd "S-<left>")       'windmove-left)
(global-set-key (kbd "S-<right>")      'windmove-right)
(global-set-key (kbd "S-<up>")         'windmove-up)
(global-set-key [(control shift up)]   'move-line-up)
(global-set-key [(control shift down)] 'move-line-down)
(global-set-key (kbd "C-c g")          'helm-google-suggest)
