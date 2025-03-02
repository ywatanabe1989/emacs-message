;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-03 07:35:29>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/emacs-message-python.el

;; Buffer
;; ----------------------------------------

(defun --em-toggle-buffer-python
    ()
  "Toggle buffer message statements in the buffer."
  (let
      ((orig-pos
        (point)))
    (goto-char
     (point-min))
    (while
        (--em-find-next-message-clause-python)
      (progn
        (forward-char)
        (--em-toggle-comment-next-python)
        (forward-char)))
    (goto-char orig-pos)))

(defun --em-uncomment-buffer-python
    ()
  "Uncomment buffer message statements in the buffer by uncommenting them."
  (let
      ((inhibit-message t))
    (save-excursion
      (goto-char
       (point-min))
      ;; Scan for commented message buffers
      (while
          (re-search-forward ".*#+[ \t]*print(.*)" nil t)
        (when
            (--em-commented-out-p-python)
          (--em-uncomment-next-python))))))

(defun --em-comment-out-buffer-python
    ()
  "Comment-Out buffer message statements in the buffer by commenting them."
  (let
      ((inhibit-message t))
    (save-excursion
      (goto-char
       (point-min))
      (while
          (setq region
                (--em-find-next-message-clause-python))
        (let
            ((start
              (car region))
             (start-of-comment
              (- start 3))
             (end
              (cadr region)))
          (goto-char start-of-comment)
          (unless
              (--em-commented-out-p-python)
            (--em-comment-out-next-python))
          ;; Move point after this message to avoid infinite loop
          (goto-char msg-end))))))

;; Single
;; ----------------------------------------

(defun --em-comment-out-next-python
    ()
  "Comment out next print statement."
  (let
      ((region
        (--em-find-next-message-clause-python)))
    (when region
      (let
          ((start
            (car region))
           (end
            (cadr region)))
        (goto-char end)
        (if
            (not
             (--em-commented-out-p-python))
            (comment-region start end))))))

(defun --em-uncomment-next-python
    ()
  "Uncomment next print statement."
  (let
      ((region
        (--em-find-next-message-clause-python)))
    (when region
      (let*
          ((start
            (car region))
           (start-of-comment
            (- start 3))
           (end
            (cadr region)))
        (goto-char end)
        (when
            (--em-commented-out-p-python)
          (uncomment-region start-of-comment end))))))

(defun --em-toggle-comment-next-python
    ()
  "Comment-out/uncomment next print statement."
  (let
      ((region
        (--em-find-next-message-clause-python)))
    (when region
      (let
          ((start
            (car region))
           (end
            (cadr region)))
        (goto-char start)
        (if
            (--em-commented-out-p-python)
            (--em-uncomment-next-python)
          (--em-comment-out-next-python))))))

(defun --em-toggle-at-point-python
    ()
  "Toggle print statements between active and commented out."
  (save-excursion
    (beginning-of-line)
    ;; Check if the line has a print call (at any nesting level)
    (if
        (looking-at "^\\([ \t]*\\)\\(#\\)?\\([ \t]*\\)\\(.*?print\\)")
        (let*
            ((region
              (--em-find-next-message-clause-python))
             (start
              (car region))
             (end
              (cadr region)))
          (goto-char start)
          (if
              (--em-commented-out-p-python)
              ;; Uncomment the print
              (progn
                (--em-uncomment-next-python)
                (message "Print statement activated"))
            ;; Comment out the print
            (progn
              (--em-comment-out-next-python)
              (message "Print statement commented out"))))
      ;; No print call on this line
      (message "No print statement found at point"))))

;; Helpers
;; ----------------------------------------

(defun --em-find-next-message-clause-python
    ()
  "Find a print statement in current buffer.
Returns a list of (start-pos end-pos) or nil if not found."
  (save-excursion
    (when
        (re-search-forward "print(.*)" nil t)
      (let
          ((print-start
            (match-beginning 0))
           (print-end
            (match-end 0))
           (line-start
            (line-beginning-position)))
        ;; Check if we're not in a function definition
        (save-excursion
          (goto-char line-start)
          (list print-start print-end))))))

(defun --em-find-next-message-clause-python
    ()
  "Find a print statement in current buffer.
Returns a list of (start-pos end-pos) or nil if not found."
  (save-excursion
    (when
        (re-search-forward "print(" nil t)
      (let*
          ((print-start
            (match-beginning 0))
           (line-start
            (line-beginning-position))
           (print-end nil))

        ;; Check if we're not in a function definition
        (save-excursion
          (goto-char line-start)
          (when
              (and
               (not
                (looking-at "^[ \t]*def\\>"))
               (not
                (looking-at "^[ \t]*#[ \t]*def\\>")))

            ;; Find the end of the print statement by tracking parentheses
            (goto-char
             (match-end 0))
            (let
                ((open-parens 1))
              (while
                  (and
                   (> open-parens 0)
                   (not
                    (eobp)))
                (skip-chars-forward "^()")
                (cond
                 ((looking-at "(")
                  (setq open-parens
                        (1+ open-parens))
                  (forward-char 1))
                 ((looking-at ")")
                  (setq open-parens
                        (1- open-parens))
                  (forward-char 1))
                 (t
                  (forward-char 1))))
              (setq print-end
                    (point)))

            (list print-start print-end)))))))

(defun --em-commented-out-p-python
    ()
  "Check if the line at point is commented out.
Returns t if the line is commented out, nil otherwise."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (looking-at "^[ \t]*#")))

(provide 'emacs-message-python)

(when
    (not load-file-name)
  (message "emacs-message-python.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))