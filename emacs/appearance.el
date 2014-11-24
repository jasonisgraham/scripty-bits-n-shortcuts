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
(add-to-list 'auto-mode-alist '("\\.rw\\'" . sql-mode))

(defun indent-buffer ()
  "indents entire buffer"
  (interactive)
  (indent-region (point-min) (point-max)))

(defun single-lines-only ()
  "replace multiple blank lines with a single one"
  (interactive)
  (goto-char (point-min))
  (replace-regexp "^\n\n+" "\n"))

(defun save-and-format-buffer ()
  "applies some formatting to a file then saves it"
  (interactive)
  (delete-trailing-whitespace)
  ;; (indent-buffer)
  (set-cursor-color "#ffffff")
  (when buffer-file-name (save-buffer)))

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
 '(global-linum-mode nil)
 '(safe-local-variable-values (quote ((require-final-newline)))))

;; set font height
;; (set-face-attribute 'default nil :height 100)

(defun goto-line-with-feedback ()
  "If line numbers aren't displayed, show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (if linum-mode (goto-line (read-number "Goto line: "))
    (unwind-protect
        (progn
          (linum-mode 1)
          (goto-line (read-number "Goto line: ")))
      (linum-mode -1))))

(setq column-number-mode 't)
(setq menu-bar-mode nil)
(global-linum-mode nil)

;; ;; turn off line-num mode for certain things
;; (global-linum-mode 1)
;; (setq linum-mode-inhibit-modes-list '(eshell-mode
;;                                       shell-mode
;;                                       gnus-group-mode
;;                                       gnus-summary-mode
;;                                       gnus-article-mode
;;                                       sql-mode
;;                                       package-menu-mode
;;                                       Buffer-menu-mode
;;                                       cider-repl-mode
;;                                       messages-buffer-mode
;;                                       cider-stacktrace-mode))
;; (defadvice linum-on (around linum-on-inhibit-for-modes)
;;   "Stop the load of linum-mode for some major modes."
;;     (unless (member major-mode linum-mode-inhibit-modes-list)
;;       ad-do-it))
;; (ad-activate 'linum-on)

;; open 2 files as side-by-side windows
(defun 2-windows-vertical-to-horizontal ()
  (let ((buffers (mapcar 'window-buffer (window-list))))
    (when (= 2 (length buffers))
      (delete-other-windows)
      (set-window-buffer (split-window-horizontally) (cadr buffers)))))
(add-hook 'emacs-startup-hook '2-windows-vertical-to-horizontal)

;; if >1 window with same name, uniquify then with something better than <2>,<3>, ... etc
(require 'uniquify)
(setq uniquify-buffer-name-style (quote forward))

;; modeline customization
(menu-bar-mode -1)

;;
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
  (when buffer-file-name (viper-intercept-ESC-key) (save-buffer)))

;; automatically save buffers associated with files on buffer switch
;; and on windows switch
(defadvice switch-to-buffer (before save-buffer-now activate)
  (on-window-switch))
(defadvice other-window (before other-window-now activate)
  (on-window-switch))
(defadvice windmove-up (before other-window-now activate)
  (on-window-switch))
(defadvice windmove-down (before other-window-now activate)
  (on-window-switch))
(defadvice windmove-left (before other-window-now activate)
  (on-window-switch))
(defadvice windmove-right (before other-window-now activate)
  (on-window-switch))

;; hide-show stuff
;;(setq-default hs-minor-mode t)
(add-hook 'c-mode-common-hook (lambda() (hs-minor-mode 1)))
(defun hs-hide-all-comments ()
  "Hide all top level blocks, if they are comments, displaying only first line.
Move point to the beginning of the line, and run the normal hook
`hs-hide-hook'.  See documentation for `run-hooks'."
  (interactive)
  (hs-life-goes-on
   (save-excursion
     (unless hs-allow-nesting
       (hs-discard-overlays (point-min) (point-max)))
     (goto-char (point-min))
     (let ((spew (make-progress-reporter "Hiding all comment blocks..."
                                         (point-min) (point-max)))
           (re (concat "\\(" hs-c-start-regexp "\\)")))
       (while (re-search-forward re (point-max) t)
         (if (match-beginning 1)
             ;; found a comment, probably
             (let ((c-reg (hs-inside-comment-p)))
               (when (and c-reg (car c-reg))
                 (if (> (count-lines (car c-reg) (nth 1 c-reg)) 1)
                     (hs-hide-block-at-point t c-reg)
                   (goto-char (nth 1 c-reg))))))
         (progress-reporter-update spew (point)))
       (progress-reporter-done spew)))
   (beginning-of-line)
   (run-hooks 'hs-hide-hook)))

(set-frame-parameter (selected-frame) 'alpha '(98 90))

(global-auto-highlight-symbol-mode 1)
