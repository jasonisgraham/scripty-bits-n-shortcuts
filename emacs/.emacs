(setq version-controlled-stuff-dir "~/scripty-bits-n-shortcuts/emacs")
(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "plugins.el"))
(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "misc.el"))
(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "open-resource.el"))
(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "bindings.el"))
(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "appearance.el"))
;; (load-file (concat (file-name-as-directory version-controlled-stuff-dir) "elscreen-buffer-list.el"))
;; (load-file (concat (file-name-as-directory version-controlled-stuff-dir) "number-lock.el"))

(defun buffer-stack-filter-regexp (buffer)
  "Non-nil if buffer is in buffer-stack-tracked."
  (not (or (string-match "Help\\|html\\|helm\\|temp\\|Minibuf\\|Messages\\|Customize\\|Custom-Work\\|scratch\\|tram\\|Buffer" (buffer-name buffer))
           (member buffer buffer-stack-untracked))))

(setq jdk-directory "~/jdk/src/")

(setq tags-revert-without-query 't)

(load-file (concat (file-name-as-directory version-controlled-stuff-dir) "appearance.el"))

(add-to-list 'custom-theme-load-path "~/.emacs.d/elpa/monokai-theme-20150112.442/")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(2C-mode-line-format
   (quote
    ("dog" "-%*- %15b --"
     (-3 . "%p")
     "--%[(" mode-name minor-mode-alist "%n" mode-line-process ")%]%-")))
 '(Linum-format "%7i ")
 '(ahs-default-range (quote ahs-range-whole-buffer))
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#c0c0c0" "#336c6c" "#806080" "#0f2050" "#732f2c" "#23733c" "#6c1f1c" "#232333"])
 '(ansi-term-color-vector
   [unspecified "#081724" "#ff694d" "#68f6cb" "#fffe4e" "#bad6e2" "#afc0fd" "#d2f1ff" "#d3f9ee"] t)
 '(background-mode dark)
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(buffer-stack-filter (quote buffer-stack-filter-regexp))
 '(buffer-stack-ignore-pattern-exceptions (quote ("*ielm*" "*shell*")))
 '(buffer-stack-untracked
   (quote
    ("KILL" "*Compile-Log*" "*Compile-Log-Show*" "*Group*" "*Completions*" "*Messages*")))
 '(column-number-mode t)
 '(compilation-message-face (quote default))
 '(completion-ignored-extensions
   (quote
    (".o" "~" ".bin" ".lbin" ".so" ".a" ".ln" ".blg" ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".svn/" ".hg/" ".git/" ".bzr/" "CVS/" "_darcs/" "_MTN/" ".fmt" ".tfm" ".class" ".fas" ".lib" ".mem" ".x86f" ".sparcf" ".dfsl" ".pfsl" ".d64fsl" ".p64fsl" ".lx64fsl" ".lx32fsl" ".dx64fsl" ".dx32fsl" ".fx64fsl" ".fx32fsl" ".sx64fsl" ".sx32fsl" ".wx64fsl" ".wx32fsl" ".fasl" ".ufsl" ".fsl" ".dxl" ".lo" ".la" ".gmo" ".mo" ".toc" ".aux" ".fn" ".ky" ".pg" ".tp" ".vr" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo")))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(cursor-color "#cccccc")
 '(custom-enabled-themes (quote (monokai)))
 '(custom-safe-themes
   (quote
    ("4e262566c3d57706c70e403d440146a5440de056dfaeb3062f004da1711d83fc" default)))
 '(diary-entry-marker (quote font-lock-variable-name-face))
 '(dired-listing-switches
   "-lahBF --ignore=#* --ignore=.svn --ignore=.git --group-directories-first")
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(electric-pair-mode t)
 '(fci-rule-character-color "#202020")
 '(font-use-system-font t)
 '(foreground-color "#cccccc")
 '(fringe-mode 0 nil (fringe))
 '(global-auto-highlight-symbol-mode t)
 '(global-evil-search-highlight-persist t)
 '(global-linum-mode nil)
 '(global-undo-tree-mode t)
 '(gnus-logo-colors (quote ("#528d8d" "#c0c0c0")) t)
 '(golden-ratio-mode nil)
 '(grep-command "grep -n -e ")
 '(grep-find-command (quote ("find . -type f -exec grep -nHir -e  {} +" . 34)))
 '(grep-find-ignored-files
   (quote
    (".#*" "*.o" "*~" "*.bin" "*.lbin" "*.so" "*.a" "*.ln" "*.blg" "*.bbl" "*.elc" "*.lof" "*.glo" "*.idx" "*.lot" "*.fmt" "*.tfm" "*.class" "*.fas" "*.lib" "*.mem" "*.x86f" "*.sparcf" "*.dfsl" "*.pfsl" "*.d64fsl" "*.p64fsl" "*.lx64fsl" "*.lx32fsl" "*.dx64fsl" "*.dx32fsl" "*.fx64fsl" "*.fx32fsl" "*.sx64fsl" "*.sx32fsl" "*.wx64fsl" "*.wx32fsl" "*.fasl" "*.ufsl" "*.fsl" "*.dxl" "*.lo" "*.la" "*.gmo" "*.mo" "*.toc" "*.aux" "*.fn" "*.ky" "*.pg" "*.tp" "*.vr" "*.cps" "*.fns" "*.kys" "*.pgs" "*.tps" "*.vrs" "*.pyc" "*.pyo")))
 '(grep-find-template "find . <X> -type f <F> -exec grep <C> -nH -e <R> {} +")
 '(grep-highlight-matches (quote auto))
 '(grep-template "grep <X> <C> -n -e <R> <F>")
 '(grep-use-null-device t)
 '(helm-recentf-fuzzy-match t)
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#002b36" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   (quote
    (("#073642" . 0)
     ("#546E00" . 20)
     ("#00736F" . 30)
     ("#00629D" . 50)
     ("#7B6000" . 60)
     ("#8B2C02" . 70)
     ("#93115C" . 85)
     ("#073642" . 100))))
 '(hl-bg-colors
   (quote
    ("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00")))
 '(hl-fg-colors
   (quote
    ("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
 '(hl-paren-background-colors (quote ("#2492db" "#95a5a6" nil)))
 '(hl-paren-colors (quote ("#ecf0f1" "#ecf0f1" "#c0392b")))
 '(ispell-highlight-face (quote flyspell-incorrect))
 '(linum-format "%d ")
 '(magit-diff-use-overlays nil)
 '(magit-use-overlays nil)
 '(main-line-color1 "#1E1E1E")
 '(main-line-color2 "#111111")
 '(main-line-separator-style (quote chamfer))
 '(mode-line-format
   (quote
    (" " "%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position evil-mode-line-tag
     (elscreen-display-screen-number
      (" " elscreen-mode-line-string))
     (vc-mode vc-mode)
     "  " mode-line-modes mode-line-misc-info mode-line-end-spaces)))
 '(open-resource-ignore-patterns (quote ("/target/" "~$" ".old$" ".svn" "/bin/" ".class$")))
 '(org-startup-truncated nil)
 '(powerline-color1 "#1E1E1E")
 '(powerline-color2 "#111111")
 '(read-buffer-completion-ignore-case t)
 '(recentf-exclude (quote (".*ido\\.last" "/elpa/" ".*~$" ".*gz$")))
 '(recentf-keep (quote (recentf-keep-default-predicate)))
 '(recentf-max-saved-items 50)
 '(recentf-mode t)
 '(safe-local-variable-values (quote ((require-final-newline))))
 '(show-paren-mode t)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(syslog-debug-face
   (quote
    ((t :background unspecified :foreground "#A1EFE4" :weight bold))))
 '(syslog-error-face
   (quote
    ((t :background unspecified :foreground "#F92672" :weight bold))))
 '(syslog-hour-face (quote ((t :background unspecified :foreground "#A6E22E"))))
 '(syslog-info-face
   (quote
    ((t :background unspecified :foreground "#66D9EF" :weight bold))))
 '(syslog-ip-face (quote ((t :background unspecified :foreground "#E6DB74"))))
 '(syslog-su-face (quote ((t :background unspecified :foreground "#FD5FF0"))))
 '(syslog-warn-face
   (quote
    ((t :background unspecified :foreground "#FD971F" :weight bold))))
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(tool-bar-mode nil)
 '(vc-annotate-background "#202020")
 '(vc-annotate-color-map
   (quote
    ((20 . "#C99090")
     (40 . "#D9A0A0")
     (60 . "#ECBC9C")
     (80 . "#DDCC9C")
     (100 . "#EDDCAC")
     (120 . "#FDECBC")
     (140 . "#6C8C6C")
     (160 . "#8CAC8C")
     (180 . "#9CBF9C")
     (200 . "#ACD2AC")
     (220 . "#BCE5BC")
     (240 . "#CCF8CC")
     (260 . "#A0EDF0")
     (280 . "#79ADB0")
     (300 . "#89C5C8")
     (320 . "#99DDE0")
     (340 . "#9CC7FB")
     (360 . "#E090C7"))))
 '(vc-annotate-very-old-color "#E090C7")
 '(view-highlight-face (quote highlight))
 '(weechat-color-list
   (quote
    (unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83")))
 '(yas-snippet-dirs
   (quote
    (yas-installed-snippets-dir "/home/jason/.emacs.d/elpa/django-snippets-20131229.811/snippets")) nil (yasnippet)))

