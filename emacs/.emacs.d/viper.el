;; viper-mode
(setq viper-mode t)
(require 'viper)
(setq-default viper-want-emacs-keys-in-insert t)

;; (global-set-key (kbd "\C-xo")
;;                 (lambda()
;;                   (interactive)
;;                   (other-window -1)
;;                   (viper-set-cursor)))
;; (viper-record-kbd-macro "mm" 'vi-state [(meta x) s e t - m a r k return m p] 't)
(viper-record-kbd-macro "qq" 'insert-state [(meta x) v i p e r - e x i t - i n s e r t - s t a t e return] 't)
(viper-record-kbd-macro "$" 'vi-state [ (control e) ] 't)
(setq viper-case-fold-search 't) ; viper search - case insensitive

(global-set-key (kbd "<f36>") 'enlarge-window-horizontally) ; f12
(global-set-key (kbd "<f35>") 'shrink-window-horizontally)  ; f11
(global-set-key (kbd "<f34>") 'enlarge-window) ; f10
(global-set-key (kbd "<f33>") 'shrink-window) ; f9

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
;; (add-hook 'viper-insert-state-hook 'viper-set-cursor t)
;; (add-hook 'viper-emacs-state-hook 'viper-set-cursor t)
;; (add-hook 'viper-vi-state-hook 'viper-set-cursor t)

;; (defun viper-set-cursor ()
;;   "Set the cursor for a given state"
;;   ;; (message (format "%s" viper-current-state))

;;   (setq foreground "Black")
;;   (setq background "White")

;;   (cond
;;    ((eq viper-current-state 'emacs-state) (setq foreground "White") (setq background "Black"))
;;    ((eq viper-current-state 'vi-state) (setq foreground "Black") (setq background "Green"))
;;    ((eq viper-current-state 'insert-state) (setq foreground "Green") (setq background "Black"))

;;    )
;;   (set-face-attribute 'mode-line nil :foreground foreground :background background)
;;   )


;; (defun viper-restore-cursor-type ()
;;   (viper-set-cursor))


;; (defun color-by-mode (misc-info) (setq cursor-color "White")
;;   (cond
;;    ((string= "<E>" misc-info) (setq cursor-color "Blue"))
;;    ((string= "<V>" misc-info) (setq cursor-color "Green"))
;;    ((string= "<I>" misc-info) (setq cursor-color "Yellow"))) (message cursor-color))

;; (setq mode-line-format (quote ("dog" (color-by-mode mode-line-misc-info) "man" )))

;; (setq mode-line-format (quote("" mode-line-misc-info " dogman")))
;; (message (format "%s" mode-line-format)) ; "( mode-line-misc-info  dogman)"
;; (setq mode-line-format '("%e" mode-line-misc-info "  dogman"))

;; (defun get-mode-line-background-color ()
;;   (setq cursor-color "White")
;; 	(cond
;;           ((eq viper-current-state 'emacs-state) (setq cursor-color "Blue"))
;;              ((eq viper-current-state 'vi-state) (setq cursor-color "Green"))
;;                 ((eq viper-current-state 'insert-state) (setq cursor-color "Yellow")))
;;         (message cursor-color)
;;   )

;; (set-face-attribute 'mode-line-inactive nil :foreground "black" :background (lambda()
;;                                                                               (interactive)
;;   (setq cursor-color "White")
;; 	(cond
;;           ((eq viper-current-state 'emacs-state) (setq cursor-color "Blue"))
;;              ((eq viper-current-state 'vi-state) (setq cursor-color "Green"))
;;                 ((eq viper-current-state 'insert-state) (setq cursor-color "Yellow")))
;;         (message cursor-color)
;;   ))
                                        ;(set-face-attribute 'mode-line nil :foreground "black" :background "green")
                                        ;(custom-set-faces '(mode-line ((t (:background "green" :foreground "black")))))

; reset cursor color to white on exit of emacs
(add-hook 'kill-emacs-hook (lambda () (send-string-to-terminal "\033]12;White\007")))
