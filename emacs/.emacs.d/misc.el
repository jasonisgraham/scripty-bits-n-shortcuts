; This pushes the backup files into an invisible directory named .~ in the directory of the corresponding file
(setq backup-directory-alist '(("." . ".~")))

(desktop-save-mode 1)
