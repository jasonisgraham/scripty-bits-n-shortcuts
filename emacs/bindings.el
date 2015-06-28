;; Hyper & control duplicates while i get used to swapping Ctrl + Hyper
(global-set-key (kbd "H-z")     'repeat)
(global-set-key (kbd "C-M-*")   'buffer-menu)
(global-set-key (kbd "H-*")     'ido-switch-buffer)
(global-set-key (kbd "H-8")     'helm-mini)
(global-set-key (kbd "H-y")     'helm--kill-ring)
(global-set-key (kbd "H-r")     'rgrep)
(global-set-key (kbd "H-M-\\")  'indent-buffer)
(global-set-key (kbd "H-d")     'ediff-buffers)
(global-set-key (kbd "H-w")     'kill-ring-save-keep-highlight)
(global-set-key (kbd "H-o j")   'evil-next-line-first-non-blank)
(global-set-key (kbd "H-o k")   'evil-previous-line-first-non-blank)
(global-set-key (kbd "H-<f6>")  'load-file)
;; (setq local-function-key-map (delq '(kp-tab . [9]) local-function-key-map))
(global-set-key (kbd "C-;")     'evil-normal-state-and-save-buffer)

;; requires elscree; nput some elscreen check here?
(global-set-key (kbd "H-(")     'elscreen-previous)
(global-set-key (kbd "H-)")     'elscreen-next)
(global-set-key (kbd "H-v c")   'elscreen-create)
(global-set-key (kbd "H-v k")   'elscreen-kill)
(global-set-key (kbd "H-v f")   'elscreen-find-file)
(global-set-key (kbd "H-v '")   'elscreen-select-and-goto)
(global-set-key (kbd "H-v H-v") 'elscreen-toggle)
(global-set-key (kbd "H-v v")   'elscreen-toggle)
(global-set-key (kbd "H-v A")   'elscreen-screen-nickname)

(global-set-key (kbd "H-e")     'eval-last-sexp)

(global-set-key (kbd "H-$ f")   'ido-find-file-other-window)

(global-set-key (kbd "H-M--")   'bury-buffer)
(global-set-key (kbd "H-M-h")   'buffer-stack-down)
(global-set-key (kbd "H-M-l")   'buffer-stack-up)
(global-set-key (kbd "H-p")     'mode-line-other-buffer)
(global-set-key (kbd "H-M-p")   'other-frame)
(global-set-key (kbd "H-k")     'kill-buffer)
(global-set-key (kbd "H-q")     'kill-this-buffer) ;; doesn't seem to work for some reason?

(global-set-key (kbd "<f11>") 	'toggle-fullscreen)
(global-set-key (kbd "C-h")     'delete-backward-char)
(global-set-key (kbd "M-G r")   'open-resource)
(global-set-key (kbd "C-x C-b") 'buffer-menu)

;; (global-set-key (kbd "M-k")     'keyboard-quit)
(global-set-key (kbd "M-x")     'helm-M-x)
(global-set-key [C-tab]         'dabbrev-expand)

(global-set-key (kbd "C-x C-c") 'nil) ;; default \C-x\C-c is too easy to hit accidentally
(global-set-key (kbd "M-G g")   'goto-line-with-feedback)
(global-set-key (kbd "M-;")     'comment-dwim-line)
(global-set-key (kbd "C-c M-;")	'comment-box)
(global-set-key (kbd "C-c r")   'revert-buffer-no-confirm)
(global-set-key (kbd "C-r")     'isearch-backward)
(global-set-key (kbd "M-C k")   'flyspell-correct-word-before-point)
(global-set-key (kbd "M-5")     'query-replace)
(global-set-key (kbd "M-%")     'digit-argument)


(global-set-key (kbd "C-<f12>") 'sr-speedbar-toggle)

(global-set-key (kbd "C-c t t") 'toggle-truncate-lines)

;; use this when you don't know where your cursor is.  once to enable.  again to disable
(global-set-key (kbd "<f6>") 'hl-line-mode)
(global-set-key (kbd "<f5>") 'linum-mode)
(global-set-key (kbd "<H-f7>") 'desktop-change-dir)

(global-set-key (kbd "M-G d d") (lambda()
                                  (interactive)
                                  (message (get-dir-of-file))))
(global-set-key (kbd "M-G d w") 'copy-buffer-file-name-as-kill)
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
(global-set-key (kbd "C-c SPC") 'ace-jump-mode)

;; Override this paredit keybindings
(eval-after-load 'paredit
  '(progn
     (define-key paredit-mode-map (kbd "M-J") nil)
     (define-key paredit-mode-map (kbd "M-;") nil)
     (define-key paredit-mode-map (kbd "M-r") nil)
     (define-key paredit-mode-map (kbd "M--") nil)))

(defun zencoding-hooks ()
  (define-key zencoding-mode-map (kdb "C-j" nil))
  (define-key zencoding-mode-map (kdb "M-C k" 'zencoding-expand-line)))

;; Override these cuz really all I want is the symbols to be highlighted
(eval-after-load 'auto-highlight-symbol
  '(progn
     (define-key auto-highlight-symbol-mode-map (kbd "M--") nil)))

(eval-after-load 'undo-tree
  '(progn
     (define-key undo-tree-map (kbd "C-r") nil)))

(add-hook 'org-mode-hook
          (lambda ()
            (interactive)
            ;; (setq flyspell-mode t)
            (define-key org-mode-map (kbd "M-S-<return>") 'org-insert-subheading)
            (define-key org-mode-map (kbd "C-<return>")   'org-insert-heading-after-current)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; evil stuff
(define-key evil-normal-state-map (kbd "gw") nil)
(define-key evil-normal-state-map (kbd "gwh") 'split-window-right)
(define-key evil-normal-state-map (kbd "gwl") 'split-window-right-and-make-active)
(define-key evil-normal-state-map (kbd "gwk") 'split-window-below)
(define-key evil-normal-state-map (kbd "gwj") 'split-window-below-and-make-active)

(define-key evil-normal-state-map (kbd "gr") 'repeat)

(define-key evil-normal-state-map (kbd "qq") 'quit-window)
(define-key evil-normal-state-map (kbd "gn") 'elscreen-previous)
(define-key evil-normal-state-map (kbd "gp") 'elscreen-next)
(define-key evil-normal-state-map (kbd "gh") 'windmove-left)
(define-key evil-normal-state-map (kbd "gl") 'windmove-right)
(define-key evil-normal-state-map (kbd "gk") 'windmove-up)
(define-key evil-normal-state-map (kbd "gj") 'windmove-down)
(define-key evil-normal-state-map (kbd "g-") 'hs-hide-block)
(define-key evil-normal-state-map (kbd "g+") 'hs-show-block)

(define-key evil-normal-state-map (kbd "gf")  'ido-find-file)
(define-key evil-normal-state-map (kbd "g SPC") 'ace-jump-mode)

(define-key evil-normal-state-map (kbd "qw)") 'delete-window)
(define-key evil-normal-state-map (kbd "qw!") 'delete-other-windows)

(define-key evil-normal-state-map (kbd "g*")  'ido-switch-buffer)
(define-key evil-insert-state-map (kbd "M-j") 'newline-and-indent)
(define-key evil-normal-state-map (kbd "qm")  'evil-record-macro)
(define-key evil-normal-state-map (kbd "g@")  'er/expand-region)
(define-key evil-insert-state-map (kbd "C-;") 'evil-normal-state-and-save-buffer)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; do with H-j, M-j what you could do with <return> but less pink moving
(let ((map minibuffer-local-map))
  (define-key map (kbd "M-j") 'exit-minibuffer)
  (define-key map (kbd "M-k") 'abort-recursive-edit))

;;
(key-chord-mode 1)
(setq key-chord-two-keys-delay 0.05)
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
(key-chord-define evil-insert-state-map "q-" "_")
(key-chord-define evil-insert-state-map "qg" 'evil-execute-in-normal-state)
(key-chord-define evil-insert-state-map "q)" 'evil-digit-argument-or-evil-beginning-of-line)


;; Magit rules!
(global-set-key (kbd "C-x g") 'magit-status)

;; c1,c2 -> will put these each on own line
(fset 'sql-one-select-column-per-line
      [?/ ?, ?. return ?l ?i return escape])

;; will replace 'alias = table.column' with 'table.column AS alias'.  'alias' needs to be only one word.  'table.column' needs to be followed by a comma
(fset 'ingres-equals-to-oracle-as
      [?f ?= ?x ?d ?B ?A ?\C-b ?  ?A ?S ?\S-  ?\C-y escape])

(global-set-key (kbd "C-c H-r") 'transpose-windows)

;; disable mouse clicks
(dolist (k '([mouse-1] [down-mouse-1] [drag-mouse-1] [double-mouse-1] [triple-mouse-1]
             [mouse-2] [down-mouse-2] [drag-mouse-2] [double-mouse-2] [triple-mouse-2]
             [mouse-3] [down-mouse-3] [drag-mouse-3] [double-mouse-3] [triple-mouse-3]))
  (global-unset-key k))
;; (global-set-key (kbd "<down-mouse-1>") 'mouse-select-window)

;;;;;;;;;;;;;;;;;
;; hydra stuff ;;
;;;;;;;;;;;;;;;;;

;; https://www.reddit.com/r/emacs/comments/3ba645/does_anybody_have_any_real_cool_hydras_to_share/cskdhte
(defhydra hydra-windows (:hint nil)
  "
          Split: _|_:vert  _-_:horz
         Delete: !:other )_:curr
  Switch Window: _h_:left  _j_:down  _k_:up  _l_:right
        Buffers: _p_revious  _n_ext  _b_:select  _f_ind-file  _F_projectile _R_:helm-mini _K_ill-buffer
         Winner: _u_ndo  _r_edo
         Resize: _H_:splitter left  _J_:splitter down  _K_:splitter up  _L_:splitter right
           Move: _a_:up  _z_:down  _i_menu"

  ("z" scroll-up-line)
  ("a" scroll-down-line)
  ("i" idomenu)

  ("u" winner-undo)
  ("r" winner-redo)

  ("h" windmove-left)
  ("j" windmove-down)
  ("k" windmove-up)
  ("l" windmove-right)

  ("M-h" buf-move-left nil)
  ("M-l" buf-move-right nil)
  ("M-k" buf-move-up nil)
  ("M-j" buf-move-down nil)

  ("p" previous-buffer)
  ("n" next-buffer)
  ("b" ido-switch-buffer)
  ("f" ido-find-file)
  ("F" projectile-find-file)
  ("R" helm-mini)
  ("K" kill-this-buffer)

  ("-" split-window-below)
  ("|" split-window-right)

  (")" delete-window)
  ("!" delete-other-windows)

  ("H" hydra-move-splitter-left)
  ("J" hydra-move-splitter-down)
  ("K" hydra-move-splitter-up)
  ("L" hydra-move-splitter-right)

  ("q" nil))

(global-set-key (kbd "C-*")     'hydra-windows/body)
