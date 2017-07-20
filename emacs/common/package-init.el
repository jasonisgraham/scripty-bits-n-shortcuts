(setq package-list '(elisp-slime-nav

		      linum-relative

                     ;; zencoding-mode
                     yasnippet auto-complete
                     vimish-fold
                     ;; clojure/lisps
                     clj-refactor clojure-mode rainbow-delimiters
                     clojure-mode-extra-font-locking clojure-quick-repls clojure-snippets

                     nrepl-eval-sexp-fu
                     ac-cider
                     cider cider-decompile cider-eval-sexp-fu cider-profile cider-spy
                     eval-in-repl
                     buffer-stack

                     ;;
                     magit
                     key-chord
                     gitconfig-mode
                     docker dockerfile-mode
                     sr-speedbar

                     ;; misc modes
                     yaml-mode
                     markdown-mode
                     groovy-mode
                     projectile

                     ;; display stuff
                     volatile-highlights
                     rainbow-blocks  rainbow-identifiers rainbow-mode
                     org-bullets org-beautify-theme
                     highlight-parentheses hl-anything
                     highlight-numbers
                     f
                     ;;  emacs-eclim
                     company
                     ag))

;; melpa
(require 'package)

(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

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
