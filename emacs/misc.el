;; This pushes the backup files into an invisible directory named .~ in the directory of the corresponding file
(setq backup-directory-alist '(("." . ".~")))

(desktop-save-mode 1)
(setq history-delete-duplicates t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(electric-pair-mode t)
(setq electric-pair-mode t) ;; add matching parens, braces, etc

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
  (other-window -1))

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

(setq column-number-mode t)
(require 'dired-x)
(setq dired-omit-files (concat dired-omit-files "^\\...+$" "\\|^\\..+$"))
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))

;;
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

(defun revert-buffer-no-confirm ()
  "revert buffer without confirmation"
  (interactive)
  (revert-buffer t t))

;; http://unix.stackexchange.com/questions/20849/emacs-how-to-copy-region-and-leave-it-highlighted
(defun kill-ring-save-keep-highlight (beg end)
  "Keep the region active after the kill"
  (interactive "r")
  (prog1 (kill-ring-save beg end)
    (setq deactivate-mark nil)))

(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

;; do things when switching out of a buffer that edits a file
(defun on-window-switch ()
  (when buffer-file-name
    (evil-normal-state)))

(defun goto-line-with-feedback ()
  "If line numbers aren't displayed, show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (if linum-mode (goto-line (read-number "Goto line: "))
    (unwind-protect
        (progn
          (linum-mode 1)
          (goto-line (read-number "Goto line: ")))
      (linum-mode -1))))

;; (add-hook 'activate-mark-hook 'evil-normal-state)

(defun save-and-format-buffer ()
  "applies some formatting to a file then saves it"
  (interactive)
  (set-cursor-color "#ffffff")
  (when (and buffer-file-name (buffer-modified-p))
    (delete-trailing-whitespace)
    (save-buffer)))

(setq debug-on-error nil)

(defun split-window-right-and-make-active ()
  "creates new window to right and moves cursor there"
  (interactive)
  (split-window-right)
  (windmove-right))

(defun split-window-below-and-make-active ()
  "creates new window below and moves cursor there"
  (interactive)
  (split-window-below)
  (windmove-down))
