(global-set-key "\M-j" 'backward-word)
(global-set-key "\M-J" 'backward-kill-word)
(global-set-key "\M-k" 'forward-word)
(global-set-key "\M-K" 'kill-word)
(global-set-key "\C-c\C-r" 'rgrep)
(global-set-key (kbd "C-<f12>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-<f11>") 'shrink-window-horizontally)
(global-set-key (kbd "C-<f10>") 'enlarge-window)
(global-set-key (kbd "C-<f9>") 'shrink-window)

(global-set-key (kbd "\C-h") 'delete-backward-char)
(global-set-key (kbd "\C-cm") 'menu-bar-open)
(global-set-key (kbd "TAB") 'self-insert-command) ; insert a TAB when I say tab, yo
(global-set-key "\M-Gr" 'open-resource)
(global-set-key "\C-x+" 'hs-show-block)
(global-set-key "\C-x-" 'hs-hide-block)
(global-set-key "\C-x\C-c" nil)

;; use this when you don't know where your cursor is.  once to enable.  again to disable
(global-set-key (kbd "<f6>") 'hl-line-mode)

;; requires formatting.el and viper.el would be good to have too
(global-set-key "\C-xs" 'format-save-and-reset-cursor)

(defun format-save-and-reset-cursor ()

  "applies some formatting to a file then saves it"
  (interactive)
  ;; save this point so it can be reset
  (setq originalpoint (point))
  (delete-trailing-whitespace)
  (indent-buffer)
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
  )
