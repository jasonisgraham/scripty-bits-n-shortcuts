(defvar xclip-program (executable-find "xclip")
  "Name of XClip program tool.")

(defun xclip-set-region-to-clipboard ()
  (when (and xclip-program (getenv "DISPLAY"))
    (interactive)
    (setq text (buffer-substring (mark) (point)))
    (let* ((process-connection-type nil)
           (proc (start-process "xclip" nil "xclip"
                                "-selection" "clipboard")))
      (process-send-string proc text)
      (process-send-eof proc)
      (keyboard-quit)
      )
    )
  )

(global-set-key "\M-G\M-w" (lambda() (interactive) (xclip-set-region-to-clipboard)))
