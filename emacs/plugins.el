(setq package-enable-at-startup nil)
(package-initialize)

;; open resource
(add-to-list 'load-path "~/.emacs.d/recentf.el")
(require 'recentf)
(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "open-resource.el"))
(setq open-resource-ignore-patterns (quote ("/target/" "~$" ".old$" ".svn")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start- taken from http://www.masteringemacs.org/article/find-files-faster-recent-files-package
;; get rid of `find-file-read-only' and replace it with something
;; more useful.
(global-set-key (kbd "C-c C-r") 'ido-recentf-open)

;; enable recent files mode.
(recentf-mode t)

;; 50 files ought to be enough.
(setq recentf-max-saved-items 50)

(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))
;;; end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; melba
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; elisp-slime-nav
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
  (add-hook hook 'turn-on-elisp-slime-nav-mode))

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; winner mode. allows returning to previous window configuration with 'C-c left' and 'C-c right'
(winner-mode 1)

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(add-to-list 'ido-work-directory-list-ignore-regexps tramp-file-name-regexp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

;;; auto complete mod
;;; should be loaded after yasnippet so that they can work together
(require 'auto-complete-config)
(auto-complete-mode 1)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; lisp stuff
(defun lisp-hooks ()
  (interactive)
  (paredit-mode t)
  (rainbow-delimiters-mode t))

;; (add-to-list 'auto-mode-alist '("\\.R\\'" . inferior-ess-mode))

;; clojure/lispy stuff
(dolist (hook '(clojure-mode-hook emacs-lisp-mode-hook ielm-mode-hook cider-repl-mode))
  (add-hook hook 'lisp-hooks))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; viper-mode
(setq viper-mode t)
(setq viper-ESC-moves-cursor-back nil)
(require 'viper)

(setq-default viper-want-emacs-keys-in-insert t)

(viper-record-kbd-macro "$" 'vi-state [ (control e) ] 't)
(setq viper-case-fold-search 't) ; viper search - case insensitive
(setq viper-insert-state-cursor-color "Green")
(setq viper-emacs-state-cursor-color "Blue")

;; Override annoying stuff when in vi mode
(define-key viper-vi-basic-map (kbd "C-e") nil)
(define-key viper-vi-basic-map (kbd "C-f") nil)
(define-key viper-vi-basic-map (kbd "C-b") nil)
(define-key viper-vi-basic-map (kbd "C-m") 'newline)
(define-key viper-vi-basic-map (kbd "C-d") nil)

;; Override annoying stuff when in "insert mode"
(define-key viper-insert-basic-map (kbd "C-w") nil)
(define-key viper-insert-basic-map (kbd "C-d") nil)
(define-key viper-insert-basic-map (kbd "C-y") nil)
(define-key viper-insert-basic-map (kbd "C-t") nil)
(define-key viper-insert-basic-map (kbd "TAB") nil)
(define-key viper-insert-basic-map (kbd "<tab>") nil)
(define-key viper-insert-basic-map (kbd "C-m") 'newline)

(set 'viper-fast-keyseq-timeout 0)
(set 'viper-no-multiple-ESC t)
(defun viper-translate-all-ESC-keysequences () t)
(set 'viper-ESC-keyseq-timeout 0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



