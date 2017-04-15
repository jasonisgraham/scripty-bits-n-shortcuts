;;; package --- Summary

;;; Commentary:

;;; Code:
;; Hyper & control duplicates while i get used to swapping Ctrl + Hyper
(global-set-key (kbd "H-z")     'repeat)
(global-set-key (kbd "<f9>")     'repeat)
(global-set-key (kbd "C-M-8")   'buffer-menu)
;; (global-set-key (kbd "H-*")     'ido-switch-buffer)
(global-set-key (kbd "C-8")     'helm-mini)
(global-set-key (kbd "H-8")     'ido-switch-buffer)
(global-set-key (kbd "H-y")     'helm--kill-ring)
(global-set-key (kbd "H-r")     'rgrep)
(global-set-key (kbd "H-M-\\")  'indent-buffer)
(global-set-key (kbd "H-d")     'ediff-buffers)
(global-set-key (kbd "H-w")     'kill-ring-save-keep-highlight)
(global-set-key (kbd "H-o j")   'evil-next-line-first-non-blank)
(global-set-key (kbd "H-o k")   'evil-previous-line-first-non-blank)
(global-set-key (kbd "H-<f6>")  'load-file)
(global-set-key (kbd "C-;")     'evil-normal-state-and-save-buffer)
;; (global-set-key (kbd "<f12>")	  'evil-normal-state-and-save-buffer)

;; workspaces n stuff
;; (global-set-key (kbd "H-9")     'wg-switch-to-workgroup-left)
;; (global-set-key (kbd "H-0")     'wg-switch-to-workgroup-right)
;; (global-set-key (kbd "H-'")     'wg-switch-to-workgroup)

(global-set-key (kbd "H-9")     'persp-prev)
(global-set-key (kbd "H-0")     'persp-next)
(global-set-key (kbd "H-'")     'persp-switch)
(global-set-key (kbd "H-P")     'persp-switch-last)

(global-set-key (kbd "H-e")     'eval-last-sexp)

(global-set-key (kbd "H-4 f")   'ido-find-file-other-window)

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
;; (global-set-key (kbd "M-5")     'query-replace)
;; (global-set-key (kbd "M-%")     'digit-argument)

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

;; Override this paredit keybindings
(eval-after-load 'paredit
  '(progn
     (define-key paredit-mode-map (kbd "M-J") nil)
     (define-key paredit-mode-map (kbd "M-;") nil)
     (define-key paredit-mode-map (kbd "M-r") nil)
     (define-key paredit-mode-map (kbd "M--") nil)
     (define-key paredit-mode-map (kbd "H-M-j") 'paredit-join-sexps)
     (define-key paredit-mode-map (kbd "H-M-s") 'paredit-split-sexp)
     (define-key paredit-mode-map (kbd "M-S") nil)))

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
            (setq auto-highlight-symbol-mode nil)
            (define-key org-mode-map (kbd "M-S-<return>") 'org-insert-subheading)
            (define-key org-mode-map (kbd "C-<return>")   'org-insert-heading-after-current)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; evil stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key evil-normal-state-map (kbd "C-d") 'evil-scroll-down)
(define-key evil-normal-state-map (kbd "C-u") nil)
(define-key evil-normal-state-map (kbd "q") nil)
(define-key evil-normal-state-map (kbd "gw") nil)
(define-key evil-normal-state-map (kbd "gwh") 'split-window-right)
(define-key evil-normal-state-map (kbd "gwl") 'split-window-right-and-make-active)
(define-key evil-normal-state-map (kbd "gwk") 'split-window-below)
(define-key evil-normal-state-map (kbd "gwj") 'split-window-below-and-make-active)
(define-key evil-normal-state-map (kbd "gwu") 'winner-undo)
(define-key evil-normal-state-map (kbd "gwr") 'winner-redo)
(define-key evil-normal-state-map (kbd "gr") 'repeat)
(define-key evil-normal-state-map (kbd "C-a") nil)
(define-key evil-normal-state-map (kbd "qe") 'eval-last-sexp)

(define-key evil-normal-state-map (kbd "qq") 'quit-window)
(define-key evil-normal-state-map (kbd "g+") 'hs-show-block)
(define-key evil-normal-state-map (kbd "gf")  'ido-find-file)

;; "C-c p t" == "SPC p a" for some reason, while "SPC p t" is neotree but "SPC p n" is undefined.  wha??
(define-key evil-normal-state-map (kbd "SPC p t")  'projectile-toggle-between-implementation-and-test)
(define-key evil-normal-state-map (kbd "C-c p s f")  'ag-project-files)
(define-key evil-normal-state-map (kbd "SPC p s f")  'ag-project-files)
(define-key evil-normal-state-map (kbd "SPC p s r")  'projectile-ag-regex)
(define-key evil-normal-state-map (kbd "SPC p s s")  'projectile-ag)

(define-key evil-normal-state-map (kbd "SPC p s F")  'ag-project-files-current-current-file-extension)
(define-key evil-normal-state-map (kbd "C-c p s F")  'ag-project-files-current-current-file-extension)

(define-key evil-normal-state-map (kbd "SPC p a")  nil)
(define-key evil-normal-state-map (kbd "SPC p n")  'neotree-find-project-root)
(define-key evil-normal-state-map (kbd "C-c p n")  'neotree-find-project-root)

(define-key evil-normal-state-map (kbd "C-c p n")  'neotree-find-project-root)

(define-key evil-normal-state-map (kbd "q4")  'evil-end-of-line)

;; SPC-w-c
;; (define-key evil-normal-state-map (kbd "qw0") 'delete-window)

;; SPC-w-m
;; (define-key evil-normal-state-map (kbd "qw1") 'delete-other-windows)

;; (define-key evil-normal-state-map (kbd "SPC 8")  'helm-mini)
(define-key evil-insert-state-map (kbd "M-j") 'newline-and-indent)
(define-key evil-normal-state-map (kbd "qm")  'evil-record-macro)
(define-key evil-insert-state-map (kbd "C-;") 'evil-normal-state-and-save-buffer)

;; (define-key evil-normal-state-map (kbd "SPC SPC") nil)
(define-key evil-insert-state-map (kbd "C-a") nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; do with H-j, M-j what you could do with <return> but less pink moving
(let ((map minibuffer-local-map))
  (define-key map (kbd "M-j") 'exit-minibuffer)
  (define-key map (kbd "M-k") 'abort-recursive-edit))

;;
(key-chord-mode 1)
(setq key-chord-two-keys-delay 0.05)
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state-and-save-buffer)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(key-chord-define evil-insert-state-map "jl" 'evil-execute-in-normal-state)
(key-chord-define evil-insert-state-map "q)" 'evil-digit-argument-or-evil-beginning-of-line)
(key-chord-define evil-insert-state-map "90" "[")
(key-chord-define evil-insert-state-map "jn" 'newline-and-indent)
(key-chord-define-global "j1" "!")
(key-chord-define-global "j2" "@")
(key-chord-define-global "j3" "#")
(key-chord-define-global "j4" "$")
(key-chord-define-global "j5" "%")
(key-chord-define-global "j6" "^")
(key-chord-define-global "j7" "&")
(key-chord-define-global "j8" "*")
(key-chord-define-global "j9" "(")
(key-chord-define-global "j0" ")")
(key-chord-define-global "j-" "_")

(setq-default evil-escape-key-sequence "jk")

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
;; (dolist (k '([mouse-1] [down-mouse-1] [drag-mouse-1] [double-mouse-1] [triple-mouse-1]
;;              [mouse-2] [down-mouse-2] [drag-mouse-2] [double-mouse-2] [triple-mouse-2]
;;              [mouse-3] [down-mouse-3] [drag-mouse-3] [double-mouse-3] [triple-mouse-3]))
;;   (global-unset-key k))
;; (global-set-key (kbd "<down-mouse-1>") 'mouse-select-window)


;;;;;;;;;;;;;;;;;
;; hydra stuff ;;
;;;;;;;;;;;;;;;;;

;;
;; https://www.reddit.com/r/emacs/comments/3ba645/does_anybody_have_any_real_cool_hydras_to_share/cskdhte
;; Split: _|_:vert  _-_:horz

(require 'hydra)
(defun hydra-move-splitter-left (arg)
  "Move window splitter left."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'right))
      (shrink-window-horizontally arg)
    (enlarge-window-horizontally arg)))

(defun hydra-move-splitter-right (arg)
  "Move window splitter right."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'right))
      (enlarge-window-horizontally arg)
    (shrink-window-horizontally arg)))

(defun hydra-move-splitter-up (arg)
  "Move window splitter up."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'up))
      (enlarge-window arg)
    (shrink-window arg)))

(defun hydra-move-splitter-down (arg)
  "Move window splitter down."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'up))
      (shrink-window arg)
    (enlarge-window arg)))

(defhydra hydra-windows (:hint nil)
  "
         Delete: !:other )_:curr
          Split: _wh_:left _wj_:down _wk_:up _wl_:right
  Switch Window: _h_:left  _j_:down  _k_:up  _l_:right
        Buffers: _p_revious  _n_ext  _8_:helm-mini  _i_buffer _f_ind-file  _F_projectile _*_:select _K_ill-this-buffer _B_ury-uffer
    Buffer Move: _M-h_:buf-move-left _M-j_:buf-move-down _M-k_:buf-move-up _M-l_:buf-move-right
         Winner: _u_ndo  _r_edo
         Resize: _H_:splitter left  _J_:splitter down  _K_:splitter up  _L_:splitter right
           Move: _a_:up  _z_:down
      Transpose: _tt_:transpose _tv_:vertical-flip _th_:horizontal-flip _tr_:rotate clockwise"

  ;; http://www.emacswiki.org/emacs/TransposeFrame
  ("tt" transpose-frame)
  ("tv" flip-frame) ; flip vertically
  ("th" flop-frame) ; flip horizontally
  ("tr" rotate-frame-clockwise)

  ("z" scroll-up-line)
  ("a" scroll-down-line)

  ("u" winner-undo)
  ("r" winner-redo)

  ("h" windmove-left)
  ("j" windmove-down)
  ("k" windmove-up)
  ("l" windmove-right)

  ("M-h" buf-move-left)
  ("M-l" buf-move-right)
  ("M-k" buf-move-up)
  ("M-j" buf-move-down)

  ("p" previous-buffer)
  ("n" next-buffer)
  ("8" helm-mini)
  ("i" ibuffer)
  ("f" ido-find-file)
  ("F" projectile-find-file)
  ("*" ido-switch-buffer)
  ("K" kill-this-buffer)
  ("B" bury-buffer)

  ("wj" split-window-below-and-make-active)
  ("wk" split-window-below)
  ("wl" split-window-right-and-make-active)
  ("wh" split-window-right)

  (")" delete-window)
  ("!" delete-other-windows)

  ("H" hydra-move-splitter-left)
  ("J" hydra-move-splitter-down)
  ("K" hydra-move-splitter-up)
  ("L" hydra-move-splitter-right)

  ("=" balance-windows)

  ("g" nil)
  ("q" nil))

(global-set-key (kbd "H-8")     'hydra-windows/body)

(defhydra hydra-hide-show (:hint nil)
  "
               : _h_l-line-mode _m_enu-bar _l_inum-mode _s_r-speedbar-toggle _t_oggle-truncate-lines"

  ("m" menu-bar-mode)
  ("h" hl-line-mode)
  ("l" linum-mode)
  ("s" sr-speedbar-toggle)
  ("t" toggle-truncate-lines)
  ("q" nil))

(global-set-key (kbd "H-^") 	'hydra-hide-show/body)

(global-set-key (kbd "<f6>") 'linum-mode)

(global-set-key (kbd "M-S-%") 'query-replace-regexp)

(global-set-key (kbd "H-c") 'reset-my-colors)

(global-set-key (kbd "C-c p s r") 'projectile-ag-regex)

(defhydra hydra-git-gutter (:hint nil)
  "
           Hunk: _p_:previous _n_:next _s_:show _P_:popup _r_:revert
           Misc: "

  ("p" git-gutter+-previous-hunk)
  ("n" git-gutter+-next-hunk)
  ("s" git-gutter+-show-hunk-inline-at-point)
  ("P" git-gutter+-popup-hunk)
  ("r" git-gutter+-revert-hunk)
  ("q" nil))

(global-set-key (kbd "H-g") 	'hydra-git-gutter/body)

;; (when (require 'multi-term nil t)
;;   (global-set-key (kbd "<f5>") 'multi-term)
;;   (global-set-key (kbd "<C-next>") 'multi-term-next)
;;   (global-set-key (kbd "<C-prior>") 'multi-term-prev)
;;   (setq multi-term-buffer-name "ansi-term"
;;         multi-term-program "/bin/bash"))


;; (defun term-move-window-then-open-term (motion-func)
;;   (interactive)
;;   (funcall motion-func 1)
;;   (ansi-term "/bin/bash"))

;; (let ((f (lambda (motion) (eval motion) (ansi-term "/bin/bash"))))
;;   (define-key term-raw-map (kbd "<f7> j") '(funcall f '(evil-window-up 1))))

(global-set-key (kbd "<f7> <f7>") '(lambda () (interactive) (ansi-term "/bin/bash")))

(eval-after-load "term"
  '(progn
     (define-key term-raw-map (kbd "C-c C-y") 'term-paste)
     (define-key term-raw-map (kbd "M-J") 'evil-window-down)
     (define-key term-raw-map (kbd "M-K") 'evil-window-up)
     (define-key term-raw-map (kbd "M-L") 'evil-window-right)
     (define-key term-raw-map (kbd "M-H") 'evil-window-left)


     (define-key term-raw-map (kbd "<f7> <f7>") '(ansi-term "/bin/bash"))))

(global-set-key (kbd "C-S-<f11>") 'cider-save-and-rerun-test)
(provide 'bindings)
;;; bindings.el ends here
