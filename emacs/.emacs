(setq-default c-basic-offset 4)
(global-set-key "\M-j" 'backward-word)
(global-set-key "\M-J" 'backward-kill-word)
(global-set-key "\M-k" 'forward-word)
(global-set-key "\M-K" 'kill-word)
(global-set-key "\C-c\C-r" 'rgrep)
(global-set-key "\C-cu" 'uncomment-region)
(global-set-key (kbd "C-<f12>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-<f11>") 'shrink-window-horizontally)
(global-set-key (kbd "C-<f10>") 'enlarge-window)
(global-set-key (kbd "C-<f9>") 'shrink-window)
(global-set-key (kbd "\C-cc") 'comment-or-uncomment-region)
(global-set-key (kbd "\C-h") 'delete-backward-char)
(global-set-key (kbd "\C-cm") 'menu-bar-open)
;(global-set-key (kbd "\C-xh") 'help)
(global-set-key (kbd "TAB") 'self-insert-command) ; insert a TAB when I say tab, bitch
(require 'paren) (show-paren-mode t)
(setq read-file-name-completion-ignore-case t)


;; http://www.emacswiki.org/emacs/KeyboardMacrosTricks
(defun save-macro (name)                  
  "save a macro. Take a name as argument
     and save the last defined macro under 
     this name at the end of your .emacs"
  (interactive "SName of the macro :")  ; ask for the name of the macro    
  (kmacro-name-last-macro name)         ; use this name for the macro    
  (find-file (user-init-file))                   ; open ~/.emacs or other user init file 
  (goto-char (point-max))               ; go to the end of the .emacs
  (newline)                             ; insert a newline
  (insert-kbd-macro name)               ; copy the macro 
  (newline)                             ; insert a newline
  (switch-to-buffer nil))               ; return to the initial buffer
;; end http://www.emacswiki.org/emacs/KeyboardMacrosTricks

;; clojure
;(load "~/.emacs.d/init-clojure.el")

;; slime
;; (eval-after-load "slime" 
;;   '(progn (slime-setup '(slime-repl))))

;; (add-to-list 'load-path "~/opt/slime")
;; (require 'slime)
;; (slime-setup) 

; groovy mode
; (load "~/.emacs.d/init-groovy.el")

; multimode and aspx mode
;(load "~/.emacs.d/multi-mode.el")
;(load "~/.emacs.d/aspx-mode.el")

; php mode
(add-to-list 'load-path "~/elisp")
(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(defun clean-php-mode ()
(interactive)
(php-mode)
(setq c-basic-offset 4) ; 2 tabs i
(setq indent-tabs-mode nil)
(setq fill-column 78)
(c-set-offset 'case-label '+)
(c-set-offset 'arglist-close 'c-lineup-arglist-operators))
(c-set-offset 'arglist-intro '+)  
(c-set-offset 'arglist-cont-nonempty 'c-lineup-math)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

;(load "~/.emacs.d/nxhtml/autostart.el")
;(setq mumamo-background-colors nil)


; lispy things
;;; select db

; This pushes the backup files into an invisible directory named .~ in the directory of the corresponding file                                               
(setq backup-directory-alist '(("." . ".~")))



;;; turn on syntax highlighting
(global-font-lock-mode 1)

;;; use groovy-mode when file ends in .groovy or has #!/bin/groovy at start
;; (autoload 'groovy-mode "groovy-mode" "Major mode for editing Groovy code." t)
;; (add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
;; (add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

;; (load "~/.emacs.d/groovy-mode.el")
;; (load "~/.emacs.d/groovy-electric.el")
;; (load "~/.emacs.d/grails-mode.el")
;; (load "~/.emacs.d/inf-groovy.el")

;; ;;; make Groovy mode electric by default.
;; (add-hook 'groovy-mode-hook
;;           '(lambda ()
;;              (require 'groovy-electric)
;;              (groovy-electric-mode)))


;; ;; color theme - http://um3.blogspot.com/2011/07/emacs-on-cygwin.html
;; (add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0/")
;; (require 'color-theme) (color-theme-initialize) (color-theme-gray30)

;; (setq-default c-basic-offset 4)
;; (global-set-key "\M-j" 'backward-word)
;; (global-set-key "\M-J" 'backward-kill-word)
;; (global-set-key "\M-k" 'forward-word)
;; (global-set-key "\M-K" 'kill-word)
;; (global-set-key "\C-c\C-r" 'rgrep)
;; (global-set-key "\C-cu" 'uncomment-region)
;; (global-set-key (kbd "C-<f12>") 'enlarge-window-horizontally)
;; (global-set-key (kbd "C-<f11>") 'shrink-window-horizontally)
;; (global-set-key (kbd "C-<f10>") 'enlarge-window)
;; (global-set-key (kbd "C-<f9>") 'shrink-window)
;; (global-set-key (kbd "\C-cc") 'comment-or-uncomment-region)
;; (global-set-key (kbd "\C-h") 'delete-backward-char)
;; (global-set-key (kbd "\C-cm") 'menu-bar-open)
;; (global-set-key (kbd "\M-Xh") 'help)
;; (global-set-key (kbd "\C-ce")     (lambda()(interactive)(find-file "~/.emacs"))) ; open .emacs
;; (global-set-key (kbd "\C-cb")     (lambda()(interactive)(find-file "~/.bashrc"))) ; open .bashrc
;; (require 'paren) (show-paren-mode t)

(add-to-list 'auto-mode-alist
               '("\\.\\(?:gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist
               '("\\(Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . ruby-mode))