(setq cider-repl-history-file "~/.emacs.d/cider-history")
(setq my-background-color "grey6")
(set-background-color my-background-color)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-search-highlight-persist-highlight-face ((t (:inherit nil :background "yellow1" :foreground "black"))))
 '(helm-selection ((t (:inherit nil :inverse-video t :underline t))))
 '(highlight ((t (:background "lawn green" :foreground "black"))))
 '(linum ((t (:background "gray9" :foreground "#75715E"))))
 '(mode-line ((t (:background "white" :foreground "black"))))
 '(mode-line-buffer-id ((t (:foreground "black" :weight bold))))
 '(mode-line-highlight ((t (:box (:line-width 2 :color "grey40" :style released-button)))))
 '(mode-line-inactive ((t (:inherit mode-line :inverse-video t))))
 '(semantic-highlight-edits-face ((t (:background "gray21"))))
 '(show-paren-match ((t (:background "blue"))))
 '(term ((t (:inherit default :foreground "white smoke"))))
 '(zencoding-preview-output ((t (:background "dim gray")))))

;; package-activated-list
;; (2048-game ac-cider auto-complete popup cider queue pkg-info epl dash clojure-mode afternoon-theme ample-theme anything archive-region async auto-complete popup auto-highlight-symbol autopair badger-theme base16-theme bash-completion bliss-theme bookmark+ boron-theme buffer-move buffer-stack capture cider-decompile javap-mode cider queue pkg-info epl dash clojure-mode cider-profile cider queue pkg-info epl dash clojure-mode cider-spy dash cider queue pkg-info epl dash clojure-mode clojure-mode clues-theme company csv-mode ctags cyberpunk-theme dakrone-theme dark-krystal-theme elisp-slime-nav emacs-eclim s emacs-setup ess-R-data-view ess popup ctable ess-R-object-popup ess popup ess-smart-underscore ess evil-args evil goto-chg undo-tree evil-easymotion noflet ace-jump-mode evil-escape evil goto-chg undo-tree evil-exchange evil goto-chg undo-tree evil-jumper evil goto-chg undo-tree evil-lisp-state smartparens dash evil-leader evil goto-chg undo-tree evil goto-chg undo-tree evil-matchit evil-org evil goto-chg undo-tree evil-paredit paredit evil goto-chg undo-tree evil-search-highlight-persist highlight evil-snipe evil goto-chg undo-tree evil-space evil goto-chg undo-tree evil-surround evil-tabs elscreen evil goto-chg undo-tree evil-terminal-cursor-changer evil goto-chg undo-tree evil-tutor evil goto-chg undo-tree evil-visual-mark-mode dash evil goto-chg undo-tree evil-visualstar evil goto-chg undo-tree firecode-theme foreign-regexp gitlab request pkg-info epl dash s golden-ratio google goto-chg groovy-mode gruvbox-theme heroku highlight ido-at-point ido-complete-space-or-hyphen ido-gnus ido-hacks ido-load-library pcache persistent-soft list-utils pcache ido-select-window ido-sort-mtime ido-ubiquitous ido-vertical-mode jabber javap-mode jtags magit git-rebase-mode git-commit-mode markdown-mode monokai-theme multiple-cursors noflet paredit persistent-soft list-utils pcache pkg-info epl popup purple-haze-theme queue rainbow-delimiters regex-tool request s smart-mode-line rich-minority dash smartparens dash smyx-theme soothe-theme sr-speedbar subatomic256-theme sublime-themes tango-2-theme toxi-theme undo-tree waher-theme warm-night-theme window-number wrap-region dash yasnippet zen-and-art-theme zenburn-theme zonokai-theme)

 ;; '(eclim-eclipse-dirs (quote ("~/Programs/eclipse")))
 ;; '(eclim-executable "~/Programs/eclipse/eclim")
