(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "appearance.el"))
(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "misc.el"))

(global-set-key (kbd "M-j") 	'backward-word)
(global-set-key (kbd "M-k")	'forward-word)
(global-set-key (kbd "C-h")	'delete-backward-char)
;; (global-set-key (kbd "TAB")	'self-insert-command) ; insert a TAB when I say tab, yo
(global-set-key (kbd "M-G r")	'open-resource)
(global-set-key (kbd "C-x C-b")	'buffer-menu)
(global-set-key (kbd "H-M-8")	'buffer-menu)
(global-set-key (kbd "H-8")	'ido-switch-buffer)
(global-set-key (kbd "C-x C-c")	'nil) ;; default \C-x\C-c is too easy to hit accidentally
(global-set-key (kbd "M-G k e")	'kill-emacs) ;; remapping kill-emacs.
(global-set-key (kbd "M-G g")	'goto-line-with-feedback)
(global-set-key (kbd "M-;") 	'comment-dwim-line)
(global-set-key (kbd "C-c r") 	'revert-buffer-no-confirm)

(global-set-key (kbd "H-w")	'kill-ring-save-keep-highlight)
(global-set-key (kbd "H-j") 	'newline)
(global-set-key (kbd "H-SPC") 	'set-mark-command)
(global-set-key (kbd "H-c t t") 'toggle-truncate-lines)

(global-set-key (kbd "H-i") 	'vi-mode-exit-insert-mode-with-hooks)
(global-set-key (kbd "H-;") 	'vi-mode-exit-insert-mode-with-hooks)
(global-set-key (kbd "C-;") 	'vi-mode-exit-insert-mode-with-hooks)

(global-set-key (kbd "H-p") 	'mode-line-other-buffer)
(global-set-key (kbd "H-k") 	'kill-buffer)
(global-set-key (kbd "H-M-k") 	'kill-this-buffer)

;; use this when you don't know where your cursor is.  once to enable.  again to disable
(global-set-key (kbd "<f6>") 'hl-line-mode)

(global-set-key (kbd "M-G d d") (lambda() (interactive) (message (get-dir-of-file))))
(global-set-key (kbd "M-G d w") 'copy-dir-of-file)
(global-set-key (kbd "M-G M-w M-s") 'copy-region-to-scratch)

;; key-chord stuff
;; (require 'key-chord)
;; (key-chord-mode 1)

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
(global-set-key (kbd "M-G h C") 'hs-hide-all-comments)
(global-set-key (kbd "M-G s B") 'hs-show-all)
(global-set-key (kbd "M-G s b") 'hs-show-block)
(global-set-key (kbd "M-G h b") 'hs-hide-block)

;; Override this paredit keybindings
(eval-after-load 'paredit
  '(progn
     (define-key paredit-mode-map (kbd "M-J") nil)
     (define-key paredit-mode-map (kbd "M-;") nil )))

