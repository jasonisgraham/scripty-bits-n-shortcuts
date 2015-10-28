(setq package-list '(perspective 4clojure request ac-cider auto-complete popup cider seq spinner queue pkg-info epl clojure-mode ac-etags ac-octave ag s dash anything-exuberant-ctags anything archive-region autopair badger-theme bash-completion bliss-theme bookmark+ boron-theme buffer-stack capture cider-decompile javap-mode cider-eval-sexp-fu eval-sexp-fu highlight cider-profile cider-spy clj-refactor hydra inflections edn peg multiple-cursors paredit yasnippet cljsbuild-mode clojure-cheatsheet helm helm-core async clojure-mode-extra-font-locking clojure-quick-repls clojure-snippets csv-mode ctags ctags-update darcula-theme dark-krystal-theme docker magit-popup docker-tramp dockerfile-mode elpy pyvenv highlight-indentation find-file-in-project swiper company multi-term revive emacs-eclim emacs-setup eval-in-repl evil-easymotion avy evil-org evil goto-chg undo-tree evil-paredit evil-snipe evil-space evil-tabs evil-terminal-cursor-changer evil-visual-mark-mode firecode-theme fish-mode flycheck-pos-tip flycheck let-alist foreign-regexp gitlab groovy-mode gruvbox-theme guide-key-tip pos-tip guide-key popwin helm-anything helm-aws helm-backup helm-c-yasnippet helm-chrome helm-company helm-css-scss helm-dictionary helm-dirset f helm-flycheck helm-flymake helm-flyspell helm-git helm-git-files helm-git-grep helm-google google helm-helm-commands helm-package helm-pydoc heroku hexrgb ido-at-point ido-complete-space-or-hyphen ido-gnus ido-hacks ido-load-library pcache persistent-soft list-utils ido-select-window ido-sort-mtime ido-ubiquitous ido-completing-read+ jedi-direx direx jedi jedi-core python-environment deferred epc ctable concurrent jtags julia-mode key-chord magit with-editor markdown-mode material-theme molokai-theme monokai-theme noflet nrepl-eval-sexp-fu smartparens org-beautify-theme org-bullets org-trello dash-functional request-deferred popup-complete popup-kill-ring popup-switcher powerline-evil powerline purple-haze-theme python-django python-mode rainbow-blocks rainbow-identifiers rainbow-mode regex-tool rich-minority skewer-mode js2-mode simple-httpd skype smyx-theme soothe-theme sr-speedbar subatomic256-theme sublime-themes tango-2-theme toxi-theme vimish-fold virtualenv visual-regexp-steroids visual-regexp waher-theme warm-night-theme web-mode window-number wrap-region yaml-mode zen-and-art-theme zenburn-theme zencoding-mode zonokai-theme window-numbering which-key volatile-highlights vi-tilde-fringe use-package diminish bind-key spray spacemacs-theme smooth-scrolling rainbow-delimiters quelpa package-build pcre2el paradox page-break-lines open-junk-file neotree move-text macrostep linum-relative leuven-theme info+ indent-guide ido-vertical-mode hungry-delete highlight-parentheses highlight-numbers parent-mode helm-themes helm-swoop helm-projectile projectile helm-mode-manager helm-make helm-descbinds helm-ag google-translate golden-ratio flx-ido flx fill-column-indicator fancy-battery expand-region exec-path-from-shell evil-visualstar evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-matchit evil-lisp-state evil-leader evil-jumper evil-indent-textobject evil-iedit-state iedit evil-exchange evil-escape evil-args evil-anzu anzu elisp-slime-nav define-word clean-aindent-mode buffer-move auto-highlight-symbol auto-dictionary aggressive-indent adaptive-wrap ace-window ace-link))

;; melpa
(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
;; (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

(setq package-enable-at-startup nil)
(package-initialize)

(defun installed-packages ()
  "Returns list of packages currently installed"
  (strip-duplicates package-activated-list))

(defun uninstalled-packages ()
  "Returns list of packages not installed"
  (delq nil
        (mapcar (lambda (x) (and (not (package-installed-p x)) x)) package-list)))

(defun all-packages-installed-p ()
  "Returns true is all expected packages are installed.  false otherwise"
  (null (uninstalled-packages)))

(defun install-uninstalled-packages ()
  (unless (all-packages-installed-p)
    (package-refresh-contents)
    ;; install the missing packages
    (dolist (package (uninstalled-packages))
      (package-install package))))

(install-uninstalled-packages)
