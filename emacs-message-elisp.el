;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-03 00:23:34>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/emacs-message-elisp.el

(defun --em-toggle-at-point-elisp
    ()
  "Toggle message statements between active and commented out."
  (interactive)
  (save-excursion
    (beginning-of-line)
    ;; Check if the line has a message call (at any nesting level)
    (if
        (looking-at "^\\([ \t]*\\)\\(;+\\)?\\([ \t]*\\)\\(.*?(message\\)")
        (let
            ((indent
              (match-string 1))
             (comment
              (match-string 2))
             (post-comment-space
              (match-string 3)))
          (if comment
              ;; Uncomment the message
              (progn
                (delete-region
                 (match-beginning 2)
                 (match-end 3))
                (message "Message call activated"))
            ;; Comment out the message
            (progn
              (goto-char
               (match-beginning 3))
              (insert ";; ")
              (message "Message call commented out"))))
      ;; No message call on this line
      (message "No message call found at point"))))

(defun --em-toggle-all-elisp
    ()
  "Toggle all message statements in the buffer."
  (interactive)
  (let
      ((count 0)
       (inhibit-message t))
    (save-excursion
      (goto-char
       (point-min))
      (while
          (re-search-forward "(message\\b" nil t)
        (setq count
              (1+ count))
        (let
            ((line-start
              (line-beginning-position))
             (line-end
              (line-end-position)))
          (beginning-of-line)
          (--em-toggle-at-point-elisp)
          ;; Move point after this line to avoid infinite loop
          (goto-char line-end)
          (forward-char 1))))
    (message "Toggled %d message statements" count)))

(defun --em-enable-all-elisp
    ()
  "Enable all message statements in the buffer by uncommenting them."
  (interactive)
  (let
      ((count 0)
       (inhibit-message t))
    (save-excursion
      (goto-char
       (point-min))
      (while
          (re-search-forward "^[ \t]*;;[ \t]*(message\\b" nil t)
        (let
            ((line-start
              (line-beginning-position))
             (msg-found t)
             (paren-level 1)
             (msg-start nil)
             (msg-end nil))

          ;; Uncomment this line
          (goto-char line-start)
          (when
              (looking-at "^\\([ \t]*\\)\\(;;\\)[ \t]*(message\\b")
            (delete-region
             (match-beginning 2)
             (match-end 2))
            (setq count
                  (1+ count))
            (setq msg-start
                  (point))

            ;; Find end of this message expression
            (search-forward "(message" nil t)
            (while
                (and
                 (> paren-level 0)
                 (not
                  (eobp)))
              (cond
               ((eq
                 (char-after)
                 ?\()
                (setq paren-level
                      (1+ paren-level)))
               ((eq
                 (char-after)
                 ?\))
                (setq paren-level
                      (1- paren-level))))

              ;; If we encounter a commented line that's part of this message expression
              (when
                  (and
                   (=
                    (char-after)
                    ?\n)
                   (> paren-level 0))
                (forward-char 1)
                (when
                    (looking-at "^\\([ \t]*\\)\\(;;\\)[ \t]*")
                  (delete-region
                   (match-beginning 2)
                   (match-end 2))
                  (setq count
                        (1+ count))))

              (forward-char 1)
              (when
                  (= paren-level 0)
                (setq msg-end
                      (point))))))))

    (message "Enabled %d message statements" count)))

(defun --em-enable-all-elisp
    ()
  "Enable all message statements in the buffer by uncommenting them."
  (interactive)
  (let
      ((count 0)
       (inhibit-message t))
    (save-excursion
      (goto-char
       (point-min))
      (while
          (re-search-forward "^\\([ \t]*\\);+[ \t]*\\(.*?(message\\)" nil t)
        (setq count
              (1+ count))
        (beginning-of-line)
        (when
            (looking-at "^\\([ \t]*\\)\\(;+\\)\\([ \t]*\\)\\(.*?(message\\)")
          (delete-region
           (match-beginning 2)
           (match-end 3))
          (goto-char
           (line-end-position))
          (forward-char 1))))
    (message "Enabled %d message statements" count)))

