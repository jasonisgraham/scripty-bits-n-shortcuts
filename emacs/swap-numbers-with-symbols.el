;;; swap-numbers-with-symbols.el

(defgroup swap-numbers-with-symbols nil
  "this is a function to toggle numbers with symbols.  e.g. 1 -> !, 2 -> @, ... 9 -> (, 0 -> @)"
  :group 'swap-numbers-with-symbols)

(defcustom use-symbols-by-default t
  "set this to nil to use numbers by default"
  :group 'swap-numbers-with-symbols
  :type 'boolean)

(setq __use-symbols use-symbols-by-default)

(defun swap-numbers-with-symbols/toggle ()
  "if we're using symbols, then use numbers"
  (interactive)
  (if __use-symbols
      (swap-numbers-with-symbols/use-numbers)
    (swap-numbers-with-symbols/use-symbols)))

(defun swap-numbers-with-symbols/use-symbols ()
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

(defun swap-numbers-with-symbols/use-numbers ()
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

(if use-symbols-by-default
    (swap-numbers-with-symbols/use-symbols)
  (swap-numbers-with-symbols/use-symbols))

(defun swap-numbers-with-symbols/mode-line-display ()
  (if __use-symbols "<sym>" "<num>"))

(defvar swap-numbers-with-symbols/mode-line-display
  '(:eval (swap-numbers-with-symbols/mode-line-display-defun)))
