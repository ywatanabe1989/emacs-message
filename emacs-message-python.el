;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-02 22:35:55>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/emacs-message-python.el

(defun --em-toggle-at-point-python
    ()
  "Toggle print statements between active and commented out in Python."
  (interactive)
  (save-excursion
    (beginning-of-line)
    ;; Check if the line has a print call (at any nesting level)
    (if
        (looking-at "^\\([ \t]*\\)\\(#\\)?\\([ \t]*\\)\\(.*?print\\)")
        (let
            ((indent
              (match-string 1))
             (comment
              (match-string 2))
             (post-comment-space
              (match-string 3)))
          (if comment
              ;; Uncomment the print statement
              (progn
                (delete-region
                 (match-beginning 2)
                 (match-end 3))
                (message "Print statement activated"))
            ;; Comment out the print statement
            (progn
              (goto-char
               (match-beginning 3))
              (insert "# ")
              (message "Print statement commented out"))))
      ;; No print call on this line
      (message "No print statement found at point"))))

(defun --em-toggle-all-python
    ()
  "Toggle all print statements in the buffer."
  (interactive)
  (let
      ((count 0)
       (inhibit-message t))
    (save-excursion
      (goto-char
       (point-min))
      (while
          (re-search-forward "print\\b" nil t)
        (setq count
              (1+ count))
        (let
            ((line-start
              (line-beginning-position))
             (line-end
              (line-end-position)))
          (beginning-of-line)
          (--em-toggle-at-point-python)
          ;; Move point after this line to avoid infinite loop
          (goto-char line-end)
          (forward-char 1))))
    (message "Toggled %d print statements" count)))

(defun --em-enable-all-python
    ()
  "Enable all print statements in the Python buffer by uncommenting them."
  (interactive)
  (let
      ((count 0)
       (inhibit-message t))
    (save-excursion
      (goto-char
       (point-min))
      (while
          (re-search-forward "^\\([ \t]*\\)#[ \t]*\\(.*?print\\)" nil t)
        (setq count
              (1+ count))
        (beginning-of-line)
        (when
            (looking-at "^\\([ \t]*\\)\\(#\\)\\([ \t]*\\)\\(.*?print\\)")
          (delete-region
           (match-beginning 2)
           (match-end 3))
          (goto-char
           (line-end-position))
          (forward-char 1))))
    (message "Enabled %d print statements" count)))

(defun --em-disable-all-python
    ()
  "Disable all print statements in the buffer by commenting them."
  (interactive)
  (let
      ((count 0)
       (inhibit-message t))
    (save-excursion
      (goto-char
       (point-min))
      (while
          (re-search-forward "^[ \t]*\\([^#].*\\<print\\>\\)" nil t)
        (setq count
              (1+ count))
        (beginning-of-line)
        (insert "# ")
        (forward-line)))
    (message "Disabled %d print statements" count)))

(provide 'emacs-message-python)

(when
    (not load-file-name)
  (message "emacs-message-python.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))