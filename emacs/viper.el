;; viper-mode
(setq viper-mode t)
(setq viper-ESC-moves-cursor-back nil)
(require 'viper)

(setq-default viper-want-emacs-keys-in-insert t)

(viper-record-kbd-macro "$" 'vi-state [ (control e) ] 't)
(setq viper-case-fold-search 't) ; viper search - case insensitive
(setq viper-insert-state-cursor-color "Green")
(setq viper-emacs-state-cursor-color "Blue")


;; Override annoying stuff when in vi mode
(define-key viper-vi-basic-map (kbd "C-e") nil)
(define-key viper-vi-basic-map (kbd "C-f") nil)
(define-key viper-vi-basic-map (kbd "C-b") nil)
(define-key viper-vi-basic-map (kbd "C-m") 'newline)

;; Override annoying stuff when in "insert mode"
(define-key viper-insert-basic-map (kbd "C-w") nil)
(define-key viper-insert-basic-map (kbd "C-d") nil)
(define-key viper-insert-basic-map (kbd "C-y") nil)
(define-key viper-insert-basic-map (kbd "C-t") nil)
(define-key viper-insert-basic-map (kbd "TAB") nil)
(define-key viper-insert-basic-map (kbd "<tab>") nil)
(define-key viper-insert-basic-map (kbd "C-m") 'newline)

(set 'viper-fast-keyseq-timeout 0)
(set 'viper-no-multiple-ESC t)
(defun viper-translate-all-ESC-keysequences () t)
(set 'viper-ESC-keyseq-timeout 0)


(key-chord-define-global "m," (lambda() (interactive) (viper-intercept-ESC-key)
                                (when buffer-file-name (save-buffer))))