;; (defun --em-disable-all-elisp
;;     ()
;;   "Disable all message statements in the buffer by commenting them."
;;   (interactive)
;;   (let
;;       ((count 0)
;;        (inhibit-message t))
;;     (save-excursion
;;       (goto-char
;;        (point-min))
;;       (while
;;           (re-search-forward "(message\\b" nil t)
;;         (let
;;             ((msg-start
;;               (match-beginning 0))
;;              (paren-level 1)
;;              (msg-end nil))

;;           ;; Check if already commented
;;           (save-excursion
;;             (goto-char msg-start)
;;             (beginning-of-line)
;;             (unless
;;                 (looking-at "^[ \t]*;;")
;;               ;; Find end of message expression
;;               (goto-char
;;                (1+ msg-start))
;;               ;; Skip the opening paren
;;               (while
;;                   (and
;;                    (> paren-level 0)
;;                    (not
;;                     (eobp)))
;;                 (cond
;;                  ((eq
;;                    (char-after)
;;                    ?\()
;;                   (setq paren-level
;;                         (1+ paren-level)))
;;                  ((eq
;;                    (char-after)
;;                    ?\))
;;                   (setq paren-level
;;                         (1- paren-level))))
;;                 (forward-char 1)
;;                 (when
;;                     (= paren-level 0)
;;                   (setq msg-end
;;                         (point))))

;;               ;; Now handle the message expression
;;               (goto-char msg-start)
;;               (beginning-of-line)
;;               (let
;;                   ((start-line
;;                     (line-number-at-pos))
;;                    (end-line
;;                     (line-number-at-pos msg-end)))
;;                 ;; Insert newline after the message expression to isolate it
;;                 (goto-char msg-end)
;;                 (unless
;;                     (looking-at "[ \t]*$")
;;                   (insert "\n"))

;;                 ;; Comment out each line
;;                 (goto-char msg-start)
;;                 (beginning-of-line)
;;                 (while
;;                     (<=
;;                      (line-number-at-pos)
;;                      end-line)
;;                   (unless
;;                       (looking-at "^[ \t]*;;")
;;                     (insert ";; ")
;;                     (setq count
;;                           (1+ count)))
;;                   (forward-line 1))))))

;;         ;; Continue search after this point
;;         (forward-char 1)))
;;     (message "Disabled %d message statements" count)))

;; (defun --em-disable-all-elisp ()
;;   "Disable all message statements in the buffer by commenting them."
;;   (interactive)
;;   (let ((count 0)
;;         (inhibit-message t))
;;     (save-excursion
;;       (goto-char (point-min))
;;       (while (re-search-forward "(message\\b" nil t)
;;         (let ((msg-start (match-beginning 0))
;;               (paren-level 1)
;;               (msg-end nil))

;;           ;; Check if already commented
;;           (save-excursion
;;             (goto-char msg-start)
;;             (beginning-of-line)
;;             (unless (looking-at "^[ \t]*;;")
;;               ;; Find end of message expression
;;               (goto-char (1+ msg-start)) ;; Skip the opening paren
;;               (while (and (> paren-level 0) (not (eobp)))
;;                 (cond ((eq (char-after) ?\() (setq paren-level (1+ paren-level)))
;;                       ((eq (char-after) ?\)) (setq paren-level (1- paren-level))))
;;                 (forward-char 1)
;;                 (when (= paren-level 0)
;;                   (setq msg-end (point))))

;;               ;; Now handle the message expression
;;               (goto-char msg-start)
;;               (beginning-of-line)
;;               (let ((start-line (line-number-at-pos))
;;                     (end-line (line-number-at-pos msg-end)))
;;                 ;; Insert newline after the message expression to isolate it
;;                 (goto-char msg-end)
;;                 (unless (looking-at "[ \t]*$")
;;                   (insert "\n"))

;;                 ;; Comment out each line
;;                 (goto-char msg-start)
;;                 (beginning-of-line)
;;                 (while (<= (line-number-at-pos) end-line)
;;                   (unless (looking-at "^[ \t]*;;")
;;                     (let ((indentation (current-indentation)))
;;                       (beginning-of-line)
;;                       (insert ";; ")
;;                       (setq count (1+ count))))
;;                   (forward-line 1))))))

;;         ;; Continue search after this point
;;         (forward-char 1)))
;;     (message "Disabled %d message statements" count)))

(defun --em-disable-all-elisp
    ()
  "Disable all message statements in the buffer by commenting them."
  (interactive)
  (let
      ((count 0)
       (inhibit-message t))
    (save-excursion
      (goto-char
       (point-min))
      (while
          (re-search-forward "(message\\b" nil t)
        (let
            ((msg-start
              (match-beginning 0))
             (paren-level 1)
             (msg-end nil))

          ;; Check if already commented
          (save-excursion
            (goto-char msg-start)
            (unless
                (save-excursion
                  (beginning-of-line)
                  (looking-at "^[ \t]*;;"))
              ;; Find end of message expression
              (goto-char
               (1+ msg-start))
              ;; Skip the opening paren
              (while
                  (and
                   (> paren-level 0)
                   (not
                    (eobp)))
                (cond
                 ((eq
                   (char-after)
                   ?\()
                  (setq paren-level
                        (1+ paren-level)))
                 ((eq
                   (char-after)
                   ?\))
                  (setq paren-level
                        (1- paren-level))))
                (forward-char 1)
                (when
                    (= paren-level 0)
                  (setq msg-end
                        (point))))

              ;; Insert comment directly before (message
              (goto-char msg-start)
              (insert ";; ")
              (delete-char 1)
              ;; Delete the opening paren
              (insert "(")
              ;; Put it back
              (setq count
                    (1+ count)))))))

    (message "Disabled %d message statements" count)))

(provide 'emacs-message-elisp)

(when
    (not load-file-name)
  (message "emacs-message-elisp.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))