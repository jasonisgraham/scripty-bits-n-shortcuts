(setq package-list '(4clojure request ac-cider auto-complete popup cider seq spinner queue pkg-info epl clojure-mode ac-etags ac-octave ace-link avy ace-window adaptive-wrap ag s dash aggressive-indent alect-themes anything-exuberant-ctags anything archive-region auto-dictionary auto-highlight-symbol autopair badger-theme bash-completion bliss-theme bookmark+ boron-theme buffer-move buffer-stack busybee-theme capture cider-decompile javap-mode cider-eval-sexp-fu eval-sexp-fu highlight cider-profile cider-spy clean-aindent-mode clj-refactor hydra inflections edn peg multiple-cursors paredit yasnippet cljsbuild-mode clojure-cheatsheet helm helm-core async clojure-mode-extra-font-locking clojure-quick-repls clojure-snippets csv-mode ctags ctags-update cyberpunk-theme dakrone-theme darcula-theme dark-krystal-theme define-word diff-hl docker magit-popup docker-tramp dockerfile-mode elisp-slime-nav elpy pyvenv highlight-indentation find-file-in-project swiper company elscreen-multi-term multi-term elscreen elscreen-persist revive elscreen-separate-buffer-list emacs-eclim emacs-setup esh-help eshell-prompt-extras eval-in-repl evil-anzu anzu evil goto-chg undo-tree evil-args evil-easymotion evil-escape evil-exchange evil-iedit-state iedit evil-indent-textobject evil-jumper evil-lisp-state smartparens evil-leader evil-matchit evil-nerd-commenter evil-numbers evil-org org evil-paredit evil-search-highlight-persist evil-snipe evil-space evil-surround evil-tabs evil-terminal-cursor-changer evil-tutor evil-visual-mark-mode evil-visualstar exec-path-from-shell expand-region fancy-battery fill-column-indicator firebelly-theme firecode-theme fish-mode flx-ido flx flycheck-pos-tip flycheck let-alist foreign-regexp gh-md git-messenger git-timemachine gitattributes-mode gitconfig-mode gitlab gnuplot golden-ratio google-translate grandshell-theme groovy-mode gruvbox-theme guide-key-tip pos-tip guide-key popwin helm-ag helm-anything helm-aws helm-backup helm-c-yasnippet helm-chrome helm-company helm-css-scss helm-descbinds helm-dictionary helm-dirset f helm-flycheck helm-flymake helm-flyspell helm-git helm-git-files helm-git-grep helm-gitignore gitignore-mode helm-google google helm-helm-commands helm-make projectile helm-mode-manager helm-package helm-projectile helm-pydoc helm-swoop helm-themes heroku hexrgb highlight-numbers parent-mode highlight-parentheses hl-anything htmlize hungry-delete ido-at-point ido-complete-space-or-hyphen ido-gnus ido-hacks ido-load-library pcache persistent-soft list-utils ido-select-window ido-sort-mtime ido-ubiquitous ido-completing-read+ ido-vertical-mode indent-guide info+ jedi-direx direx jedi jedi-core python-environment deferred epc ctable concurrent jtags julia-mode key-chord leuven-theme linum-relative lush-theme macrostep magit-gitflow magit git-commit with-editor markdown-toc markdown-mode material-theme mmm-mode molokai-theme monokai-theme move-text neotree noflet nrepl-eval-sexp-fu open-junk-file org-beautify-theme org-bullets org-plus-contrib org-pomodoro alert log4e gntp org-present org-repo-todo org-trello dash-functional request-deferred page-break-lines paradox pcre2el perspective popup-complete popup-kill-ring popup-switcher powerline-evil powerline purple-haze-theme python-django python-mode quelpa package-build rainbow-blocks rainbow-delimiters rainbow-identifiers rainbow-mode regex-tool rich-minority shell-pop skewer-mode js2-mode simple-httpd skype smeargle smooth-scrolling smyx-theme soothe-theme spacemacs-theme spray sr-speedbar subatomic256-theme sublime-themes tango-2-theme toc-org toxi-theme use-package diminish bind-key vi-tilde-fringe vimish-fold virtualenv visual-regexp-steroids visual-regexp volatile-highlights waher-theme warm-night-theme web-mode which-key window-number window-numbering workgroups2 anaphora wrap-region yaml-mode zen-and-art-theme zenburn-theme zencoding-mode zonokai-theme))

;; melpa
(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

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
