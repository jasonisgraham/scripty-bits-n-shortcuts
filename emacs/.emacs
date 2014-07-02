(setq-default c-basic-offset 2)
(setq-default indent-tabs-mode nil)
(setq js-indent-level 2)
(global-set-key "\M-j" 'backward-word)
(global-set-key "\M-J" 'backward-kill-word)
(global-set-key "\M-k" 'forward-word)
(global-set-key "\M-K" 'kill-word)
(global-set-key "\C-c\C-r" 'rgrep)
(global-set-key (kbd "C-<f12>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-<f11>") 'shrink-window-horizontally)
(global-set-key (kbd "C-<f10>") 'enlarge-window)
(global-set-key (kbd "C-<f9>") 'shrink-window)
(global-set-key (kbd "\C-h") 'delete-backward-char)
(global-set-key (kbd "\C-cm") 'menu-bar-open)
(global-set-key (kbd "TAB") 'self-insert-command) ; insert a TAB when I say tab, yo
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

;;;;;;;;;;
; groovy mode
(load "~/.emacs.d/Emacs-Groovy-Mode/groovy-mode.el")
(load "~/.emacs.d/Emacs-Groovy-Mode/groovy-electric.el")
(load "~/.emacs.d/Emacs-Groovy-Mode/grails-mode.el")
(load "~/.emacs.d/Emacs-Groovy-Mode/inf-groovy.el")
;;; turn on syntax highlighting
(global-font-lock-mode 1)

;;; use groovy-mode when file ends in .groovy or has #!/bin/groovy at start
(autoload 'groovy-mode "groovy-mode" "Major mode for editing Groovy code." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

;;; make Groovy mode electric by default.
(add-hook 'groovy-mode-hook
          '(lambda ()
             (require 'groovy-electric)
             (groovy-electric-mode)))

; indentations
(defun my-c-mode-hook () 
   (setq indent-tabs-mode nil 
         c-basic-offset 4)) 
(add-hook 'c-mode-common-hook 'my-c-mode-hook) 
;;;;;;;;;;;;;;;;;;;;;;;

; This pushes the backup files into an invisible directory named .~ in the directory of the corresponding file                   
(setq backup-directory-alist '(("." . ".~")))

;;; turn on syntax highlighting
(global-font-lock-mode 1)

(add-to-list 'auto-mode-alist
               '("\\.\\(?:gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist
               '("\\(Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . ruby-mode))


; open resource
(add-to-list 'load-path "~/.emacs.d/recentf.el")
(require 'recentf)
(load "~/.emacs.d/open-resource.el")
(setq  open-resource-repository-directory "~/CMU/s3/Source ~/WebstormProjects/shart-finder/")
(setq open-resource-ignore-patterns (quote ("/target/" "~$" ".old$" ".svn")))
(global-set-key "\C-R" 'open-resource)


;; control lock
;; (load "~/.emacs.d/control-lock.el")
;; (require 'control-lock)
;; ; Make C-z turn on control lock                                        
;; (control-lock-keys)
;; end control lock
