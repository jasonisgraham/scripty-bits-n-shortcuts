;; viper-mode
(setq viper-mode t)
(require 'viper)
(setq-default viper-want-emacs-keys-in-insert t)

(viper-record-kbd-macro "$" 'vi-state [ (control e) ] 't)
(setq viper-case-fold-search 't) ; viper search - case insensitive

(global-set-key (kbd "<f36>") 'enlarge-window-horizontally) ; f12
(global-set-key (kbd "<f35>") 'shrink-window-horizontally)  ; f11
(global-set-key (kbd "<f34>") 'enlarge-window) ; f10
(global-set-key (kbd "<f33>") 'shrink-window) ; f9

;; Override annoying stuff when in vi mode
(define-key viper-vi-basic-map (kbd "C-e") nil)
(define-key viper-vi-basic-map (kbd "C-f") nil)
(define-key viper-vi-basic-map (kbd "C-b") nil)

;; Override annoying stuff when in "insert mode"
(define-key viper-insert-basic-map (kbd "C-w") nil)
(define-key viper-insert-basic-map (kbd "C-d") nil)
(define-key viper-insert-basic-map (kbd "C-y") nil)
(define-key viper-insert-basic-map (kbd "C-t") nil)
(define-key viper-insert-basic-map (kbd "TAB") nil)
(define-key viper-insert-basic-map (kbd "<tab>") nil)
(define-key viper-insert-basic-map (kbd "<tab>") nil)

;; reset cursor color to white on exit of emacs
(add-hook 'kill-emacs-hook (lambda () (send-string-to-terminal "\033]12;White\007")))

(define-key viper-vi-global-user-map "o" (lambda() (interactive) (viper-open-line nil) (indent-relative)))

(define-key viper-vi-global-user-map "O" (lambda() (interactive) (viper-Open-line nil) (indent-relative)))

(set 'viper-fast-keyseq-timeout 0)
(set 'viper-no-multiple-ESC t)
(defun viper-translate-all-ESC-keysequences () t)
(set 'viper-ESC-keyseq-timeout 0)
