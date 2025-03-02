;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-03 08:08:10>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/emacs-message-elisp.el

(require 'paren)

;; Buffer
;; ----------------------------------------

(defun --em-toggle-buffer-elisp
    ()
  "Toggle buffer message statements in the buffer."
  (let
      ((orig-pos
        (point)))
    (goto-char
     (point-min))
    (while
        (--em-find-next-message-clause-elisp)
      (progn
        (forward-char)
        (--em-toggle-comment-next-elisp)
        (forward-char)))
    (goto-char orig-pos)))

(defun --em-uncomment-buffer-elisp
    ()
  "Uncomment buffer message statements in the buffer by uncommenting them."
  (let
      ((count 0)
       (inhibit-message t))
    (save-excursion
      (goto-char
       (point-min))
      ;; Scan for commented message buffers
      (while
          (re-search-forward "^[ \t]*;+[ \t]*(message\\b" nil t)
        (beginning-of-line)
        (when
            (--em-commented-out-p-elisp)
          (--em-uncomment-next-elisp)
          (setq count
                (1+ count)))))
    (message "Uncommented %d message statements" count)))

(defun --em-comment-out-buffer-elisp
    ()
  "Comment-Out buffer message statements in the buffer by commenting them."
  (let
      ((count 0)
       (inhibit-message t))
    (save-excursion
      (goto-char
       (point-min))
      (while
          (setq msg-bounds
                (--em-find-next-message-clause-elisp))
        (let
            ((msg-start
              (car msg-bounds))
             (msg-end
              (cadr msg-bounds)))
          (goto-char msg-start)
          (unless
              (--em-commented-out-p-elisp)
            (--em-comment-out-next-elisp)
            (setq count
                  (1+ count)))
          ;; Move point after this message to avoid infinite loop
          (goto-char msg-end))))))

;; Single
;; ----------------------------------------

(defun --em-comment-out-next-elisp
    ()
  "Comment out next commenting block."
  (let
      ((region
        (--em-find-next-message-clause-elisp)))
    (when region
      (let
          ((start
            (car region))
           (end
            (cadr region)))
        (goto-char end)
        (if
            (not
             (--em-commented-out-p-elisp))
            (comment-region start end))))))

(defun --em-uncomment-next-elisp
    ()
  "Uncomment next commenting block."
  (let
      ((region
        (--em-find-next-message-clause-elisp)))
    (when region
      (let*
          ((start
            (car region))
           (start-of-comment
            (- start 3))
           (end
            (cadr region)))
        (goto-char end)
        (if
            (--em-commented-out-p-elisp)
            (uncomment-region start-of-comment end))))))

(defun --em-toggle-comment-next-elisp
    ()
  "Comment-out/uncomment next commenting block."
  (let
      ((region
        (--em-find-next-message-clause-elisp)))
    (when region
      (let
          ((start
            (car region))
           (end
            (cadr region)))
        (goto-char start)
        (if
            (--em-commented-out-p-elisp)
            (--em-uncomment-next-elisp)
          (--em-comment-out-next-elisp))))))

(defun --em-toggle-at-point-elisp
    ()
  "Toggle message statements between active and commented out."
  (save-excursion
    (beginning-of-line)
    ;; Check if the line has a message call (at any nesting level)
    (if
        (looking-at "^\\([ \t]*\\)\\(;+\\)?\\([ \t]*\\)\\(.*?;; ;; ;; (message\\)
")
        (let*
            ((region
              (--em-find-next-message-clause-elisp))
             (start
              (car region))
             (end
              (cadr region)))
          (goto-char start)
          (if
              (--em-commented-out-p-elisp)
              ;; Uncomment the message
              (progn
                (--em-uncomment-next-elisp)
                (message "Message call activated"))
            ;; Comment out the message
            (progn
              (--em-comment-out-next-elisp)
              (message "Message call commented out"))))
      ;; No message call on this line
      (message "No message call found at point"))))

;; Helpers
;; ----------------------------------------

(defun --em-find-next-message-clause-elisp
    ()
  "Find a message clause in current buffer.
Returns a list of (start-pos end-pos) or nil if not found."
  (save-excursion
    (when
        (re-search-forward "(message\\b" nil t)
      (let
          ((msg-start
            (match-beginning 0))
           (paren-level 1)
           (msg-end nil))
        ;; Find end of message expression
        (goto-char
         (1+ msg-start))
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
        (when msg-end
          (list msg-start msg-end))))))

(defun --em-commented-out-p-elisp
    ()
  "Check if the line at point is commented out.
Returns t if the line is commented out, nil otherwise."
  (save-excursion
    (beginning-of-line)
    (looking-at "^[ \t]*;")))

(provide 'emacs-message-elisp)

(when
    (not load-file-name)
  (message "emacs-message-elisp.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))