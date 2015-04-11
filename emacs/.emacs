(setq version-controlled-stuff-dir "~/scripty-bits-n-shortcuts/emacs")

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
;; (add-to-list 'ido-work-directory-list-ignore-regexps tramp-file-name-regexp)
(setq desktop-files-not-to-save "^$")

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
;; (setq cider-repl-pop-to-buffer-on-connect nil)
(setq cider-repl-result-prefix ";;=> ")

;; add the pretty lambda symbols
(setq global-prettify-symbols-mode t)
;; (eval-after-load 'clojure-mode
;;   '(font-lock-add-keywords
;;     'clojure-mode `(("(\\(fn\\)[\[[:space:]]"
;;                      (0 (progn (compose-region (match-beginning 1)
;;                                                (match-end 1) "λ")
;;                                nil))))))

;; (eval-after-load 'clojure-mode
;;   '(font-lock-add-keywords
;;     'clojure-mode `(("\\(#\\)("
;;                      (0 (progn (compose-region (match-beginning 1)
;;                                                (match-end 1) "ƒ")
;;                                nil))))))

;; (eval-after-load 'clojure-mode
;;   '(font-lock-add-keywords
;;     'clojure-mode `(("\\(#\\){"
;;                      (0 (progn (compose-region (match-beginning 1)
;;                                                (match-end 1) "∈")
;;                                nil))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'evil)
(evil-mode 1)

(require 'evil-surround)
(global-evil-surround-mode 1)

(require 'highlight)
(require 'evil-search-highlight-persist)
(global-evil-search-highlight-persist t)
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
(setq evil-move-cursor-back t)

;; this gives the vim tabs stuff
(load "elscreen" "ElScreen" t)
(elscreen-start)
(setq elscreen-display-tab nil)
(elscreen-persist-mode 1)
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

;;;;;;;;;;;;;
;; golden ratio
;; https://github.com/roman/golden-ratio.el
;;;;;;;;;;;;;
;; (require 'golden-ratio)
;; (golden-ratio-mode 1)

;;;;;;;;;;;;;
;; helm
;; http://tuhdo.github.io/helm-intro.html
;;;;;;;;;;;;;
(require 'helm)
(helm-mode 1)
(require 'helm-config)

(setq helm-M-x-fuzzy-match t)
(helm-autoresize-mode t)
;; (setq helm-mini)
(setq helm-buffers-fuzzy-matching t)
(setq helm-recentf-fuzzy-match t)
(setq helm-semantic-fuzzy-match t)
(setq helm-imenu-fuzzy-match t)
(helm-autoresize-mode t)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

;; enables man page at point
(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)
(semantic-mode 1)
;;;;;;;;;;;;;
;; eclim
;; https://github.com/senny/emacs-eclim
;;;;;;;;;;;;;
;; (require 'eclim)
;; (global-eclim-mode)
;; (custom-set-variables
;;  '(eclim-eclipse-dirs '("~/Programs/eclipse"))
;;  '(eclim-executable "~/Programs/eclipse/eclim"))
;; (require 'eclimd)

;; regular auto-complete initialization
;; (require 'auto-complete-config)
;; (ac-config-default)

;; add the emacs-eclim source
;; (require 'ac-emacs-eclim-source)
;; (ac-emacs-eclim-config)

;; configuring company-mode
(require 'company)
;; (require 'company-emacs-eclim)
;; (company-emacs-eclim-setup)
;; (global-company-mode t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; python stuff ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; make sure to run (run-python) https://github.com/bbatsov/prelude/issues/530
(autoload 'jedi:setup "jedi" nil t)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)
(setq jedi:complete-on-dot t)

;; eval-in-repl
(require 'eval-in-repl)
(require 'eval-in-repl-python)
(define-key python-mode-map (kbd "H-e") 'eir-eval-in-python)

(require 'django-html-mode)
(require 'django-mode)
;;(yas/load-directory "~/.emacs.d/elpa/django-snippets-20131229.811/snippets")
;;(add-to-list 'auto-mode-alist '("\\.djhtml$" . django-html-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; sgml/html stuff ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun zencoding-hooks ()
  (interactive)
  (zencoding-mode t)
  (multiple-cursors-mode t))

(require 'zencoding-mode)
(dolist (hook '(sgml-mode-hook
                html-mode-hook
                django-html-mode
                clojure-mode))
  (add-hook hook 'zencoding-hooks))

(setq vc-svn-diff-switches '("-x --ignore-eol-style" "-x -w"))

;; (defcustom buffer-stack-ignore-pattern-exceptions nil
;;   "see my-next-buffer for whatever is ignored when doing next-buffer & previous-buffer.  Good for things like *ielm* or *shell*"
;;   :group 'buffer-stack
;;   :type '(repeat string))

;; (defun buffer-stack-filter-ignore-function (buffer)
;;   (when (buffer-stack-filter-interesting-buffer-p (buffer-name buffer))
;;     t))

;; (defun buffer-stack-filter-interesting-buffer-p (name)
;;   (or
;;    (member name buffer-stack-ignore-pattern-exceptions)
;;    (not (string-match "^\*" name))
;;    ))

;; (setq buffer-stack-filter 'buffer-stack-filter-ignore-function)

;; This pushes the backup files into an invisible directory named .~ in the directory of the corresponding file
(setq backup-directory-alist '(("." . ".~")))

(desktop-save-mode 1)
(setq history-delete-duplicates t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(electric-pair-mode t)
(setq electric-pair-mode t) ;; add matching parens, braces, etc

;; print directory of file
(defun get-dir-of-file ()
  (interactive)
  (if (buffer-file-name)
      (replace-regexp-in-string "/[^/]+$" "" (buffer-file-name))))

;; prints dir of file and puts dir of file in kill ring
(defun copy-dir-of-file ()
  (interactive)
  (setq dir (get-dir-of-file))
  (if dir
      (kill-new dir))
  (message dir))

;;
(defun copy-region-to-scratch ()
  "opens up *scratch* and appends region to it"
  (interactive)
  (kill-ring-save (region-beginning) (region-end))
  (switch-to-buffer-other-window "*scratch*")
  (end-of-buffer)
  (yank)
  (newline)
  (other-window -1))

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

(setq column-number-mode t)
(require 'dired-x)
(setq dired-omit-files (concat dired-omit-files "^\\...+$" "\\|^\\..+$"))
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))

;;
(defun comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
        If no region is selected and current line is not blank and we are not at the end of the line,
        then comment current line.
        Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))

(defun revert-buffer-no-confirm ()
  "revert buffer without confirmation"
  (interactive)
  (revert-buffer t t))

;; http://unix.stackexchange.com/questions/20849/emacs-how-to-copy-region-and-leave-it-highlighted
(defun kill-ring-save-keep-highlight (beg end)
  "Keep the region active after the kill"
  (interactive "r")
  (prog1 (kill-ring-save beg end)
    (setq deactivate-mark nil)))

(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

;; do things when switching out of a buffer that edits a file
(defun on-window-switch ()
  (when buffer-file-name
    (evil-normal-state)))

(defun goto-line-with-feedback ()
  "If line numbers aren't displayed, show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (if linum-mode (goto-line (read-number "Goto line: "))
    (unwind-protect
        (progn
          (linum-mode 1)
          (goto-line (read-number "Goto line: ")))
      (linum-mode -1))))

;; (add-hook 'activate-mark-hook 'evil-normal-state)

(defun save-and-format-buffer ()
  "applies some formatting to a file then saves it"
  (interactive)
  (set-cursor-color "#ffffff")
  (when (and buffer-file-name (buffer-modified-p))
    (delete-trailing-whitespace)
    (save-buffer)))

(setq debug-on-error nil)

(defun split-window-right-and-make-active ()
  "creates new window to right and moves cursor there"
  (interactive)
  (split-window-right)
  (windmove-right))

(defun split-window-below-and-make-active ()
  "creates new window below and moves cursor there"
  (interactive)
  (split-window-below)
  (windmove-down))

;; http://stackoverflow.com/questions/4053708/emacs-desktop-doesnt-remember-tramp-connections
;; remember TRAMP connections
;; (setq desktop-files-not-to-save "^$")


;; http://stackoverflow.com/questions/13794433/how-to-disable-autosave-for-tramp-buffers-in-emacs
(setq tramp-auto-save-directory "~/emacs/tramp-autosave")

;; http://stackoverflow.com/questions/18812938/copy-full-file-path-into-copy-paste-clipboard
(defun copy-buffer-file-name-as-kill (choice)
  "Copy the buffer-file-name to the kill-ring"
  (interactive "cCopy Buffer Name (F) Full, (D) Directory, (N) Name")
  (let ((new-kill-string)
        (name (if (eq major-mode 'dired-mode)
                  (dired-get-filename)
                (or (buffer-file-name) ""))))
    (cond ((eq choice ?f)
           (setq new-kill-string name))
          ((eq choice ?d)
           (setq new-kill-string (file-name-directory name)))
          ((eq choice ?n)
           (setq new-kill-string (file-name-nondirectory name)))
          (t (message "Quit")))
    (when new-kill-string
      (message "%s copied" new-kill-string)
      (kill-new new-kill-string))))

;; (defun move-cursor-and-maintain-cursor-state (cursor-path)
;;   "if in evil-insert mode, move cursor and stay in evil-insert mode"
;;   (interactive)
;;   (let ((initial-state (format "%s" (evil-state-property evil-state :mode))))
;;     (setq some-fun (lambda () (message "do 1st thing") (message "do 2nd")))
;;     (funcall some-fun)
;;     (cond ((string= initial-state "evil-insert-state-minor-mode"))
;;           )
;;     (message (concat "state: " initial-state))))

(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "open-resource.el"))
(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "bindings.el"))
(setq-default c-basic-offset 2)
(setq-default indent-tabs-mode nil)
(setq js-indent-level 2)

(require 'paren) (show-paren-mode t)
(setq read-file-name-completion-ignore-case t)

;; give cp & sc files c-mode highlighting n schtuf
(require 'font-lock)
(global-font-lock-mode t)
(add-to-list 'auto-mode-alist '("\\.cp\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.sc\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.log\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.rw\\'" . sql-mode))

(defun indent-buffer ()
  "indents entire buffer"
  (interactive)
  (indent-region (point-min) (point-max)))

(defun flush-duplicate-blank-lines ()
  "replace multiple blank lines with a single one"
  (interactive)
  (goto-char (point-min))
  (replace-regexp "^\n\n+" "\n"))

;; diff mode
(eval-after-load 'diff-mode
  '(progn
     (set-face-foreground 'diff-added "green4")
     (set-face-foreground 'diff-added "red3")))
(setq ediff-diff-options "-w")
(setq ediff-split-window-function 'split-window-horizontally)

;; (set-frame-font "Source Code Pro 10" nil t)
;; (set-face-attribute 'default nil :font "Source Code Pro 9")

(set-frame-font "Monaco 9" nil t)
(set-face-attribute 'default nil :font "Monaco 9")

(setq column-number-mode 't)
(setq menu-bar-mode nil)
(setq global-linum-mode 't)

;; open 2 files as side-by-side windows
(defun 2-windows-vertical-to-horizontal ()
  (let ((buffers (mapcar 'window-buffer (window-list))))
    (when (= 2 (length buffers))
      (delete-other-windows)
      (set-window-buffer (split-window-horizontally) (cadr buffers)))))
(add-hook 'emacs-startup-hook '2-windows-vertical-to-horizontal)

;; if >1 window with same name, uniquify then with something better than <2>,<3>, ... etc
(require 'uniquify)
(setq uniquify-buffer-name-style (quote forward))

;; modeline customization
(menu-bar-mode -1)

;; automatically save buffers associated with files on buffer switch
;; and on windows switch
(defadvice switch-to-buffer (before save-buffer-now activate)
  (on-window-switch))
(defadvice other-window (before other-window-now activate)
  (on-window-switch))
(defadvice windmove-up (before other-window-now activate)
  (on-window-switch))
(defadvice windmove-down (before other-window-now activate)
  (on-window-switch))
(defadvice windmove-left (before other-window-now activate)
  (on-window-switch))
(defadvice windmove-right (before other-window-now activate)
  (on-window-switch))

;; hide-show stuff
(setq-default hs-minor-mode t)
(add-hook 'c-mode-common-hook (lambda() (hs-minor-mode 1)))
(defun hs-hide-all-comments ()
  "Hide all top level blocks, if they are comments, displaying only first line.
Move point to the beginning of the line, and run the normal hook
`hs-hide-hook'.  See documentation for `run-hooks'."
  (interactive)
  (hs-life-goes-on
   (save-excursion
     (unless hs-allow-nesting
       (hs-discard-overlays (point-min) (point-max)))
     (goto-char (point-min))
     (let ((spew (make-progress-reporter "Hiding all comment blocks..."
                                         (point-min) (point-max)))
           (re (concat "\\(" hs-c-start-regexp "\\)")))
       (while (re-search-forward re (point-max) t)
         (if (match-beginning 1)
             ;; found a comment, probably
             (let ((c-reg (hs-inside-comment-p)))
               (when (and c-reg (car c-reg))
                 (if (> (count-lines (car c-reg) (nth 1 c-reg)) 1)
                     (hs-hide-block-at-point t c-reg)
                   (goto-char (nth 1 c-reg))))))
         (progress-reporter-update spew (point)))
       (progress-reporter-done spew)))
   (beginning-of-line)
   (run-hooks 'hs-hide-hook)))

(set-frame-parameter (selected-frame) 'alpha '(93 85))

(require 'auto-highlight-symbol)
(setq global-auto-highlight-symbol-mode t) ;; at least alt+left/right conflicts with org-mode's bindings
(setq auto-highlight-symbol-mode t)
(setq ahs-chrange-whole-buffer t)

(put 'scroll-left 'disabled nil)

;; http://emacs.stackexchange.com/questions/7225/visual-selection-highlighting-invisible-with-evil-and-color-theme
;; (region ((t (:background "#1D1E2C"))))
;; (speedbar-file-face ((t (:foreground "#1D1E2C"))))

(setq global-hl-line-mode t)

;; https://github.com/magnars/.emacs.d/blob/master/defuns/buffer-defuns.el#L144-166
(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer.
Including indent-buffer, which should not be called automatically on save."
  (interactive)
  (untabify-buffer)
  (delete-trailing-whitespace)
  (indent-buffer))

(defun buffer-stack-filter-regexp (buffer)
  "Non-nil if buffer is in buffer-stack-tracked."
  (not (or (string-match "Help\\|html\\|helm\\|temp\\|Minibuf\\|Messages\\|Customize\\|Custom-Work\\|scratch\\|tram\\|Buffer" (buffer-name buffer))
           (member buffer buffer-stack-untracked))))

(setq jdk-directory "~/jdk/src/")

(setq tags-revert-without-query 't)

;; (load-file (concat (file-name-as-directory version-controlled-stuff-dir) "appearance.el"))

(add-to-list 'custom-theme-load-path "~/.emacs.d/elpa/monokai-theme-20150112.442/")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(2C-mode-line-format
   (quote
    ("dog" "-%*- %15b --"
     (-3 . "%p")
     "--%[(" mode-name minor-mode-alist "%n" mode-line-process ")%]%-")))
 '(Linum-format "%7i ")
 '(ahs-default-range (quote ahs-range-whole-buffer))
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#c0c0c0" "#336c6c" "#806080" "#0f2050" "#732f2c" "#23733c" "#6c1f1c" "#232333"])
 '(ansi-term-color-vector
   [unspecified "#081724" "#ff694d" "#68f6cb" "#fffe4e" "#bad6e2" "#afc0fd" "#d2f1ff" "#d3f9ee"] t)
 '(background-mode dark)
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(buffer-stack-filter (quote buffer-stack-filter-regexp))
 '(buffer-stack-ignore-pattern-exceptions (quote ("*ielm*" "*shell*")))
 '(buffer-stack-untracked
   (quote
    ("KILL" "*Compile-Log*" "*Compile-Log-Show*" "*Group*" "*Completions*" "*Messages*")))
 '(column-number-mode t)
 '(compilation-message-face (quote default))
 '(completion-ignored-extensions
   (quote
    (".o" "~" ".bin" ".lbin" ".so" ".a" ".ln" ".blg" ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".svn/" ".hg/" ".git/" ".bzr/" "CVS/" "_darcs/" "_MTN/" ".fmt" ".tfm" ".class" ".fas" ".lib" ".mem" ".x86f" ".sparcf" ".dfsl" ".pfsl" ".d64fsl" ".p64fsl" ".lx64fsl" ".lx32fsl" ".dx64fsl" ".dx32fsl" ".fx64fsl" ".fx32fsl" ".sx64fsl" ".sx32fsl" ".wx64fsl" ".wx32fsl" ".fasl" ".ufsl" ".fsl" ".dxl" ".lo" ".la" ".gmo" ".mo" ".toc" ".aux" ".fn" ".ky" ".pg" ".tp" ".vr" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo")))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(cursor-color "#cccccc")
 '(custom-enabled-themes (quote (monokai)))
 '(custom-safe-themes
   (quote
    ("4e262566c3d57706c70e403d440146a5440de056dfaeb3062f004da1711d83fc" default)))
 '(diary-entry-marker (quote font-lock-variable-name-face))
 '(dired-listing-switches
   "-lahBF --ignore=#* --ignore=.svn --ignore=.git --group-directories-first")
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(electric-pair-mode t)
 '(fci-rule-character-color "#202020")
 '(font-use-system-font t)
 '(foreground-color "#cccccc")
 '(fringe-mode 0 nil (fringe))
 '(global-auto-highlight-symbol-mode t)
 '(global-evil-search-highlight-persist t)
 '(global-linum-mode nil)
 '(global-undo-tree-mode t)
 '(gnus-logo-colors (quote ("#528d8d" "#c0c0c0")) t)
 '(golden-ratio-mode nil)
 '(grep-command "grep -n -e ")
 '(grep-find-command (quote ("find . -type f -exec grep -nHir -e  {} +" . 34)))
 '(grep-find-ignored-files
   (quote
    (".#*" "*.o" "*~" "*.bin" "*.lbin" "*.so" "*.a" "*.ln" "*.blg" "*.bbl" "*.elc" "*.lof" "*.glo" "*.idx" "*.lot" "*.fmt" "*.tfm" "*.class" "*.fas" "*.lib" "*.mem" "*.x86f" "*.sparcf" "*.dfsl" "*.pfsl" "*.d64fsl" "*.p64fsl" "*.lx64fsl" "*.lx32fsl" "*.dx64fsl" "*.dx32fsl" "*.fx64fsl" "*.fx32fsl" "*.sx64fsl" "*.sx32fsl" "*.wx64fsl" "*.wx32fsl" "*.fasl" "*.ufsl" "*.fsl" "*.dxl" "*.lo" "*.la" "*.gmo" "*.mo" "*.toc" "*.aux" "*.fn" "*.ky" "*.pg" "*.tp" "*.vr" "*.cps" "*.fns" "*.kys" "*.pgs" "*.tps" "*.vrs" "*.pyc" "*.pyo")))
 '(grep-find-template "find . <X> -type f <F> -exec grep <C> -nH -e <R> {} +")
 '(grep-highlight-matches (quote auto))
 '(grep-template "grep <X> <C> -n -e <R> <F>")
 '(grep-use-null-device t)
 '(helm-recentf-fuzzy-match t)
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#002b36" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   (quote
    (("#073642" . 0)
     ("#546E00" . 20)
     ("#00736F" . 30)
     ("#00629D" . 50)
     ("#7B6000" . 60)
     ("#8B2C02" . 70)
     ("#93115C" . 85)
     ("#073642" . 100))))
 '(hl-bg-colors
   (quote
    ("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00")))
 '(hl-fg-colors
   (quote
    ("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
 '(hl-paren-background-colors (quote ("#2492db" "#95a5a6" nil)))
 '(hl-paren-colors (quote ("#ecf0f1" "#ecf0f1" "#c0392b")))
 '(ispell-highlight-face (quote flyspell-incorrect))
 '(linum-format "%d ")
 '(magit-diff-use-overlays nil)
 '(magit-use-overlays nil)
 '(main-line-color1 "#1E1E1E")
 '(main-line-color2 "#111111")
 '(main-line-separator-style (quote chamfer))
 '(mode-line-format
   (quote
    (" " "%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position evil-mode-line-tag
     (elscreen-display-screen-number
      (" " elscreen-mode-line-string))
     (vc-mode vc-mode)
     "  " mode-line-modes mode-line-misc-info mode-line-end-spaces)))
 '(open-resource-ignore-patterns (quote ("/target/" "~$" ".old$" ".svn" "/bin/" ".class$")))
 '(org-startup-truncated nil)
 '(powerline-color1 "#1E1E1E")
 '(powerline-color2 "#111111")
 '(read-buffer-completion-ignore-case t)
 '(recentf-exclude (quote (".*ido\\.last" "/elpa/" ".*~$" ".*gz$")))
 '(recentf-keep (quote (recentf-keep-default-predicate)))
 '(recentf-max-saved-items 50)
 '(recentf-mode t)
 '(safe-local-variable-values (quote ((require-final-newline))))
 '(show-paren-mode t)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(syslog-debug-face
   (quote
    ((t :background unspecified :foreground "#A1EFE4" :weight bold))))
 '(syslog-error-face
   (quote
    ((t :background unspecified :foreground "#F92672" :weight bold))))
 '(syslog-hour-face (quote ((t :background unspecified :foreground "#A6E22E"))))
 '(syslog-info-face
   (quote
    ((t :background unspecified :foreground "#66D9EF" :weight bold))))
 '(syslog-ip-face (quote ((t :background unspecified :foreground "#E6DB74"))))
 '(syslog-su-face (quote ((t :background unspecified :foreground "#FD5FF0"))))
 '(syslog-warn-face
   (quote
    ((t :background unspecified :foreground "#FD971F" :weight bold))))
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(tool-bar-mode nil)
 '(vc-annotate-background "#202020")
 '(vc-annotate-color-map
   (quote
    ((20 . "#C99090")
     (40 . "#D9A0A0")
     (60 . "#ECBC9C")
     (80 . "#DDCC9C")
     (100 . "#EDDCAC")
     (120 . "#FDECBC")
     (140 . "#6C8C6C")
     (160 . "#8CAC8C")
     (180 . "#9CBF9C")
     (200 . "#ACD2AC")
     (220 . "#BCE5BC")
     (240 . "#CCF8CC")
     (260 . "#A0EDF0")
     (280 . "#79ADB0")
     (300 . "#89C5C8")
     (320 . "#99DDE0")
     (340 . "#9CC7FB")
     (360 . "#E090C7"))))
 '(vc-annotate-very-old-color "#E090C7")
 '(view-highlight-face (quote highlight))
 '(weechat-color-list
   (quote
    (unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83")))
 '(yas-snippet-dirs
   (quote
    (yas-installed-snippets-dir "/home/jason/.emacs.d/elpa/django-snippets-20131229.811/snippets")) nil (yasnippet)))

(setq cider-repl-history-file "~/.emacs.d/cider-history")
(setq my-background-color "grey6")
(set-background-color my-background-color)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-search-highlight-persist-highlight-face ((t (:inherit nil :background "yellow1" :foreground "black"))))
 '(helm-selection ((t (:inherit nil :inverse-video t :underline t))))
 '(highlight ((t (:background "lawn green" :foreground "black"))))
 '(linum ((t (:background "gray9" :foreground "#75715E"))))
 '(mode-line ((t (:background "white" :foreground "black"))))
 '(mode-line-buffer-id ((t (:foreground "black" :weight bold))))
 '(mode-line-highlight ((t (:box (:line-width 2 :color "grey40" :style released-button)))))
 '(mode-line-inactive ((t (:inherit mode-line :inverse-video t))))
 '(semantic-highlight-edits-face ((t (:background "gray21"))))
 '(show-paren-match ((t (:background "blue"))))
 '(term ((t (:inherit default :foreground "white smoke"))))
 '(zencoding-preview-output ((t (:background "dim gray")))))

;; package-activated-list
;; (2048-game ac-cider auto-complete popup cider queue pkg-info epl dash clojure-mode afternoon-theme ample-theme anything archive-region async auto-complete popup auto-highlight-symbol autopair badger-theme base16-theme bash-completion bliss-theme bookmark+ boron-theme buffer-move buffer-stack capture cider-decompile javap-mode cider queue pkg-info epl dash clojure-mode cider-profile cider queue pkg-info epl dash clojure-mode cider-spy dash cider queue pkg-info epl dash clojure-mode clojure-mode clues-theme company csv-mode ctags cyberpunk-theme dakrone-theme dark-krystal-theme elisp-slime-nav emacs-eclim s emacs-setup ess-R-data-view ess popup ctable ess-R-object-popup ess popup ess-smart-underscore ess evil-args evil goto-chg undo-tree evil-easymotion noflet ace-jump-mode evil-escape evil goto-chg undo-tree evil-exchange evil goto-chg undo-tree evil-jumper evil goto-chg undo-tree evil-lisp-state smartparens dash evil-leader evil goto-chg undo-tree evil goto-chg undo-tree evil-matchit evil-org evil goto-chg undo-tree evil-paredit paredit evil goto-chg undo-tree evil-search-highlight-persist highlight evil-snipe evil goto-chg undo-tree evil-space evil goto-chg undo-tree evil-surround evil-tabs elscreen evil goto-chg undo-tree evil-terminal-cursor-changer evil goto-chg undo-tree evil-tutor evil goto-chg undo-tree evil-visual-mark-mode dash evil goto-chg undo-tree evil-visualstar evil goto-chg undo-tree firecode-theme foreign-regexp gitlab request pkg-info epl dash s golden-ratio google goto-chg groovy-mode gruvbox-theme heroku highlight ido-at-point ido-complete-space-or-hyphen ido-gnus ido-hacks ido-load-library pcache persistent-soft list-utils pcache ido-select-window ido-sort-mtime ido-ubiquitous ido-vertical-mode jabber javap-mode jtags magit git-rebase-mode git-commit-mode markdown-mode monokai-theme multiple-cursors noflet paredit persistent-soft list-utils pcache pkg-info epl popup purple-haze-theme queue rainbow-delimiters regex-tool request s smart-mode-line rich-minority dash smartparens dash smyx-theme soothe-theme sr-speedbar subatomic256-theme sublime-themes tango-2-theme toxi-theme undo-tree waher-theme warm-night-theme window-number wrap-region dash yasnippet zen-and-art-theme zenburn-theme zonokai-theme)

 ;; '(eclim-eclipse-dirs (quote ("~/Programs/eclipse")))
 ;; '(eclim-executable "~/Programs/eclipse/eclim")