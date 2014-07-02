(require 'recentf)

(defgroup open-resource nil
  "Finding resources (files, directories) with glob patterns."
  :group 'open-resource)

(defcustom open-resource-repository-directory "~/CMU/s3/Source/source/"
  "*Set this to your repository to find files in, without prompt."
  :group 'open-resource
  :type 'string)

(defcustom open-resource-ignore-patterns nil
  "List of patterns to ignore in search."
  :group 'open-resource
  :type '(repeat string))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun find-file-in-directory (directory filepattern)
  (interactive "DDirectory: \nMFile pattern: ")

  (defun ignore-command (ignorelist)
    (if ignorelist      
        (concat " | grep -v " (car ignorelist)
                (ignore-command (cdr ignorelist)))
      ""))

  (let ((b (switch-to-buffer "*find-files*")))
    (erase-buffer)
    (shell-command 
     (message
      (concat "find " directory " -iname '*" filepattern  "*'"
              (ignore-command open-resource-ignore-patterns)
              " | awk '{gsub(\"'`pwd`'\",\".\", $0); gsub(\"'$HOME'\",\"~\",$0); print $0}'"))
     b)
    (recentf-open-files
     (split-string (buffer-string) "\n"))))

(defun open-resource (filepattern)
  (interactive "MFile pattern: ")
  (if open-resource-repository-directory
      (find-file-in-directory open-resource-repository-directory filepattern)
    (message "Repository not defined. Use (customize-group open-resource).")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'open-resource)
"find " directory " -iname '*" filepattern  "*'" " | awk '{gsub(\"'`pwd`'\",\".\", $0); gsub(\"'$HOME'\",\"~\",$0); print $0}'"
