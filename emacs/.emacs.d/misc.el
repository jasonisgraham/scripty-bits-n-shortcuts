; This pushes the backup files into an invisible directory named .~ in the directory of the corresponding file
(setq backup-directory-alist '(("." . ".~")))

(desktop-save-mode 1)
(setq history-delete-duplicates t)
;(global-linum-mode 1)

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
