
; open resource
(add-to-list 'load-path "~/.emacs.d/recentf.el")
(require 'recentf)
(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "open-resource.el"))
(setq open-resource-ignore-patterns (quote ("/target/" "~$" ".old$" ".svn")))

(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

;; (add-to-list 'load-path "~/.emacs.d/icicles/")
;;  (require 'icicles)
;; (icy-mode 1)

;; ;;
;; (add-to-list 'load-path "~/.emacs.d/elisp-slime-nav")
;; (require 'elisp-slime-nav)
;; (dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
;;   (add-hook hook 'elisp-slime-nav-mode))


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


