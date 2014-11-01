; This pushes the backup files into an invisible directory named .~ in the directory of the corresponding file
(setq backup-directory-alist '(("." . ".~")))

(desktop-save-mode 1)
(setq history-delete-duplicates t)
(global-linum-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(set-frame-parameter (selected-frame) 'alpha '(90 80))
(electric-pair-mode t)

;; print directory of file
(defun get-dir-of-file ()
  (interactive)
  (if (buffer-file-name)
      (replace-regexp-in-string "/[^/]+$" "" (buffer-file-name))))

;; prints dir of file and puts dir of file in kill ring
(defun copy-dir-of-file ()
  (interactive)
  (setq dir (get-dir-of-file))
  (if dir
      (kill-new dir))
  (message dir))

;;
(defun copy-region-to-scratch ()
  "opens up *scratch* and appends region to it"
  (interactive)
  (kill-ring-save (region-beginning) (region-end))
  (switch-to-buffer-other-window "*scratch*")
  (end-of-buffer)
  (yank)
  (newline)
  (other-window -1)
  )

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

(setq column-number-mode t)

;; when pasting from x clipboard strings that contained double quotes, funkiness would happen.  this fixes that (i think)
;;(setq x-select-enable-clipboard t)

(require 'dired-x)
(setq dired-omit-files (concat dired-omit-files "^\\...+$" "\\|^\\..+$"))
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))

;; add matching parens, braces, etc
(setq electric-pair-mode t)


(defun comment-dwim-line (&optional arg)
          "Replacement for the comment-dwim command.
        If no region is selected and current line is not blank and we are not at the end of the line,
        then comment current line.
        Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
          (interactive "*P")
          (comment-normalize-vars)
          (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
              (comment-or-uncomment-region (line-beginning-position) (line-end-position))
            (comment-dwim arg)))
      (global-set-key "\M-;" 'comment-dwim-line)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (defun toggle-fullscreen ()
;;   "From http://www.emacswiki.org/emacs/FullScreen.  Toggle full screen on X11.  Something like this is needed for v24.3"
;;   (interactive)
;;   (when (eq window-system 'x)
;;     (set-frame-parameter
;;      nil 'fullscreen
;;      (when (not (frame-parameter nil 'fullscreen)) 'fullboth))))

;; (global-set-key [f11] 'toggle-fullscreen)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
