;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-08 11:01:41>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/emacs-message-shell.el

;; Buffer
;; ----------------------------------------

(defun --em-toggle-buffer-shell ()
  "Toggle echo statements in the shell script buffer.
This comments out all uncommented echo statements and uncomments all commented ones."
  (interactive)
  (let ((orig-pos (point))
        (toggle-count 0))
    ;; First pass: Comment out all uncommented echo statements
    (goto-char (point-min))
    (while (re-search-forward "^[ \t]*echo[ \t]+" nil t)
      (beginning-of-line)
      (--em-comment-out-next-shell)
      (setq toggle-count (1+ toggle-count))
      (end-of-line))

    ;; Second pass: Uncomment all commented echo statements
    (goto-char (point-min))
    (while (re-search-forward "^[ \t]*#[ \t]*echo[ \t]+" nil t)
      (beginning-of-line)
      (--em-uncomment-next-shell)
      (setq toggle-count (1+ toggle-count))
      (end-of-line))

    (goto-char orig-pos)
    (message "Toggled %d echo statements" toggle-count)))

(defun --em-uncomment-buffer-shell ()
  "Uncomment all echo statements in the shell script buffer."
  (interactive)
  (let ((count 0)
        (inhibit-message t))
    (save-excursion
      (goto-char (point-min))
      ;; Scan for commented echo statements
      (while
          (re-search-forward "^[ \t]*#[ \t]*echo[ \t]+"
                             nil t)
        (beginning-of-line)
        (when (--em-commented-out-p-shell)
          (--em-uncomment-next-shell)
          (setq count (1+ count)))))
    (message "Uncommented %d echo statements" count)))

(defun --em-comment-out-buffer-shell ()
  "Comment out all echo statements in the shell script buffer."
  (interactive)
  (let ((count 0)
        (inhibit-message t))
    (save-excursion
      (goto-char (point-min))
      (while (setq msg-bounds (--em-find-next-message-clause-shell))
        (let ((msg-start (car msg-bounds))
              (msg-end (cadr msg-bounds)))
          (goto-char msg-start)
          (unless (--em-commented-out-p-shell)
            (--em-comment-out-next-shell)
            (setq count (1+ count)))
          ;; Move point after this message to avoid infinite loop
          (goto-char msg-end)
          (forward-char 1))))
    (message "Commented %d echo statements" count)))

;; Single
;; ----------------------------------------

(defun --em-comment-out-next-shell ()
  "Comment out next echo statement."
  (interactive)
  (let ((region (--em-find-next-message-clause-shell)))
    (if region
        (let ((start (car region))
              (end (cadr region)))
          (goto-char start)
          (if (not (--em-commented-out-p-shell))
              (comment-region start end)))
      (message "No echo statement found"))))

(defun --em-uncomment-next-shell ()
  "Uncomment next echo statement."
  (interactive)
  (let ((region (--em-find-next-message-clause-shell)))
    (if region
        (let* ((start (car region))
               (end (cadr region)))
          (goto-char start)
          (if (--em-commented-out-p-shell)
              (uncomment-region start end)))
      (message "No echo statement found"))))

(defun --em-toggle-comment-next-shell ()
  "Toggle comment for next echo statement."
  (interactive)
  (let ((region (--em-find-next-message-clause-shell)))
    (if region
        (let ((start (car region))
              (end (cadr region)))
          (goto-char start)
          (if (--em-commented-out-p-shell)
              (--em-uncomment-next-shell)
            (--em-comment-out-next-shell)))
      (message "No echo statement found"))))

(defun --em-toggle-at-point-shell ()
  "Toggle echo statement at point."
  (interactive)
  (save-excursion
    (beginning-of-line)
    ;; Check if line has an echo statement
    (if
        (looking-at
         "^\\([ \t]*\\)\\(#\\)?\\([ \t]*\\)\\(echo[ \t]+.*\\)")
        (let*
            ((region
              (list (line-beginning-position) (line-end-position))))
          (if (--em-commented-out-p-shell)
              ;; Uncomment the echo
              (progn
                (--em-uncomment-next-shell)
                (message "Echo statement activated"))
            ;; Comment out the echo
            (progn
              (--em-comment-out-next-shell)
              (message "Echo statement commented out"))))
      ;; No echo call on this line
      (message "No echo statement found at point"))))

;; Helpers
;; ----------------------------------------

(defun --em-find-next-message-clause-shell ()
  "Find an echo statement in shell script, whether commented or not.
Returns a list of (start-pos end-pos) or nil if not found."
  (interactive)
  (save-excursion
    (when (re-search-forward "\\(^[ \t]*#[ \t]*\\)?echo[ \t]+" nil t)
      (let* ((line-start (line-beginning-position))
             (line-end (line-end-position)))
        ;; We work with whole lines for shell scripts
        (list line-start line-end)))))

(defun --em-commented-out-p-shell ()
  "Check if the line at point is commented out in shell script.
Returns t if the line is commented out, nil otherwise."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (looking-at "^[ \t]*#")))

(provide 'emacs-message-shell)

(when
    (not load-file-name)
  (message "emacs-message-shell.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))