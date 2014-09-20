(setq version-controlled-stuff-dir "~/.emacs.d/version-controlled-stuff-dir")
(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "xclip.el"))
(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "formatting.el"))
(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "misc.el"))

(global-set-key "\M-j" 'backward-word)
(global-set-key "\M-J"	'backward-kill-word)
(global-set-key "\M-k"	'forward-word)
(global-set-key "\M-K"	'kill-word)
(global-set-key "\C-c\C-r"	'rgrep)
(global-set-key (kbd "C-<f12>")	'enlarge-window-horizontally)
(global-set-key (kbd "C-<f11>")	'shrink-window-horizontally)
(global-set-key (kbd "C-<f10>")	'enlarge-window)
(global-set-key (kbd "C-<f9>")	'shrink-window)
(global-set-key (kbd "\C-h")	'delete-backward-char)
(global-set-key (kbd "TAB")	'self-insert-command) ; insert a TAB when I say tab, yo
(global-set-key "\M-Gr"		'open-resource)
(global-set-key "\C-x\C-b"	'buffer-menu)
(global-set-key "\C-x\C-c" 	'nil)
(global-set-key "\M-Gke"	'kill-emacs) ;; remapping kill-emacs.  default \C-x\C-c is too easy to hit accidentally
(global-set-key "\M-G\M-S"	'shell-resync-dirs)  ;; use this when emacs shell gets out of sync with autocomplete
(global-set-key "\M-Gg"		'goto-line)

(global-set-key (kbd "M-G M-w M-x") (lambda() (interactive) (xclip-set-region-to-clipboard)))

;;
(global-set-key "\C-o" (lambda()
                         (interactive)
                         (newline-and-indent)
			 (previous-line)
                         (move-end-of-line nil)
                         (newline-and-indent)
                         ))

;; use this when you don't know where your cursor is.  once to enable.  again to disable
(global-set-key (kbd "<f6>") 'hl-line-mode)

(global-set-key "\C-xs" 'format-save-and-reset-cursor)
(global-set-key "\M-Gdd" (lambda() (interactive) (message (get-dir-of-file))))
(global-set-key "\M-Gdw" 'copy-dir-of-file)
(global-set-key (kbd "M-G M-w M-s") 'copy-region-to-scratch)

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (goto-line (read-number "Goto line: ")))
    (linum-mode -1)))
(global-set-key [remap goto-line] 'goto-line-with-feedback)

;; key-chord stuff
(require 'key-chord)
(key-chord-mode 1)
(key-chord-define-global "qb"	'save-buffer)
;; (key-chord-define-global "q9"	'windmove-left)
;; (key-chord-define-global "q0"	'windmove-right)
;; (key-chord-define-global "qn"	'windmove-down)
;; (key-chord-define-global "qp"	'windmove-up)
(key-chord-define-global "qo"	(lambda() (interactive) (save-buffer) (other-window -1)))

;; move lines up
(key-chord-define-global "ql" (lambda () (interactive) (join-line -1)))

;; window number stuff (used to jump between windows easily)
(global-set-key "\M-(" 'windmove-left)
(global-set-key "\M-)" 'windmove-right)
(global-set-key "\M-N" 'windmove-down)
(global-set-key "\M-P" 'windmove-up)

;; buffer-move
(global-set-key "\C-x\M-("  'buf-move-left)
(global-set-key "\C-x\M-)"  'buf-move-right)
(global-set-key "\C-x\M-N"  'buf-move-down)
(global-set-key "\C-x\M-P"  'buf-move-up)
