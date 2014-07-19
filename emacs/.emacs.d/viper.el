;; viper-mode
(setq viper-mode t)
(require 'viper)
(setq-default viper-want-emacs-keys-in-insert t)

; Override annoying stuff when in vi mode
(define-key viper-vi-basic-map (kbd "C-e") nil)
(define-key viper-vi-basic-map (kbd "C-f") nil)
(define-key viper-vi-basic-map (kbd "C-b") nil)

; Override annoying stuff when in "insert mode"
(define-key viper-insert-basic-map (kbd "C-w") nil)
(define-key viper-insert-basic-map (kbd "C-d") nil)
(define-key viper-insert-basic-map (kbd "C-y") nil)
(define-key viper-insert-basic-map (kbd "C-t") nil)
(define-key viper-insert-basic-map (kbd "TAB") nil)
(define-key viper-insert-basic-map (kbd "<tab>") nil) 

;; if window-system is "x" then dont do anything.  I don't really use emacs outside of the shell
;; Also, since I'm only using gnome-terminal, this will be particular to that too
(add-hook 'viper-insert-state-hook 'viper-set-cursor t)
(add-hook 'viper-emacs-state-hook 'viper-set-cursor t)
(add-hook 'viper-vi-state-hook 'viper-set-cursor t)

(defun viper-set-cursor ()
    "Set the cursor for a given state"
      ;; (message (format "%s" viper-current-state))
    
      (setq cursor-color "White")
      (cond
          ((eq viper-current-state 'emacs-state) (setq cursor-color "White"))
             ((eq viper-current-state 'vi-state) (setq cursor-color "Green"))
                ((eq viper-current-state 'insert-state) (setq cursor-color "Red")))
	(send-string-to-terminal (concat "\033]12;" cursor-color "\007"))
        ;(suspend-emacs (concat "gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape " cursor-shape "; fg\n"))
        (redraw-display)
      )


(defun viper-restore-cursor-type ()
     (viper-set-cursor))


; reset cursor color to white on exit of emacs
(add-hook 'kill-emacs-hook (lambda () (send-string-to-terminal "\033]12;White\007")))
