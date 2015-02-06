(setq package-enable-at-startup nil)
(package-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq path-to-ctags "~/.emacs.d/TAGS") ;; <- your ctags path here
(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "ctags -f %s -e -R %s" path-to-ctags (directory-file-name dir-name))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; open resource
(add-to-list 'load-path "~/.emacs.d/recentf.el")
(require 'recentf)
(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "open-resource.el"))
(setq open-resource-ignore-patterns (quote ("/target/" "~$" ".old$" ".svn")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start- taken from http://www.masteringemacs.org/article/find-files-faster-recent-files-package
;; get rid of `find-file-read-only' and replace it with something
;; more useful.
(global-set-key (kbd "H-*") 'ido-recentf-open)

;; enable recent files mode.
(recentf-mode t)
(setq recentf-max-saved-items 50)

(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))

;; a better solution
(setq ido-auto-merge-work-directories-length -1)
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

(global-set-key
 "\M-x"
 (lambda ()
   (interactive)
   (call-interactively
    (intern
     (ido-completing-read
      "M-x "
      (all-completions "" obarray 'commandp))))))

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
(dolist (hook '(clojure-mode-hook
                emacs-lisp-mode-hook
                ielm-mode-hook
                cider-repl-mode
                cider-repl-mode-hook))
  (add-hook hook 'lisp-hooks))
(setq cider-test-show-report-on-success nil)
(add-hook 'cider-mode-hook #'eldoc-mode)
(setq nrepl-log-messages t)
(setq nrepl-hide-special-buffers t)
(setq cider-repl-pop-to-buffer-on-connect nil)
(setq cider-repl-result-prefix ";;=> ")

;; add the pretty lambda symbols
(setq global-prettify-symbols-mode t)
(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("(\\(fn\\)[\[[:space:]]"
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "λ")
                               nil))))))

(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("\\(#\\)("
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "ƒ")
                               nil))))))

(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("\\(#\\){"
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "∈")
                               nil))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'evil)
(evil-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;
;; colors up the cursor
;;;;;;;;;;;;;;;;;;;;;;;
(setq evil-default-cursor '("white" box))
(setq evil-normal-state-cursor '("white" box))
(setq evil-insert-state-cursor '("green" bar))
(setq evil-emacs-state-cursor '("blue" box))
(setq evil-visual-state-cursor '("violet"))
(setq evil-replace-state-cursor '("red" hbar))
(setq evil-operator-state-cursor '("orange"))
(setq evil-motion-state-cursor '("magenta"))

;; http://www.emacswiki.org/emacs/Evil
;; change mode-line color by evil state
(lexical-let ((default-color (cons (face-background 'mode-line)
                                   (face-foreground 'mode-line))))
  (add-hook 'post-command-hook
            (lambda ()
              (let ((color (cond ((minibufferp) default-color)
                                 ((evil-insert-state-p) '("green" . "#000000"))
                                 ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                                 ((evil-visual-state-p) '("red" . "#000000"))
                                 ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
                                 (t default-color))))
                (set-face-background 'mode-line (car color))
                (set-face-foreground 'mode-line (cdr color))))))

;;;;;;;;;;;;;;;;;;;;;;;
;; left at column 0 puts cursor on last column of previous line
;; right on last column of line puts cursor on column 0 of next line
;; http://stackoverflow.com/questions/20882935/how-to-move-between-visual-lines-and-move-past-newline-in-evil-mode
;;;;;;;;;;;;;;;;;;;;;;;
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(setq-default evil-cross-lines t)

;;;;;;;;;;;;;;;;;;;;;;;
;; overriding annoying stuff when in insert or normal mode
;;;;;;;;;;;;;;;;;;;;;;;
(define-key evil-normal-state-map (kbd "C-e") 'evil-end-of-visual-line)
(define-key evil-normal-state-map (kbd "C-f") 'forward-char)
(define-key evil-normal-state-map (kbd "C-b") 'backward-char)
(define-key evil-normal-state-map (kbd "C-m") 'newline)
(define-key evil-normal-state-map (kbd "C-d") 'delete-char)
(define-key evil-normal-state-map (kbd "C-t") 'transpose-chars)
(define-key evil-normal-state-map (kbd "q")    nil)
(define-key evil-normal-state-map (kbd "C-w")  nil)
(define-key evil-normal-state-map (kbd "gf")  'ido-find-file)
(define-key evil-normal-state-map (kbd "C-r")  nil)


(define-key evil-insert-state-map (kbd "C-e") 'evil-end-of-visual-line)
(define-key evil-insert-state-map (kbd "C-n") nil)
(define-key evil-insert-state-map (kbd "C-p") nil)
(define-key evil-insert-state-map (kbd "C-d") nil)
(define-key evil-insert-state-map (kbd "C-y") nil)
(define-key evil-insert-state-map (kbd "C-t") nil)
(define-key evil-insert-state-map (kbd "C-k") nil)
(define-key evil-insert-state-map (kbd "C-w") nil)
(define-key evil-insert-state-map (kbd "C-r") nil)

(define-key evil-normal-state-map (kbd "gp")  'elscreen-previous)
(define-key evil-normal-state-map (kbd "gn")  'elscreen-next)
(define-key evil-normal-state-map (kbd "gh")  'windmove-left)
(define-key evil-normal-state-map (kbd "gl")  'windmove-right)
(define-key evil-normal-state-map (kbd "gk")  'windmove-up)
(define-key evil-normal-state-map (kbd "gj")  'windmove-down)
;; when exiting insert mode, the cursor doesn't move back a column
(setq evil-move-cursor-back nil)

;; when exiting insert mode, stuff happens
;; (dolist (hook '(evil-normal-state-entry-hook))
;;   (add-hook hook 'save-and-format-buffer))

;; this gives the vim tabs stuff
(load "elscreen" "ElScreen" t)
(elscreen-start)
(setq elscreen-display-tab nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'sr-speedbar)
;; Start Sr-Speedbar in buffer mode by default
(add-hook 'speedbar-mode-hook
          (lambda ()
            (speedbar-change-initial-expansion-list "quick buffers")))

(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
