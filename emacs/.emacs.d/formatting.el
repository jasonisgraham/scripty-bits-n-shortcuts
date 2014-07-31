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
