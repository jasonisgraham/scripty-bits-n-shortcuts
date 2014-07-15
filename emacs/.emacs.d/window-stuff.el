
;; window number stuff (used to jump between windows easily)
(load "~/.emacs.d/window-number.el")
(require 'window-number)
(window-number-mode)
(global-set-key (kbd "<f9>") 'window-number-switch)
(global-set-key "\M-(" 'windmove-left)
(global-set-key "\M-)" 'windmove-right)
(global-set-key "\M-N" 'windmove-down)
(global-set-key "\M-P" 'windmove-up)


;; open 2 files as side-by-side windows 
(defun 2-windows-vertical-to-horizontal ()
  (let ((buffers (mapcar 'window-buffer (window-list))))
    (when (= 2 (length buffers))
      (delete-other-windows)
      (set-window-buffer (split-window-horizontally) (cadr buffers)))))
(add-hook 'emacs-startup-hook '2-windows-vertical-to-horizontal)