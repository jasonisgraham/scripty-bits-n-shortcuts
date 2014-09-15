(setq-default c-basic-offset 2)
(setq-default indent-tabs-mode nil)
(setq js-indent-level 2)

(require 'paren) (show-paren-mode t)
(setq read-file-name-completion-ignore-case t)

;; give cp & sc files c-mode highlighting n schtuf
(require 'font-lock)
(global-font-lock-mode t)
(add-to-list 'auto-mode-alist '("\\.cp\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.sc\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.log\\'" . sh-mode))

;; remove trailing whitespace on save
(add-hook 'after-save-hook (lambda() (delete-trailing-whitespace)))

(defun indent-buffer ()
  "indents entire buffer"
  (interactive)
  (indent-region (point-min) (point-max))
  )

(defun single-lines-only ()
  "replace multiple blank lines with a single one"
  (interactive)
  (goto-char (point-min))
  (replace-regexp "^\n\n+" "\n")
  )

(defun format-save-and-reset-cursor ()

  "applies some formatting to a file then saves it"
  (interactive)
  ;; save this point so it can be reset
  (setq originalpoint (point))
  (delete-trailing-whitespace)
  ;;(indent-buffer)
  (single-lines-only)
  (save-buffer)

  ;; if viper mode is enabled, reset to "vi-state"
  (if (boundp 'viper-current-state)
      (viper-exit-insert-state)
    (cond
     ((eq viper-current-state 'insert-state) (viper-exit-insert-state))
     ))

  ;; return cursor to original point
  (goto-char originalpoint)
  (shell-resync-dirs)
  )


;; diff mode
(eval-after-load 'diff-mode
	'(progn
           (set-face-foreground 'diff-added "green4")
           (set-face-foreground 'diff-added "red3")))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "white" :foreground "black"))))
 '(mode-line-inactive ((t (:inherit mode-line :inverse-video t)))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-startup-truncated nil)
 '(read-buffer-completion-ignore-case t)
 '(safe-local-variable-values (quote ((require-final-newline)))))
