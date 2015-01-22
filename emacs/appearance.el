(setq-default c-basic-offset 2)
(setq-default indent-tabs-mode nil)
(setq js-indent-level 2)

(require 'paren) (show-paren-mode t)
(setq read-file-name-completion-ignore-case t)

;; give cp & sc files c-mode highlighting n schtuf
(require 'font-lock)
(global-font-lock-mode t)
(add-to-list 'auto-mode-alist '("\\.cp\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.sc\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.log\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.rw\\'" . sql-mode))

(defun indent-buffer ()
  "indents entire buffer"
  (interactive)
  (indent-region (point-min) (point-max)))

(defun single-lines-only ()
  "replace multiple blank lines with a single one"
  (interactive)
  (goto-char (point-min))
  (replace-regexp "^\n\n+" "\n"))

(defun save-and-format-buffer ()
  "applies some formatting to a file then saves it"
  (interactive)
  (delete-trailing-whitespace)
  ;; (indent-buffer)
  (set-cursor-color "#ffffff")
  (when buffer-file-name (save-buffer)))

;; diff mode
(eval-after-load 'diff-mode
  '(progn
     (set-face-foreground 'diff-added "green4")
     (set-face-foreground 'diff-added "red3")))

;; (set-frame-font "Source Code Pro 10" nil t)
;; (set-face-attribute 'default nil :font "Source Code Pro 9")

(set-frame-font "Monaco 9" nil t)
(set-face-attribute 'default nil :font "Monaco 9")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "white" :foreground "black"))))
 '(mode-line-inactive ((t (:inherit mode-line :inverse-video t)))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-startup-truncated nil)
 '(read-buffer-completion-ignore-case t)
 '(global-linum-mode nil)
 '(global-undo-tree-mode t)
 '(safe-local-variable-values (quote ((require-final-newline)))))

;; set font height
;; (set-face-attribute 'default nil :height 100)

(setq column-number-mode 't)
(setq menu-bar-mode nil)
(global-linum-mode nil)

;; open 2 files as side-by-side windows
(defun 2-windows-vertical-to-horizontal ()
  (let ((buffers (mapcar 'window-buffer (window-list))))
    (when (= 2 (length buffers))
      (delete-other-windows)
      (set-window-buffer (split-window-horizontally) (cadr buffers)))))
(add-hook 'emacs-startup-hook '2-windows-vertical-to-horizontal)

;; if >1 window with same name, uniquify then with something better than <2>,<3>, ... etc
(require 'uniquify)
(setq uniquify-buffer-name-style (quote forward))

;; modeline customization
(menu-bar-mode -1)

;; automatically save buffers associated with files on buffer switch
;; and on windows switch
(defadvice switch-to-buffer (before save-buffer-now activate)
  (on-window-switch))
(defadvice other-window (before other-window-now activate)
  (on-window-switch))
(defadvice windmove-up (before other-window-now activate)
  (on-window-switch))
(defadvice windmove-down (before other-window-now activate)
  (on-window-switch))
(defadvice windmove-left (before other-window-now activate)
  (on-window-switch))
(defadvice windmove-right (before other-window-now activate)
  (on-window-switch))

;; hide-show stuff
;;(setq-default hs-minor-mode t)
(add-hook 'c-mode-common-hook (lambda() (hs-minor-mode 1)))
(defun hs-hide-all-comments ()
  "Hide all top level blocks, if they are comments, displaying only first line.
Move point to the beginning of the line, and run the normal hook
`hs-hide-hook'.  See documentation for `run-hooks'."
  (interactive)
  (hs-life-goes-on
   (save-excursion
     (unless hs-allow-nesting
       (hs-discard-overlays (point-min) (point-max)))
     (goto-char (point-min))
     (let ((spew (make-progress-reporter "Hiding all comment blocks..."
                                         (point-min) (point-max)))
           (re (concat "\\(" hs-c-start-regexp "\\)")))
       (while (re-search-forward re (point-max) t)
         (if (match-beginning 1)
             ;; found a comment, probably
             (let ((c-reg (hs-inside-comment-p)))
               (when (and c-reg (car c-reg))
                 (if (> (count-lines (car c-reg) (nth 1 c-reg)) 1)
                     (hs-hide-block-at-point t c-reg)
                   (goto-char (nth 1 c-reg))))))
         (progress-reporter-update spew (point)))
       (progress-reporter-done spew)))
   (beginning-of-line)
   (run-hooks 'hs-hide-hook)))

(set-frame-parameter (selected-frame) 'alpha '(97 90))
(global-auto-highlight-symbol-mode 1)
(setq ahs-chrange-whole-buffer t)

(put 'scroll-left 'disabled nil)

;; (setq my-background-color "gray12")

;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(Linum-format "%7i ")
;;  '(ahs-default-range (quote ahs-range-whole-buffer))
;;  '(ansi-color-faces-vector
;;    [default default default italic underline success warning error])
;;  '(ansi-color-names-vector
;;    ["#c0c0c0" "#336c6c" "#806080" "#0f2050" "#732f2c" "#23733c" "#6c1f1c" "#232333"])
;;  '(ansi-term-color-vector
;;    [unspecified "#081724" "#ff694d" "#68f6cb" "#fffe4e" "#bad6e2" "#afc0fd" "#d2f1ff" "#d3f9ee"])
;;  '(background-color my-background-color)
;;  '(background-mode dark)
;;  '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
;;  '(column-number-mode t)
;;  '(compilation-message-face (quote default))
;;  '(cua-global-mark-cursor-color "#2aa198")
;;  '(cua-normal-cursor-color "#839496")
;;  '(cua-overwrite-cursor-color "#b58900")
;;  '(cua-read-only-cursor-color "#859900")
;;  '(cursor-color "#cccccc")
;;  '(custom-enabled-themes (quote (monokai)))
;;  '(custom-safe-themes
;;    (quote
;;     ("756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" "f41fd682a3cd1e16796068a2ca96e82cfd274e58b978156da0acce4d56f2b0d5" "978ff9496928cc94639cb1084004bf64235c5c7fb0cfbcc38a3871eb95fa88f6" "8d6fb24169d94df45422617a1dfabf15ca42a97d594d28b3584dc6db711e0e0b" "08efabe5a8f3827508634a3ceed33fa06b9daeef9c70a24218b70494acdf7855" "49eea2857afb24808915643b1b5bd093eefb35424c758f502e98a03d0d3df4b1" "f0ea6118d1414b24c2e4babdc8e252707727e7b4ff2e791129f240a2b3093e32" "96b023d1a6e796bab61b472f4379656bcac67b3af4e565d9fb1b6b7989356610" "d809ca3cef02087b48f3f94279b86feca896f544ae4a82b523fba823206b6040" "c01f093ab78aad6ae2c27abc47519709c6b3aaa2c1e35c712d4dd81ff1df7e31" "569dc84822fc0ac6025f50df56eeee0843bffdeceff2c1f1d3b87d4f7d9fa661" "41b6698b5f9ab241ad6c30aea8c9f53d539e23ad4e3963abff4b57c0f8bf6730" "405fda54905200f202dd2e6ccbf94c1b7cc1312671894bc8eca7e6ec9e8a41a2" "ae8d0f1f36460f3705b583970188e4fbb145805b7accce0adb41031d99bd2580" "51bea7765ddaee2aac2983fac8099ec7d62dff47b708aa3595ad29899e9e9e44" "1affe85e8ae2667fb571fc8331e1e12840746dae5c46112d5abb0c3a973f5f5a" "9bac44c2b4dfbb723906b8c491ec06801feb57aa60448d047dbfdbd1a8650897" "ad9fc392386f4859d28fe4ef3803585b51557838dbc072762117adad37e83585" "e4bc8563d7651b2fed20402fe37b7ab7cb72869f92a3e705907aaecc706117b5" "1934bf7e1713bf706a9cb36cc6a002741773aa42910ca429df194d007ee05c67" "5ea20171762b3f9682fbf507ee4b4018ce7b6cc65415fa99799a125f112b2cdb" "c739f435660ca9d9e77312cbb878d5d7fd31e386a7758c982fa54a49ffd47f6e" "8ada1f0bcfc2d8662b74fb21bd1830eaacb5d29e3c99a5ea7fd7a417b7a9b708" "f25f6ddbe05e6a9dad9b2eee37c476fb69d03758b071372926ffaae634ebac78" "64581032564feda2b5f2cf389018b4b9906d98293d84d84142d90d7986032d33" "30a8a5a9099e000f5d4dbfb2d6706e0a94d56620320ce1071eede5481f77d312" "806d8c827b214f5f60348114bd27c6dcb5d19047f7ac482ad61e8077a6c5ea60" "70cf411fbf9512a4da81aa1e87b064d3a3f0a47b19d7a4850578c8d64cac2353" "cfe99939ab2423c01d34c97f6ae40e1db965564a7acb17731eb049a2e5e76392" "89586444c668bae9ec7e594bc38b3a956f31dc6cb7c851ed40411cc4ff770708" "1af9aa2eaaaf6cfa7d3b3d0c6d653a9e05b28f11681fbf4efb75812f4a2a310a" "7625bab54bda4fd0c1c5e5629c010e7bb8b715e30d12e3cc32a7dce1685adddc" "0795e2c85394140788d72d34969be4acb305e4a54149e7237787d9df27832fbb" "0d19ff470ad7029d2e1528b3472ca2d58d0182e279b9ab8acd65e2508845d2b6" "ab3e4108e9b6d9b548cffe3c848997570204625adacef60cbd50a39306866db1" "a5beb9b1d6dc23dd8a3c204c159c9a5f1e0115ff14b5b8579d6f3ede4f3b3aee" "0744f61189c62ed6d1f8fa69f6883d5772fe8577310b09e623c62c040f208cd4" "e35ef4f72931a774769da2b0c863e11d94e60a9ad97fb9734e8b28c7ee40f49b" "61b188036ad811b11387fc1ef944441826c19ab6dcee5c67c7664a0bbd67a5b5" "3e734ddc620f71e06d3b371d4c15bb63297046df32f25132f9440847cd917a10" "26247bcb0b272ec9a5667a6b854125450c88a44248123a03d9f242fd5c6ec36f" "0f002f8b472e1a185dfee9e5e5299d3a8927b26b20340f10a8b48beb42b55102" "013e87003e1e965d8ad78ee5b8927e743f940c7679959149bbee9a15bd286689" "1011be33e9843afd22d8d26b031fbbb59036b1ce537d0b250347c19e1bd959d0" "f5bd8485ec9ba65551bf9b9fcaa6af6bcbaebaa4591c0f30d3e512b1d77b3481" "53e29ea3d0251198924328fd943d6ead860e9f47af8d22f0b764d11168455a8e" "bac3f5378bc938e96315059cd0488d6ef7a365bae73dac2ff6698960df90552d" "f9e975bdf5843982f4860b39b2409d7fa66afab3deb2616c41a403d788749628" "a99e7c91236b2aba4cd374080c73f390c55173c5a1b4ac662eeb3172b60a9814" "e74d80bf86c7951b1a27994faa417f7e3b4a02f7a365ed224f032bd29f5d2d6d" "bad832ac33fcbce342b4d69431e7393701f0823a3820f6030ccc361edd2a4be4" "f5e9f66da69f504cb61aacedeb8284d8f38f2e6f835fd658cac5f0ad5d924549" "a31c86c0a9ba5d06480b02bb912ae58753e09f13edeb07af8927d67c3bb94d68" "353861e69d6510a824905208f7290f90248f0b9354ee034fd4562b962790bdfc" "d143750cb9fadb9ea9a3a27e0632418d2ad09788e115a61a64dd5404fedfe178" "442c946bc5c40902e11b0a56bd12edc4d00d7e1c982233545979968e02deb2bc" "e24180589c0267df991cf54bf1a795c07d00b24169206106624bb844292807b9" "42ac06835f95bc0a734c21c61aeca4286ddd881793364b4e9bc2e7bb8b6cf848" "758da0cfc4ecb8447acb866fb3988f4a41cf2b8f9ca28de9b21d9a68ae61b181" "789844278c5a75283b5015c1fc7bebe7e4cf97843b8f8cffe21fafa05e81e90a" "6209442746f8ec6c24c4e4e8a8646b6324594308568f8582907d0f8f0260c3ae" "9dae95cdbed1505d45322ef8b5aa90ccb6cb59e0ff26fef0b8f411dfc416c552" "f04122bbc305a202967fa1838e20ff741455307c2ae80a26035fbf5d637e325f" "3632cf223c62cb7da121be0ed641a2243f7ec0130178722554e613c9ab3131de" "66132890ee1f884b4f8e901f0c61c5ed078809626a547dbefbb201f900d03fd8" "e94d57fc2e086ae8c0bb665c261d41e75c23187676077c12c5349cf3a2e726c8" "a8821dd3059e3a7e78a6183bdea797960d7644d1ced211fff42443257e745561" "4eaad15465961fd26ef9eef3bee2f630a71d8a4b5b0a588dc851135302f69b16" "96998f6f11ef9f551b427b8853d947a7857ea5a578c75aa9c4e7c73fe04d10b4" "0c29db826418061b40564e3351194a3d4a125d182c6ee5178c237a7364f0ff12" "987b709680284a5858d5fe7e4e428463a20dfabe0a6f2a6146b3b8c7c529f08b" "3cd28471e80be3bd2657ca3f03fbb2884ab669662271794360866ab60b6cb6e6" "46fd293ff6e2f6b74a5edf1063c32f2a758ec24a5f63d13b07a20255c074d399" "a233249cc6f90098e13e555f5f5bf6f8461563a8043c7502fb0474be02affeea" "e9776d12e4ccb722a2a732c6e80423331bcb93f02e089ba2a4b02e85de1cf00e" "1a85b8ade3d7cf76897b338ff3b20409cb5a5fbed4e45c6f38c98eee7b025ad4" "58c6711a3b568437bab07a30385d34aacf64156cc5137ea20e799984f4227265" "3d5ef3d7ed58c9ad321f05360ad8a6b24585b9c49abcee67bdcbb0fe583a6950" "b3775ba758e7d31f3bb849e7c9e48ff60929a792961a2d536edec8f68c671ca5" "7bde52fdac7ac54d00f3d4c559f2f7aa899311655e7eb20ec5491f3b5c533fe8" "7ed6913f96c43796aa524e9ae506b0a3a50bfca061eed73b66766d14adfa86d1" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" "25f330cb050c7e7ec402af1b60243e8185a7837b455af0fa026593d4f48a78b2" "4217c670c803e8a831797ccf51c7e6f3a9e102cb9345e3662cc449f4c194ed7d" "0c311fb22e6197daba9123f43da98f273d2bfaeeaeb653007ad1ee77f0003037" "3b819bba57a676edf6e4881bd38c777f96d1aa3b3b5bc21d8266fa5b0d0f1ebf" "dd3eb539595bd7643baaff3a3be67b735a82052c37c2d59192ef51a0983dbfca" "0ae977e603e99d89c80d679377bfed4a904317968bd885ee063455cee01728d3" "2cc9ecf74dd307cdf856a2f47f6149583d6cca9616a0f4ecc058bafa57e4ffa3" "60e97fc4cdb64c43cab637cd0027e09cf27939fe799a1889a30cfedd6f2e7f8e" "7a83132ecb08e86c63d3cbf4b677d4cb1bcfcfb47f4942f2b8ecc7f6ebc2004c" "bb6b64bfb2f63efed8dea1ca03691c07c851a8be6f21675fe4909289d68975d9" "17a8fa9430ffd81f242ed3ee95e59629ccf9e1210657536013a0def9b16e68c9" "c9445e1f0bd72e79e35f3e6f04c22ccf37e3a187a8e5581b84e8ea8116fe0912" "cfd79d66fe6b142b570048ed9a28cd2c71876f824d76e1d9f2da0f3353062f3f" "701b4b4e7989329a0704b92fc17e6600cc18f9df4f2466617ec91c932b5477eb" "9bc1eec9b485726318efd9341df6da8b53fa684931d33beba57ed7207f2090d6" "5cd698ce53179b1e4eaa7917c992832a220600c973967904fea71e3980a46532" "418e15103f9345a289985f6cf63c35ad9732bff6624f38b4672a942c3a6fe354" "4266ac847ba36aa589514aed732de02fe83801ef12e2118f7a65a4a46e20af96" "3a0248176bf115cd53e0f15e30bb338b55e2a09f1f9508794fcd3c623725c8bd" "b48599e24e6db1ea612061252e71abc2c05c05ac4b6ad532ad99ee085c7961a7" "8d1baba3bbafc11628972b5b0a4453b5120be4fb8d30ad0ca4b35d114422dd65" "d422c7673d74d1e093397288d2e02c799340c5dabf70e87558b8e8faa3f83a6c" "cc2f32f5ee19cbd7c139fc821ec653804fcab5fcbf140723752156dc23cdb89f" "008775b6f17cba84b22da8c820d9c6778fac161291f1a9cc252a7e735714bc56" "f2355ec455645cd4a4b8f8ac8bcb96c50bc8f383634e59307d8bc651143f6be4" "9db75254c21afb1ab22cb97a3ac39ccbbd680ef31197605fd5f312e91d84c08c" "73e09ba6f23a9b3aeedb3ee8589da74182b644c169daa62c4454eac73eea610a" "adbe7ba38c551281f21d760de0840cab0e1259964075a7e46cc2b9fdea4b82d6" "aa95b9a243de8c18230ed97315c737ceba2c8ebda8cff997d35b4c2fab5ba007" "71373650950508e648f86e3d1e4a449a859aeb6d8cf791833d9104715d5943a3" "80ee5b0e403162518b90236ba7c31c4f29192c451ad124097f31166c038f2523" "822ee0a190e234546687e145e4fa97c858195023c595ea57878e59e06b25b6e6" "a427ba34c9edff7a5d7a34ecce1e9fc42ac19db18564017a7231ec57c19cde4e" "beeb4fbb490f1a420ea5acc6f589b72c6f0c31dd55943859fc9b60b0c1091468" "4f66410c3d3434129e230eaab99f9319bd5871623689fb56713e38255eb16ddc" "d251c0f968ee538a5f5b54ed90669263f666add9c224ad5411cfabc8abada5a0" "06a610f234492f78a6311304adffa54285b062b3859ad74eb13ca5d74119aef9" "5668fbb51b7467f6a49055b0ba80b54f8998c6a98a267465ec44618db4ab99eb" "d5d41f830f46af348112e869fbdc66315b560d7f8da55c7b067269f890d28911" "0058b7d3e399b6f7681b7e44496ea835e635b1501223797bad7dd5f5d55bb450" "ad97202c92f426a867e83060801938acf035921d5d7e78da3041a999082fb565" "c3806e9426f97f54eccd51bb90c1fabb9205bf359d9ab23311638e1a68aae472" "7ec6a9707c69e7a4ea1a8761b3f28f8dc55c6c5cacd597718c994b1561e435f3" "55573f69249d1cfdd795dacf1680e56c31fdaab4c0ed334b28de96c20eec01a3" "ec0c9d1715065a594af90e19e596e737c7b2cdaa18eb1b71baf7ef696adbefb0" "47e37fa090129214330d13a68549d5c86ccc2c41f4979cb4be130ff945a9859a" "bbb51078321186cbbbcb38f9b74ea154154af10c5d9c61d2b0258cb4401ac038" "d5ecb1ae85bb043a10b8c9f10b40118c9b97806c73410c402340f89abbba8ebb" "87818a78deaefd55594bb4fef802fb4948989996c12f8e0e609c46c6bd038edf" "c1af7190a6855a376f7a7563445687064af6d8bdca423136cb013c93fbfd1b00" "0ff3aeed353697992d100ddf8a94d065a58ffbde5a40afefa605f211757c8ab0" "70b9e0d0b857d6497c6623bb360a3a7f915251c4a6233c30b65f9005eb9f4256" "1faffcddc50d5dc7d334f2817dd6f159ef1820be3aad303eb7f74006531afdff" "fa7b1e3a0bfc7097e9da2f202258897cc6db3fef38d0095881e59a4446ac7d6f" "31ba13fd560daff5b05e11d4be7d280213249225e85969ec5bc71532e788ee81" "81df5c7887aaa76c0174ae54aacd20ab18cc263b95332b09efa0d60a89feaf6a" "8e997c790c6b22c091edb8a866f545857eaae227a0c41df402711f6ebc70326c" "2588175e0f3591583582a72c465e6d38bd8c99b36daee949ab08f1e758052117" "31772cd378fd8267d6427cec2d02d599eee14a1b60e9b2b894dd5487bd30978e" "98e5e942303b4f356d6573009c96087f9b872f2fa258c673188d913f6faf17ea" "ef36e983fa01515298c017d0902524862ec7d9b00c28922d6da093485821e1ba" "fd7ef8af44dd5f240e4e65b8a4eecbc37a07c7896d729a75ba036a59f82cfa58" "3ddfde8b6afe9a72749b73b021ffd5a837f6b9d5c638f7c16d81ec9d346d899f" "e008d9149dd39b249d4f8a9b5c1362d8f85bd11e9c08454e5728fbf0fcc11690" "2c50bf38069a99a18404275e8d139a8a1019a629dab4be9b92b8d5d9c43bbb92" "a405a0c2ec845e34ecb32a83f477ca36d1858b976f028694e0ee7ff4af33e400" "0ca71d3462db28ebdef0529995c2d0fdb90650c8e31631e92b9f02bd1bfc5f36" "cedc71ca0adde34902543489952ebe6fde33b185a690a6f29bcaaefd6ec13fd8" "caa9a86ff9b85f733b424f520ec6ecff3499a36f20eb8d40e3096dbbe1884069" "073ddba1288a18a8fb77c8859498cf1f32638193689b990f7011e1a21ed39538" "a3821772b5051fa49cf567af79cc4dabfcfd37a1b9236492ae4724a77f42d70d" "b42cf9ee9e59c3aec585fff1ce35acf50259d8b59f3047e57df0fa38516aa335" "2d8569fc9eb766b0be02d3f7fbb629bcd26fe34f5d328497e1fc1ddcfd5126b9" "57d7e8b7b7e0a22dc07357f0c30d18b33ffcbb7bcd9013ab2c9f70748cfa4838" "6394ba6170fd0bc9f24794d555fa84676d2bd5e3cfd50b3e270183223f8a6535" "f07583bdbcca020adecb151868c33820dfe3ad5076ca96f6d51b1da3f0db7105" "9dc64d345811d74b5cd0dac92e5717e1016573417b23811b2c37bb985da41da2" "6cf0e8d082a890e94e4423fc9e222beefdbacee6210602524b7c84d207a5dfb5" "f831c1716ebc909abe3c851569a402782b01074e665a4c140e3e52214f7504a0" "89127a6e23df1b1120aa61bd7984f1d5f2747cad1e700614a68bdb7df77189ba" "6ecfc451f545459728a4a8b1d44ac4cdcc5d93465536807d0cb0647ef2bb12c4" "50d8de7ef10b93c4c7251888ff845577004e086c5bfb2c4bb71eca51b474063a" "b39af5ef9cfc7d460bd3659d26731effa17799127d6916c4d85938dda650d4b0" "8016855a07f289a6b2deb248e192633dca0165f07ee5d51f9ba982ec2c36797d" "6981a905808c6137dc3a3b089b9393406d2cbddde1d9336bb9d372cbc204d592" "eb399cbd3ea4c93d9ab15b513fd6638e801600e13c8a70b56f38e609397a5eca" "af4cfe7f2de40f19e0798d46057aae0bccfbc87a85a2d4100339eaf91a1f202a" "6e03b7f86fcca5ce4e63cda5cd0da592973e30b5c5edf198eddf51db7a12b832" "2fc7672758572337a2c9d748d8f53cc7839244642e4409b375baef6152400b4d" "3fe4861111710e42230627f38ebb8f966391eadefb8b809f4bfb8340a4e85529" "5562060e16ae3188e79d87e9ba69d70a6922448bcc5018205850d10696ed0116" "989b6cb60e97759d7c45d65121f43b746aff298b5cf8dcf5cfd19c03830b83e9" "fc89666d6de5e1d75e6fe4210bd20be560a68982da7f352bd19c1033fb7583ba" "551f0e9d6bfc26370c91a0aead8d6579cdedc70c2453cb5ef87a90de51101691" "549c1c977a8eea73021ca2fcc54169d0b2349aaee92d85b6f35e442399cbb61b" "0c5204945ca5cdf119390fe7f0b375e8d921e92076b416f6615bbe1bd5d80c88" "39a854967792547c704cbff8ad4f97429f77dfcf7b3b4d2a62679ecd34b608da" "6c57adb4d3da69cfb559e103e555905c9eec48616104e217502d0a372e63dcea" "0f0adcd1352b15a622afd48fcff8232169aac4b5966841e506f815f81dac44ea" "f34690262d1506627de39945e0bc2c7c47ece167edea85851bab380048dc8580" "f211f8db2328fb031908c9496582e7de2ae8abd5f59a27b4c1218720a7d11803" "2c73700ef9c2c3aacaf4b65a7751b8627b95a1fd8cebed8aa199f2afb089a85f" "9527feeeec43970b1d725bdc04e97eb2b03b15be982ac50089ad223d3c6f2920" "b20e3738bfcc5e1b338308847f74d9d108a3d278ad271999a39e867f9aa76522" "c03d60937e814932cd707a487676875457e0b564a615c1edfd453f23b06fe879" "18ea53ff46d625ce0f515dae0f5b68767b7f555a945c4cd3a1c3e733741206c7" "57f8801351e8b7677923c9fe547f7e19f38c99b80d68c34da6fa9b94dc6d3297" "f0a99f53cbf7b004ba0c1760aa14fd70f2eabafe4e62a2b3cf5cabae8203113b" "c7cd81771525ff66c105413134cdf0330b0b5b88fd8096e5d56b0256872ba6c7" default)))
;;  '(custom-theme-directory "~/.emacs.d/custom-themes")
;;  '(custom-theme-load-path
;;    (quote
;;     ("~/.emacs.d/custom-themes/" custom-theme-directory "~/.emacs.d/elpa/afternoon-theme-20140104.1059" "~/.emacs.d/elpa/ample-theme-20141103.816" "~/.emacs.d/elpa/badger-theme-20140716.1932" "~/.emacs.d/elpa/base16-theme-20130413.1655" "~/.emacs.d/elpa/bliss-theme-20141115.2301" "~/.emacs.d/elpa/boron-theme-20141115.2301" "~/.emacs.d/elpa/clues-theme-20140922.2056" "~/.emacs.d/elpa/cyberpunk-theme-20140630.1800" "~/.emacs.d/elpa/dakrone-theme-20140211.2045" "~/.emacs.d/elpa/dark-krystal-theme-20141115.2301" "~/.emacs.d/elpa/firecode-theme-20141115.2302" "~/.emacs.d/elpa/gruvbox-theme-20141128.816" "~/.emacs.d/elpa/monokai-theme-20141121.1202" "~/.emacs.d/elpa/purple-haze-theme-20141014.1929" "~/.emacs.d/elpa/smyx-theme-20141127.28" "~/.emacs.d/elpa/soothe-theme-20141027.741" "~/.emacs.d/elpa/subatomic256-theme-20130620.1910" "~/.emacs.d/elpa/sublime-themes-20141011.1134" "~/.emacs.d/elpa/tango-2-theme-20120312.1325" "~/.emacs.d/elpa/toxi-theme-20130418.1239" "~/.emacs.d/elpa/waher-theme-20141115.430" "~/.emacs.d/elpa/warm-night-theme-20141024.526" "~/.emacs.d/elpa/zen-and-art-theme-20120622.737" "~/.emacs.d/elpa/zenburn-theme-20141112.923" "~/.emacs.d/elpa/zonokai-theme-20140909.1941" t)))
;;  '(diary-entry-marker (quote font-lock-variable-name-face))
;;  '(dired-listing-switches
;;    "-lahBF --ignore=#* --ignore=.svn --ignore=.git --group-directories-first")
;;  '(electric-pair-mode t)
;;  '(fci-rule-character-color "#202020")
;;  '(fci-rule-color "#383838" t)
;;  '(font-use-system-font t)
;;  '(foreground-color "#cccccc")
;;  '(fringe-mode 6 nil (fringe))
;;  '(global-linum-mode nil)
;;  '(global-undo-tree-mode t)
;;  '(gnus-logo-colors (quote ("#528d8d" "#c0c0c0")))
;;  '(grep-find-command (quote ("find . -type f -exec grep -nHir -e  {} +" . 34)))
;;  '(grep-find-template "find . <X> -type f <F> -exec grep <C> -nH -e <R> {} +")
;;  '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
;;  '(highlight-symbol-colors
;;    (--map
;;     (solarized-color-blend it "#002b36" 0.25)
;;     (quote
;;      ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
;;  '(highlight-symbol-foreground-color "#93a1a1")
;;  '(highlight-tail-colors
;;    (quote
;;     (("#073642" . 0)
;;      ("#546E00" . 20)
;;      ("#00736F" . 30)
;;      ("#00629D" . 50)
;;      ("#7B6000" . 60)
;;      ("#8B2C02" . 70)
;;      ("#93115C" . 85)
;;      ("#073642" . 100))))
;;  '(hl-bg-colors
;;    (quote
;;     ("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00")))
;;  '(hl-fg-colors
;;    (quote
;;     ("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
;;  '(hl-paren-background-colors (quote ("#2492db" "#95a5a6" nil)))
;;  '(hl-paren-colors (quote ("#ecf0f1" "#ecf0f1" "#c0392b")))
;;  '(linum-format "%0d")
;;  '(magit-diff-use-overlays nil)
;;  '(magit-use-overlays nil)
;;  '(main-line-color1 "#1E1E1E")
;;  '(main-line-color2 "#111111")
;;  '(main-line-separator-style (quote chamfer))
;;  '(menu-bar-mode nil)
;;  '(open-resource-ignore-patterns (quote ("/target/" "~$" ".old$" ".svn" "/bin/" ".class$")))
;;  '(org-startup-truncated nil)
;;  '(powerline-color1 "#1E1E1E")
;;  '(powerline-color2 "#111111")
;;  '(read-buffer-completion-ignore-case t)
;;  '(recentf-exclude (quote (".*ido\\.last" "/elpa/" ".*~$" ".*gz$")))
;;  '(recentf-keep (quote (recentf-keep-default-predicate)))
;;  '(recentf-max-saved-items 50)
;;  '(recentf-mode t)
;;  '(safe-local-variable-values (quote ((require-final-newline))))
;;  '(show-paren-mode t)
;;  '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
;;  '(syslog-debug-face
;;    (quote
;;     ((t :background unspecified :foreground "#A1EFE4" :weight bold))))
;;  '(syslog-error-face
;;    (quote
;;     ((t :background unspecified :foreground "#F92672" :weight bold))))
;;  '(syslog-hour-face (quote ((t :background unspecified :foreground "#A6E22E"))))
;;  '(syslog-info-face
;;    (quote
;;     ((t :background unspecified :foreground "#66D9EF" :weight bold))))
;;  '(syslog-ip-face (quote ((t :background unspecified :foreground "#E6DB74"))))
;;  '(syslog-su-face (quote ((t :background unspecified :foreground "#FD5FF0"))))
;;  '(syslog-warn-face
;;    (quote
;;     ((t :background unspecified :foreground "#FD971F" :weight bold))))
;;  '(term-default-bg-color "#002b36")
;;  '(term-default-fg-color "#839496")
;;  '(tool-bar-mode nil)
;;  '(vc-annotate-background "#202020")
;;  '(vc-annotate-color-map
;;    (quote
;;     ((20 . "#C99090")
;;      (40 . "#D9A0A0")
;;      (60 . "#ECBC9C")
;;      (80 . "#DDCC9C")
;;      (100 . "#EDDCAC")
;;      (120 . "#FDECBC")
;;      (140 . "#6C8C6C")
;;      (160 . "#8CAC8C")
;;      (180 . "#9CBF9C")
;;      (200 . "#ACD2AC")
;;      (220 . "#BCE5BC")
;;      (240 . "#CCF8CC")
;;      (260 . "#A0EDF0")
;;      (280 . "#79ADB0")
;;      (300 . "#89C5C8")
;;      (320 . "#99DDE0")
;;      (340 . "#9CC7FB")
;;      (360 . "#E090C7"))))
;;  '(vc-annotate-very-old-color "#E090C7")
;;  '(weechat-color-list
;;    (quote
;;     (unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83"))))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(mode-line ((t (:background "white" :foreground "black"))))
;;  '(mode-line-buffer-id ((t (:foreground "black" :weight bold))))
;;  '(mode-line-highlight ((t (:box (:line-width 2 :color "grey40" :style released-button)))))
;;  '(mode-line-inactive ((t (:inherit mode-line :inverse-video t))))
;;  '(show-paren-match ((t (:background "blue")))))

;; (set-background-color my-background-color)
