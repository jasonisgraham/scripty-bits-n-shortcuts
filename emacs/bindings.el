(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "appearance.el"))
(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "misc.el"))

(global-set-key (kbd "C-h")	'delete-backward-char)
(global-set-key (kbd "M-G r")	'open-resource)
(global-set-key (kbd "C-x C-b")	'buffer-menu)
(global-set-key (kbd "H-M-8")	'buffer-menu)
(global-set-key (kbd "H-M-s")	'sr-speedbar-toggle)
(global-set-key (kbd "H-8")	'ido-switch-buffer)
(global-set-key (kbd "C-x C-c")	'nil) ;; default \C-x\C-c is too easy to hit accidentally
(global-set-key (kbd "M-G g")	'goto-line-with-feedback)
(global-set-key (kbd "M-;") 	'comment-dwim-line)
(global-set-key (kbd "C-c r") 	'revert-buffer-no-confirm)
(global-set-key (kbd "C-r")	'isearch-backward)
(global-set-key (kbd "H-r")	'rgrep)
(global-set-key (kbd "H-M-\\")	'indent-buffer)

(global-set-key (kbd "H-w")	'kill-ring-save-keep-highlight)
(global-set-key (kbd "H-j") 	'newline)
(global-set-key (kbd "H-SPC") 	'set-mark-command)
(global-set-key (kbd "C-c t t") 'toggle-truncate-lines)
(global-set-key (kbd "H-o") 	'dabbrev-expand)

(global-set-key (kbd "H-i") 	(lambda ()
                                  (interactive)
                                  (evil-normal-state)
                                  (save-and-format-buffer)))
(global-set-key (kbd "H-[")	'evil-normal-state)

;; requires elscree; nput some elscreen check here?
(global-set-key (kbd "H-v p") 	'elscreen-previous)
(global-set-key (kbd "H-9") 	'elscreen-previous)
(global-set-key (kbd "H-v n") 	'elscreen-next)
(global-set-key (kbd "H-0") 	'elscreen-next)
(global-set-key (kbd "H-v c") 	'elscreen-create)
(global-set-key (kbd "H-v k") 	'elscreen-kill)
(global-set-key (kbd "H-v f")	'elscreen-find-file)
(global-set-key (kbd "H-v '")	'elscreen-select-and-goto)
(global-set-key (kbd "H-v H-v")	'elscreen-toggle)
(global-set-key (kbd "H-v v")	'elscreen-toggle)
(global-set-key (kbd "H-v A")	'elscreen-screen-nickname)

(global-set-key (kbd "H-e") 	'eval-last-sexp)

(global-set-key (kbd "H-f")	'ido-find-file)
(global-set-key (kbd "H-4 f")	'ido-find-file-other-window)
(global-set-key (kbd "H-5 f")	'ido-find-file-other-frame)

(global-set-key (kbd "H-M--") 	'bury-buffer)
(global-set-key (kbd "H-M-h")	'buffer-stack-down)
(global-set-key (kbd "H-M-l")	'buffer-stack-up)
(global-set-key (kbd "H-p") 	'mode-line-other-buffer)
(global-set-key (kbd "H-M-p")	'other-frame)
(global-set-key (kbd "H-k") 	'kill-buffer)
(global-set-key (kbd "H-q") 	'kill-this-buffer) ;; doesn't seem to work for some reason?

;; use this when you don't know where your cursor is.  once to enable.  again to disable
(global-set-key (kbd "<f6>") 'hl-line-mode)
(global-set-key (kbd "H-n") 'toggle-numbers-with-symbols)

(global-set-key (kbd "M-G d d") (lambda()
                                  (interactive)
                                  (message (get-dir-of-file))))
(global-set-key (kbd "M-G d w") 'copy-dir-of-file)
(global-set-key (kbd "M-G M-w M-s") 'copy-region-to-scratch)

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
     (define-key paredit-mode-map (kbd "M-;") nil)
     (define-key paredit-mode-map (kbd "M-r") nil)))

;; TODO dont know if this works
(eval-after-load 'undo-tree
  '(progn
     (define-key undo-tree-map (kbd "C-r") nil)))

(defun toggle-numbers-with-symbols ()
  (interactive)
  ;; if we're using symbols, then use numbers
  (if __use-symbols
      (numberrow-use-numbers)
    (numberrow-use-symbols)))

(defun numberrow-use-symbols ()
  (interactive)
  (setq __use-symbols t)
  (keyboard-translate ?1 ?!)
  (keyboard-translate ?! ?1)
  (keyboard-translate ?2 ?@)
  (keyboard-translate ?@ ?2)
  (keyboard-translate ?3 ?#)
  (keyboard-translate ?# ?3)
  (keyboard-translate ?4 ?$)
  (keyboard-translate ?$ ?4)
  (keyboard-translate ?5 ?%)
  (keyboard-translate ?% ?5)
  (keyboard-translate ?6 ?^)
  (keyboard-translate ?^ ?6)
  (keyboard-translate ?7 ?&)
  (keyboard-translate ?& ?7)
  (keyboard-translate ?8 ?*)
  (keyboard-translate ?* ?8)
  (keyboard-translate ?9 ?\()
  (keyboard-translate ?\( ?9)
  (keyboard-translate ?0 ?\))
  (keyboard-translate ?\) ?0)
  (define-key evil-normal-state-map (kbd "qw)") 'delete-window)
  (define-key evil-normal-state-map (kbd "qw0") nil)
  (define-key evil-normal-state-map (kbd "qw!") 'delete-other-windows)
  (define-key evil-normal-state-map (kbd "qw1") nil))

(defun numberrow-use-numbers ()
  (interactive)
  (setq __use-symbols nil)
  (keyboard-translate ?1 ?1)
  (keyboard-translate ?! ?!)
  (keyboard-translate ?2 ?2)
  (keyboard-translate ?@ ?@)
  (keyboard-translate ?3 ?3)
  (keyboard-translate ?# ?#)
  (keyboard-translate ?4 ?4)
  (keyboard-translate ?$ ?$)
  (keyboard-translate ?5 ?5)
  (keyboard-translate ?% ?%)
  (keyboard-translate ?6 ?6)
  (keyboard-translate ?^ ?^)
  (keyboard-translate ?7 ?7)
  (keyboard-translate ?& ?&)
  (keyboard-translate ?8 ?8)
  (keyboard-translate ?* ?*)
  (keyboard-translate ?9 ?9)
  (keyboard-translate ?\( ?\()
  (keyboard-translate ?0 ?0)
  (keyboard-translate ?\) ?\))
  (define-key evil-normal-state-map (kbd "qw0") 'delete-window)
  (define-key evil-normal-state-map (kbd "qw)") nil)
  (define-key evil-normal-state-map (kbd "qw1") 'delete-other-windows)
  (define-key evil-normal-state-map (kbd "qw!") nil))

;; this is a function to toggle numbers with symbols.  e.g. 1 -> !, 2 -> @, ... 9 -> (, 0 -> )
(numberrow-use-numbers) ;; (setq __use-symbols nil)

(defun numberrow-mode-line-display-defun ()
  (if __use-symbols "<sym>" "<num>"))

(defvar numberrow-mode-line-display '(:eval (numberrow-mode-line-display-defun)))

(add-hook 'org-mode-hook (lambda ()
                           (interactive)
                           (define-key org-mode-map (kbd "M-S-<return>")	'org-insert-subheading)
                           (define-key org-mode-map (kbd "C-<return>")		'org-insert-heading-after-current)))

;; disable mouse clicks
;; (dolist (k '([mouse-1] [down-mouse-1]))
;;   (global-unset-key k))
(global-set-key (kbd "<down-mouse-1>") 'mouse-select-window)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; evil stuff
(define-key evil-normal-state-map (kbd "gw") nil)
(define-key evil-normal-state-map (kbd "gwh") 'split-window-right)
(define-key evil-normal-state-map (kbd "gwl") (lambda ()
                                                (interactive)
                                                (split-window-right)
                                                (windmove-right)))
(define-key evil-normal-state-map (kbd "gwk") 'split-window-below)
(define-key evil-normal-state-map (kbd "gwj") (lambda ()
                                                (interactive)
                                                (split-window-below)
                                                (windmove-down)))
;; (define-key evil-normal-state-map (kbd "gwn") 'winner-undo)
;; (define-key evil-normal-state-map (kbd "gwp") 'winner-redo)
;; (define-key evil-normal-state-map (kbd "gq") 'repeat)

(define-key evil-normal-state-map (kbd "qq") 'quit-window)
(define-key evil-normal-state-map (kbd "gp") 'elscreen-previous)
(define-key evil-normal-state-map (kbd "gn") 'elscreen-next)
(define-key evil-normal-state-map (kbd "gh") 'windmove-left)
(define-key evil-normal-state-map (kbd "gl") 'windmove-right)
(define-key evil-normal-state-map (kbd "gk") 'windmove-up)

(define-key evil-normal-state-map (kbd "gj") 'windmove-down)
(define-key evil-normal-state-map (kbd "gf") 'ido-find-file)
(define-key evil-normal-state-map (kbd "g-") 'hs-hide-block)
(define-key evil-normal-state-map (kbd "g+") 'hs-show-block)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
