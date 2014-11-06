(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "appearance.el"))
(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "misc.el"))

(global-set-key "\M-j" 'backward-word)
;; (global-set-key "\M-J"	'backward-kill-word)
(global-set-key "\M-k"	'forward-word)
;; (global-set-key "\M-K"	'kill-word)
;; (global-set-key "\C-c\C-r"	'rgrep)
;; (global-set-key (kbd "C-<f12>")	'enlarge-window-horizontally) ; C-x }
;; (global-set-key (kbd "C-<f11>")	'shrink-window-horizontally) ; C-x {
;; (global-set-key (kbd "C-<f10>")	'enlarge-window) ; C-x ^
;; (global-set-key (kbd "C-<f9>")	'shrink-window)
(global-set-key (kbd "\C-h")	'delete-backward-char)
(global-set-key (kbd "TAB")	'self-insert-command) ; insert a TAB when I say tab, yo
(global-set-key "\M-Gr"		'open-resource)
(global-set-key "\C-x\C-b"	'buffer-menu)
(global-set-key "\C-x\C-c" 	'nil) ;; default \C-x\C-c is too easy to hit accidentally
(global-set-key "\M-Gke"	'kill-emacs) ;; remapping kill-emacs.
(global-set-key "\M-Gg"		'goto-line)
(global-set-key (kbd "<f4>") 'save-buffer)
(global-set-key "\M-;" 'comment-dwim-line)

;; use this when you don't know where your cursor is.  once to enable.  again to disable
(global-set-key (kbd "<f6>") 'hl-line-mode)

(global-set-key "\C-xs" 'format-save-and-reset-cursor)
(global-set-key "\M-Gdd" (lambda() (interactive) (message (get-dir-of-file))))
(global-set-key "\M-Gdw" 'copy-dir-of-file)
(global-set-key (kbd "M-G M-w M-s") 'copy-region-to-scratch)

;; key-chord stuff
(require 'key-chord)
(key-chord-mode 1)
(key-chord-define-global "qm" 'set-mark-command)
(key-chord-define-global "qb" 'switch-to-buffer)
(key-chord-define-global "qt" 'toggle-truncate-lines)
(key-chord-define-global "qq" (lambda()
                                (interactive)
                                (save-and-format-buffer)
                                (viper-intercept-ESC-key)))
(key-chord-define-global "qj" (lambda ()
                                "move lines up"
                                (interactive)
                                (join-line -1)))

;; window number stuff (used to jump between windows easily)
(global-set-key (kbd "M-H") 'windmove-left)
(global-set-key (kbd "M-L") 'windmove-right)
(global-set-key (kbd "M-K") 'windmove-up)
(global-set-key (kbd "M-J") 'windmove-down)

;; buffer-move
(global-set-key (kbd "C-c M-H")  'buf-move-left)
(global-set-key (kbd "C-c M-L")  'buf-move-right)
(global-set-key (kbd "C-c M-K")  'buf-move-up)
(global-set-key (kbd "C-c M-J")  'buf-move-down)

;; toggle menu-bar-mode
(global-set-key (kbd "C-M-S-<f1>") 'menu-bar-mode)

;; toggle comments n stuff
(global-set-key "\M-GhC" 'hs-hide-all-comments)
(global-set-key "\M-GsB" 'hs-show-all)
(global-set-key "\M-Gsb" 'hs-show-block)
(global-set-key "\M-Ghb" 'hs-hide-block)
