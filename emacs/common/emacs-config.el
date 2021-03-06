 ;; (setq debug-on-error t)
(setq debug-on-error nil)


(setq my-background-color "grey8")

(setq version-controlled-stuff-dir "~/scripty-bits-n-shortcuts/emacs")

(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "/common/package-init.el"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq path-to-ctags "~/.emacs.d/TAGS") ;; <- your ctags path here
(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "ctags -f %s -e -R %s" path-to-ctags (directory-file-name dir-name))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; open resource
;; (add-to-list 'load-path "~/.emacs.d/recentf.el")
(require 'recentf)
(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "open-resource.el"))
(setq open-resource-ignore-patterns (quote ("/target/" "~$" ".old$" ".svn")))

(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "transpose-frame.el"))

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

(defun reset-my-colors ()
  (interactive)
  (set-frame-parameter (selected-frame) 'alpha '(98 90))
  ;; (set-frame-parameter (selected-frame) 'alpha '(100 100))
  (set-background-color my-background-color))

(reset-my-colors)

;; elisp-slime-nav
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
  (add-hook hook 'elisp-slime-nav-mode))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

(setq yas-snippet-dirs (append yas-snippet-dirs  '("~/scripty-bits-n-shortcuts/emacs/snippets")))

;;; auto complete mod
;;; should be loaded after yasnippet so that they can work together
(auto-complete-mode 1)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
;; (ac-set-trigger-key "<tab>")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; lisp stuff
(require 'clj-refactor)

(require 'cider)
(add-hook 'clojure-mode-hook 'cider-mode)
(add-hook 'cider-interaction-mode-hook 'eldoc-mode)

(defun clojure-mode-hooks ()
  (interactive)
  (clj-refactor-mode 1)
  (yas-minor-mode 1) ; for adding require/use/import statements
  ;; This choice of keybinding leaves cider-macroexpand-1 unbound
  (cljr-add-keybindings-with-prefix "H-m")
  ;; (linum-mode 't)

  ;; (define-key clojure-mode-map (kbd "H-,") 'cider-test-run-tests)
  (define-key clojure-mode-map (kbd "H-,") 'cider-projectile-run-clojure-test)
  ;; (define-key clojure-mode-map (kbd "<f8>") 'cider-change-namespace-and-load-file)
  (define-key cider-mode-map (kbd "H-,") 'cider-projectile-run-clojure-test)

  (define-clojure-indent
    ;; compojure
    (defroutes 'defun)
    (GET 2)
    (POST 2)
    (PUT 2)
    (DELETE 2)
    (HEAD 2)
    (ANY 2)
    (context 2)

    ;; om
    (defui 1)
    (render 1)
    (query 1)
    (componentDidMount 1)
    (componentDidUpdate 1)
    (did-mount 1)))

(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'cider-mode-hook #'eldoc-mode)

(defun cider-repl-mode-hooks ()
  (interactive)
  (setq auto-highlight-symbol-mode nil))

(add-hook 'cider-repl-mode-hook #'eldoc-mode)
(add-hook 'cider-repl-mode-hook #'cider-mode)
(add-hook 'cider-repl-mode-hook #'cider-repl-mode-hooks)

(dolist (hook '(clojure-mode-hook
                cider-repl-mode
                cider-repl-mode-hook))
  (add-hook hook 'clojure-mode-hooks))

;; clojure/lispy stuff
(defun lisp-hooks ()
  (interactive)
  (enable-paredit-mode)
  ;; (paredit-mode t)
  (rainbow-delimiters-mode t)
  (define-key evil-insert-state-map "{" 'paredit-open-curly))

(eval-after-load 'clojure-mode '(require 'clojure-mode-extra-font-locking))
(eval-after-load 'clojurescript-mode '(require 'clojure-mode-extra-font-locking))

(setq clojure-defun-style-default-indent nil)
(setq cljr-favor-prefix-notation nil)
;; (setq clojure-defun-style-default-indent t)

;; (defvar endless/clojure-prettify-alist '())
;; (add-to-list 'endless/clojure-prettify-alist
;;              '(">=" . (?\s (Br . Bl) ?\s (Bc . Bc) ?≥)))
;; (add-to-list 'endless/clojure-prettify-alist
;;              '("<=" . (?\s (Br . Bl) ?\s (Bc . Bc) ?≤)))

(setq cider-repl-history-file "~/.emacs.d/cider-history")

(dolist (hook '(clojure-mode-hook
                emacs-lisp-mode-hook
                ielm-mode-hook
                cider-repl-mode
                cider-repl-mode-hook))

  (add-hook hook 'lisp-hooks)
  (add-hook hook 'clojure-mode-hooks)
  ;; (add-hook 'nrepl-mode-hook 'paredit-mode)
  ;; (define-key clojure-mode-map "{" 'paredit-open-curly)
  )

(setq cider-test-show-report-on-success nil)
(add-hook 'cider-mode-hook #'eldoc-mode)
(setq nrepl-log-messages t)
;; (setq nrepl-hide-special-buffers nil)
(setq cider-repl-display-in-current-window t)
(setq cider-repl-result-prefix ";;=> ")
(setq cider-prompt-save-file-on-load nil)
(setq cider-repl-use-pretty-printing t)
(setq cider-show-error-buffer t)
;; (setq cider-lein-parameters "with-profile +1.6 repl :headless")
;; add the pretty lambda symbols
(setq global-prettify-symbols-mode t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EVIL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'evil)
(evil-mode 1)

(require 'evil-surround)
(global-evil-surround-mode 1)

(require 'highlight)
(require 'evil-search-highlight-persist)
(global-evil-search-highlight-persist t)

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

;; when exiting insert mode, the cursor doesn't move back a column
(setq evil-move-cursor-back nil)
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
;; helm
;; http://tuhdo.github.io/helm-intro.html
;;;;;;;;;;;;;
(require 'helm)
(helm-mode 1)
(require 'helm-config)

(setq helm-M-x-fuzzy-match t)
(helm-autoresize-mode t)
;; ;; (setq helm-mini)
(setq helm-buffers-fuzzy-matching t)
(setq helm-recentf-fuzzy-match t)
(setq helm-semantic-fuzzy-match t)
(setq helm-imenu-fuzzy-match t)
(helm-autoresize-mode t)

;; (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
;; (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
;; (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

;; enables man page at point
;; (add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)
(semantic-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eclim                                ;;
;; https://github.com/senny/emacs-eclim ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'eclim)
;; (global-eclim-mode)
;; (require 'eclimd)

;; regular auto-complete initialization
(require 'auto-complete-config)
(ac-config-default)

;; add the emacs-eclim source
;; (require 'ac-emacs-eclim-source)
;; (ac-emacs-eclim-config)

;; configuring company-mode
(require 'company)
;; (require 'company-emacs-eclim)
;; (company-emacs-eclim-setup)
(global-company-mode t)
(setq company-idle-delay 1)
;; (company-quickhelp-mode 1)

;; (defun my/python-mode-hook ()
;;   (add-to-list 'company-backends 'company-jedi))

;; (add-hook 'python-mode-hook 'my/python-mode-hook)
;; (add-hook 'python-mode-hook 'run-python-internal)
;; (add-hook 'eclim-mode-hook (lambda ()
;;                              (global-set-key (kbd "M-C k") 'eclim-problems-correct)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ag-highlight-search t)
 '(ahs-case-fold-search nil)
 '(ahs-default-range (quote ahs-range-whole-buffer))
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(browse-url-browser-function (quote browse-url-chromium))
 '(buffer-stack-filter (quote buffer-stack-filter-regexp))
 '(buffer-stack-ignore-pattern-exceptions (quote ("*ielm*" "*shell*")))
 '(buffer-stack-untracked
   (quote
    ("KILL" "*Compile-Log*" "*Compile-Log-Show*" "*Group*" "*Completions*")))
 '(column-number-mode t)
 '(compilation-message-face (quote default))
 '(completion-ignored-extensions
   (quote
    (".o" "~" ".bin" ".lbin" ".so" ".a" ".ln" ".blg" ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".svn/" ".hg/" ".git/" ".bzr/" "CVS/" "_darcs/" "_MTN/" ".fmt" ".tfm" ".class" ".fas" ".lib" ".mem" ".x86f" ".sparcf" ".dfsl" ".pfsl" ".d64fsl" ".p64fsl" ".lx64fsl" ".lx32fsl" ".dx64fsl" ".dx32fsl" ".fx64fsl" ".fx32fsl" ".sx64fsl" ".sx32fsl" ".wx64fsl" ".wx32fsl" ".fasl" ".ufsl" ".fsl" ".dxl" ".lo" ".la" ".gmo" ".mo" ".toc" ".aux" ".fn" ".ky" ".pg" ".tp" ".vr" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo" ".log")))
 '(diary-entry-marker (quote font-lock-variable-name-face))
 '(dired-listing-switches
   "-lahBF --ignore=#* --ignore=.svn --ignore=.git --group-directories-first")
 ;;  '(eclim-eclipse-dirs (quote ("~/bin/eclipse")))
 ;; '(eclim-executable "~/bin/eclipse/eclim")
 '(ediff-split-window-function (quote split-window-horizontally) t)
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(electric-indent-mode t)
 ;; '(electric-pair-mode t)
 '(evil-default-cursor (quote (hbar)))
 '(global-anzu-mode t)
 '(global-auto-highlight-symbol-mode t)
 '(global-evil-search-highlight-persist t)
 '(global-undo-tree-mode t)
 ;; '(global-vi-tilde-fringe-mode t)
 '(golden-ratio-mode nil)
 '(grep-command "grep -n -e ")
 '(grep-find-command (quote ("find . -type f -exec grep -nHir -e  {} +" . 34)))
 '(grep-find-ignored-files
   (quote
    (".#*" "*.o" "*~" "*.bin" "*.lbin" "*.so" "*.a" "*.ln" "*.blg" "*.bbl" "*.elc" "*.lof" "*.glo" "*.idx" "*.lot" "*.fmt" "*.tfm" "*.class" "*.fas" "*.lib" "*.mem" "*.x86f" "*.sparcf" "*.dfsl" "*.pfsl" "*.d64fsl" "*.p64fsl" "*.lx64fsl" "*.lx32fsl" "*.dx64fsl" "*.dx32fsl" "*.fx64fsl" "*.fx32fsl" "*.sx64fsl" "*.sx32fsl" "*.wx64fsl" "*.wx32fsl" "*.fasl" "*.ufsl" "*.fsl" "*.dxl" "*.lo" "*.la" "*.gmo" "*.mo" "*.toc" "*.aux" "*.fn" "*.ky" "*.pg" "*.tp" "*.vr" "*.cps" "*.fns" "*.kys" "*.pgs" "*.tps" "*.vrs" "*.pyc" "*.pyo" "*.log")))
 '(grep-find-template "find . <X> -type f <F> -exec grep <C> -nH -e <R> {} +")
 '(grep-highlight-matches (quote auto))
 '(grep-template "grep <X> <C> -n -e <R> <F>")
 '(grep-use-null-device t)
 '(ispell-highlight-face (quote flyspell-incorrect))
 '(magit-diff-use-overlays nil)
 '(magit-use-overlays nil)
 '(main-line-separator-style (quote chamfer))
 '(open-resource-ignore-patterns (quote ("/target/" "~$" ".old$" ".svn" "/bin/" ".class$")))
 '(org-startup-truncated nil)
 '(projectile-enable-caching t)
 '(projectile-global-mode t)
 '(projectile-globally-ignored-directories
   (quote
    (".idea" ".eunit" ".git" ".hg" ".fslckout" ".bzr" "_darcs" ".tox" ".svn" ".repl" "target" "*compiled*" "*goog*" ".metadata" "*.metadata*")))
 '(projectile-globally-ignored-files (quote ("TAGS" ".gitignore" ".emacs.desktop" "*#*#" "*.xmi" "figwheel_server.log")))
 '(projectile-globally-ignored-file-suffixes (quote ("xmi")))
 '(read-buffer-completion-ignore-case t)
 '(recentf-exclude (quote (".*ido\\.last" "/elpa/" ".*~$" ".*gz$")))
 '(recentf-keep (quote (recentf-keep-default-predicate)))
 '(recentf-max-saved-items 50)
 '(recentf-mode t)
 '(safe-local-variable-values (quote ((require-final-newline))))
 '(tool-bar-mode nil)
 '(desktop-save t)
 '(desktop-save-mode t))

(setq global-diff-hl-mode t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(background-color my-background-color)
 '(default ((t (:family "Source Code Pro" :foundry "adobe" :slant normal :weight normal :height 98 :width normal))))
 '(anzu-mode-line ((t (:background "black" :foreground "white" :weight bold))))
 '(company-tooltip-common ((t (:inherit company-tooltip :weight bold :underline nil))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :weight bold :underline nil))))
 '(evil-search-highlight-persist-highlight-face ((t (:background "yellow" :foreground "black"))))
 '(highlight ((t (:background "lawn green" :foreground "black"))))
 '(highlight-indentation-current-column-face ((t (:background "gray13"))))
 '(highlight-indentation-face ((t (:background "gray14"))))
 '(show-paren-match ((t (:background "#272822" :inverse-video t :underline "cyan" :weight extra-bold))))
 '(sp-show-pair-match-face ((t (:background "green" :foreground "gray17" :underline "green" :weight extra-bold))))
 '(aw-leading-char-face
   ((t (:inherit ace-jump-face-foreground :height 3.0 :color "#49483E" :foreground "#49483E" :background "firebrick1")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; python stuff ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; make sure to run (run-python) https://github.com/bbatsov/prelude/issues/530
(autoload 'jedi:setup "jedi" nil t)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)
(setq jedi:complete-on-dot t)
(elpy-enable)

;; Python Hook
(add-hook 'python-mode-hook
          (function (lambda ()
                      (setq indent-tabs-mode nil
                            tab-width 2))))
(setq python-indent 2)

;; eval-in-repl
(require 'eval-in-repl)
(require 'eval-in-repl-python)
(define-key python-mode-map (kbd "H-e") 'eir-eval-in-python)

;; (when (require 'flycheck nil t)
;;   (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;;   (add-hook 'elpy-mode-hook 'flycheck-mode))
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
                ;; django-html-mode
                ;; clojure-mode
                ))
  (add-hook hook 'zencoding-hooks))
(add-hook 'zencoding-mode 'zencoding-hooks)

(setq vc-svn-diff-switches '("-x --ignore-eol-style" "-x -w"))

;; This pushes the backup files into an invisible directory named .~ in the directory of the corresponding file
(setq backup-directory-alist '(("." . ".~")))

(desktop-save-mode 1)
(setq history-delete-duplicates t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;; (electric-pair-mode t)
;; (setq electric-pair-mode t) ;; add matching parens, braces, etc

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
  (interactive "cCopy Buffer Name (f) Full, (d) Directory, (n) Name")
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

(setq-default c-basic-offset 2)
(setq-default indent-tabs-mode nil)
(setq js-indent-level 4)

(require 'paren)
(show-paren-mode t)
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
;; (eval-after-load 'diff-mode
;;   '(progn
;;      (set-face-foreground 'diff-added "green4")
;;      (set-face-foreground 'diff-added "red3")))
;; (setq ediff-diff-options "-w")
(setq ediff-diff-options "")
(setq ediff-split-window-function 'split-window-horizontally)

(setq column-number-mode 't)
(setq menu-bar-mode nil)

(setq linum-mode nil)
(require 'linum-relative)
(linum-relative-on)
(setq global-linum-mode nil)
(setq linum-mode nil)

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
(add-hook 'c-mode-common-hook
          (lambda()
            (hs-minor-mode 1)))

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

(require 'auto-highlight-symbol)
(setq global-auto-highlight-symbol-mode t) ;; at least alt+left/right conflicts with org-mode's bindings
(setq auto-highlight-symbol-mode t)
(auto-highlight-symbol-mode 1)
(setq ahs-chrange-whole-buffer t)

(put 'scroll-left 'disabled nil)

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
  (not (or (string-match "Help\\|html\\|helm\\|temp\\|Minibuf\\|Customize\\|Custom-Work\\|scratch\\|tram\\|Buffer\\|Echo\\|code-conversion-work\\|nrepl\\|WoMan-Log\\|cider-" (buffer-name buffer))
           (member buffer buffer-stack-untracked))))

(setq jdk-directory "~/jdk/src/")

(setq tags-revert-without-query 't)

;; (add-to-list 'custom-theme-load-path "/home/jason/scripty-bits-n-shortcuts/emacs/themes/jason-theme")

;; (load-file (concat (file-name-as-directory version-controlled-stuff-dir) "/common/bindings.el"))

(defun evil-normal-state-and-save-buffer ()
  (interactive)
  (evil-normal-state)
  (save-and-format-buffer))

(projectile-global-mode)
;; https://github.com/bbatsov/projectile/issues/496
(setq projectile-projects-cache (make-hash-table))
(setq projectile-enable-caching t)
(setq projectile-indexing-method 'alien)
;; (setq projectile-indexing-method 'native)

;; http://emacswiki.org/emacs/FullScreen
(defun toggle-fullscreen ()
  "Toggle full screen on X11"
  (interactive)
  (when (eq window-system 'x)
    (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth))))

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")



(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(require 'hl-anything)
(global-hl-line-mode 1)

;; http://emacswiki.org/emacs/TransposeWindows
(defun transpose-windows (arg)
  "Transpose the buffers shown in two windows."
  (interactive "p")
  (let ((selector (if (>= arg 0) 'next-window 'previous-window)))
    (while (/= arg 0)
      (let ((this-win (window-buffer))
            (next-win (window-buffer (funcall selector))))
        (set-window-buffer (selected-window) next-win)
        (set-window-buffer (funcall selector) this-win)
        (select-window (funcall selector)))
      (setq arg (if (plusp arg) (1- arg) (1+ arg))))))

(server-start)

(setq explicit-shell-file-name "/bin/bash")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; http://root42.blogspot.com/2014/08/how-to-automatically-refresh-cider-when.html ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'cider-mode-hook
          '(lambda () (add-hook 'after-save-hook
                                '(lambda ()
                                   (if (and (boundp 'cider-mode) cider-mode)
                                       nil ;; (cider-namespace-refresh)
                                       )))))
(defun cider-system-reset ()
  (interactive)
  (cider-interactive-eval
   "
(do
(require 'clojure.tools.namespace.repl)
(clojure.tools.namespace.repl/refresh)
(use 'clojure.repl)
(require '[reloaded.repl :refer [reset]])
)
"
))

(defun cider-namespace-refresh ()
  (interactive)
  (evil-normal-state-and-save-buffer)

  (cider-interactive-eval
   "
(do (require 'clojure.tools.namespace.repl)
  (clojure.tools.namespace.repl/refresh)
(use 'clojure.repl)
(require '[reloaded.repl :refer [reset]])
 (use 'reloaded.repl)
 (reloaded.repl/reset)
 (require 'user)
 (reset)
)
"))

(defun cider-save-and-rerun-test ()
  (interactive)
  (evil-normal-state-and-save-buffer)
  (cider-refresh)
  (cider-test-rerun-test))

;; (defun clojure-on-save ()
;;   (interactive)
;;   (cljr-clean-ns))

(add-hook 'clojure-mode-hook
          (lambda ()
            (define-key clojure-mode-map (kbd "<f5>") 'cider-namespace-refresh)
            (define-key evil-normal-state-map (kbd "qe") 'cider-eval-last-sexp)
            (define-key clojure-mode-map (kbd "H-r") 'cider-eval-region)
            (define-key clojure-mode-map (kbd "H-e") 'cider-eval-last-sexp)
            (define-key clojure-mode-map (kbd "<f8>") 'cider-eval-last-sexp)
            (define-key clojure-mode-map (kbd "<H-f1>") 'clojure-cheatsheet)
            (define-key clojure-mode-map (kbd "C-c d") 'cider-debug-defun-at-point)
            ;; (define-key clojure-mode-map (kbd "C-c .") "->> ")
            (define-key clojure-mode-map (kbd "C-c M-o") 'cider-repl-clear-buffer)
            (define-key clojure-mode-map (kbd "C-c C-p") 'cider-repl-previous-prompt)
            (auto-highlight-symbol-mode t)))

(add-hook 'clojure-mode-hook
          '(lambda () (add-hook 'after-save-hook
                                (lambda ()
                                  (if (and (boundp 'clojure-mode) clojure-mode)
                                      (cljr-clean-ns))))))
;; hotloader
(add-hook 'cider-mode-hook
          '(lambda () (add-hook 'after-save-hook
                                '(lambda ()
                                   (if (and (boundp 'cider-mode) cider-mode)
                                       (cider-system-reset))))))

(add-hook 'cider-mode-hook
          (lambda ()
            (define-key evil-normal-state-map (kbd "qe") 'cider-eval-last-sexp)
            (define-key clojure-mode-map (kbd "H-r") 'cider-eval-region)
            (define-key clojure-mode-map (kbd "H-e") 'cider-eval-last-sexp)
            (define-key clojure-mode-map (kbd "<f8>") 'cider-eval-last-sexp)
            (define-key clojure-mode-map (kbd "<H-f1>") 'clojure-cheatsheet)
            (define-key clojure-mode-map (kbd "C-c d") 'cider-debug-defun-at-point)
            ;; (define-key clojure-mode-map (kbd "C-c .") "->> ")
            (define-key clojure-mode-map (kbd "C-c M-o") 'cider-repl-clear-buffer)
            (define-key clojure-mode-map (kbd "C-c C-p") 'cider-repl-previous-prompt)
            (auto-highlight-symbol-mode t)))

;; (setq nrepl-hide-special-buffers t
;;       cider-repl-pop-to-buffer-on-connect t
;;       cider-popup-stacktraces t
;;       cider-repl-popup-stacktraces t
;;       nrepl-buffer-name-show-port t
;;       cider-auto-select-error-buffer nil
;;       cider-ovelays-use-font-lock t
;;       cider-repl-use-pretty-printing t)

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(setq org-todo-keywords
      '((sequence "TODO" "FEEDBACK" "VERIFY" "|" "DONE" "DELEGATED")))

(require 'volatile-highlights)
(volatile-highlights-mode t)

(require 'popwin)
(popwin-mode 1)

;; javascript
;; (add-hook 'js-mode-hook 'js2-minor-mode)
;; (add-hook 'js2-mode-hook 'ac-js2-mode)
;; (setq js2-highlight-level 3)
;; (define-key js-mode-map "{" 'paredit-open-curly)
;; (define-key js-mode-map "}" 'paredit-close-curly-and-newline)

;; (add-hook 'js2-mode-hook 'skewer-mode)
;; (add-hook 'css-mode-hook 'skewer-css-mode)
;; (add-hook 'html-mode-hook 'skewer-html-mode)

;; (add-hook 'js-mode-hook (lambda ()
;;                           (setq indent-tabs-mode t)
;;                           (setq tab-width 4)))

(set-frame-font "inconsolata 10" nil t)
(set-face-attribute 'default nil :font "inconsolata 10")
(set-face-attribute 'fringe nil :background my-background-color)
(set-face-attribute 'linum nil :background my-background-color)

(let ((non-public-stuff "~/.emacs.d/non-public-stuff.el"))
  (when (file-exists-p non-public-stuff)
    (load-file non-public-stuff)))

(vimish-fold-global-mode 1)

;; octave
(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1))))


(setq transient-mark-mode nil)
(defun cider-change-namespace-and-load-file ()
  )

(defun cider-projectile-run-clojure-test ()
  "If active buffer is test file, run tests.  If not test file, find that buffer and run test.  If not a file, re-run last test"
  (interactive)

  (if-let ((bfn (buffer-file-name)))
      (progn
        (when (null (->> (split-string bfn "/")
                         last
                         first
                         (string-match "_test.clj$")))

          ;; if not test file, open it if not open in new window, then make it active. no error checking
          (->> (projectile-find-implementation-or-test bfn)
               find-file-other-window))

        (cider-test-run-ns-tests 't))

    (cider-test-rerun-tests)))

(defun projectile-ag-regex (search-term &optional arg)
  "Like projectile-ag, but honors regexp.  This is only hear b/c I don't know elisp well enough to use prefix args

   Run an ag search with SEARCH-TERM in the project.

With an optional prefix argument ARG SEARCH-TERM is interpreted as a
regular expression."
  (interactive
   (list (read-from-minibuffer
          (projectile-prepend-project-name (format "Ag %ssearch for: " (if current-prefix-arg "regexp " "")))
          (projectile-symbol-at-point))
         current-prefix-arg))
  (if (require 'ag nil 'noerror)
      (let ((ag-command 'ag-regexp)

            ;; reset the prefix arg, otherwise it will affect the ag-command
            (current-prefix-arg nil))
        (funcall ag-command search-term (projectile-project-root)))
    (error "Package 'ag' is not available")))


;; (global-set-key (kbd "C-c p ^") (lambda ()
;;                                   (interactive)
;;                                   (find-file "project.clj")))

;; http://stackoverflow.com/questions/3815467/stripping-duplicate-elements-in-a-list-of-strings-in-elisp
(defun strip-duplicates (list)
  (let ((new-list nil))
    (while list
      (when (and (car list) (not (member (car list) new-list)))
        (setq new-list (cons (car list) new-list)))
      (setq list (cdr list)))
    (nreverse new-list)))

(indent-guide-global-mode)
(add-hook 'prog-mode-hook 'highlight-indentation-current-column-mode)

;; workspaces, tabs, perspective, stuff like that
(persp-mode)
(require 'persp-projectile)
(persp-turn-on-modestring)

(global-flycheck-mode)
;; https://github.com/flycheck/flycheck-pos-tip
(with-eval-after-load 'flycheck
  (flycheck-pos-tip-mode))

;; https://emacs.stackexchange.com/questions/34337/flycheck-gives-errors-when-i-use-shellcheck-as-linter-for-bash-scripts
(setq flycheck-shellcheck-follow-sources nil)

(defun print-major-mode ()
  (interactive)
  (message "%s" major-mode))

;; (require 'git-gutter-fringe+)
;; (global-git-gutter+-mode)
;; (setq git-gutter-fr+-side 'left-fringe)




;;;###autoload
(defun ag-project-files-current-current-file-extension (string)
  "like ag-project-files, but assumes the file pattern should match that of active buffer.
   Hacked ag/search to make this work.  will break if ag.el gets updated"
  (interactive (list (ag/read-from-minibuffer "Search string")))

  (if-let ((extension (and (buffer-file-name)
                           (file-name-extension (buffer-file-name)))))
      (ag/search string (ag/project-root default-directory) :file-ext extension)
    (ag-project-files)))

(reset-my-colors)

(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "/common/bindings.el"))

(load-file "~/.emacs.d/embrace.el/embrace.el")

;; (load-file "~/.emacs.d/./elpa/darkroom-0.1/darkroom.el")

(add-to-list 'company-backends 'company-elm)


;; typescript
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; ;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; ;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; ;; format options
(setq tide-format-options '(:insertSpaceAfterFunctionKeywordForAnonymousFunctions t :placeOpenBraceOnNewLineForFunctions nil))

(setq global-command-log-mode 't)



;; (eval-after-load 'flycheck '(flycheck-clojure-setup))
;; (add-hook 'after-init-hook #'global-flycheck-mode)

;; (eval-after-load 'flycheck
;;   '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))
;; (eval-after-load 'flycheck
;;   '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))

;; https://wiki.sagemath.org/devel/nonASCII
(defun non-ascii-char ()
  "Find the first non-ASCII character from point onwards."
  (interactive)
  (let (point)
    (save-excursion
      (setq point
            (catch 'non-ascii
              (while (not (eobp))
                (or (eq (char-charset (following-char))
                        'ascii)
                    (throw 'non-ascii (point)))
                (forward-char 1)))))
    (if point
        (goto-char point)
      (message "No non-ASCII characters."))))

;; (global-git-gutter+-mode)

;; (require 'git-gutter-fringe+)
;; (setq git-gutter-fr+-side 'right-fringe)
;; (setq git-gutter+-mode 't)
;; (global-git-gutter-mode+ +1)
;; (set-fringe-mode +10)

(global-visual-line-mode 1)
(global-hl-line-mode +1)
(set-face-background hl-line-face "gray15")


(provide 'emacs-config)
;;; emacs-config.el ends here
