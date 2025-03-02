;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-03 07:20:23>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/emacs-message-main.el

(require 'emacs-message-elisp)
(require 'emacs-message-python)

;; Main
;; ----------------------------------------

(defun em-toggle-buffer
    ()
  "Toggle buffer message statements based on current buffer's language."
  (interactive)
  (let
      ((lang
        (--em-get-language-type)))
    (cond
     ((eq lang 'elisp)
      (--em-toggle-buffer-elisp))
     ((eq lang 'python)
      (--em-toggle-buffer-python))
     (t
      (message "Unsupported language mode")))))

(defun em-uncomment-buffer
    ()
  "Uncomment buffer message statements based on current buffer's language."
  (interactive)
  (let
      ((lang
        (--em-get-language-type)))
    (cond
     ((eq lang 'elisp)
      (--em-uncomment-buffer-elisp))
     ((eq lang 'python)
      (--em-uncomment-buffer-python))
     (t
      (message "Unsupported language mode")))))

(defun em-comment-out-buffer
    ()
  "Comment-Out buffer message statements based on current buffer's language."
  (interactive)
  (let
      ((lang
        (--em-get-language-type)))
    (cond
     ((eq lang 'elisp)
      (--em-comment-out-buffer-elisp))
     ((eq lang 'python)
      (--em-comment-out-buffer-python))
     (t
      (message "Unsupported language mode")))))

;; Single
;; ----------------------------------------

(defun em-toggle-comment-out-next
    ()
  "Comment out next printing statement."
  (interactive)
  (let
      ((lang
        (--em-get-language-type)))
    (cond
     ((eq lang 'elisp)
      (--em-toggle-comment-next-elisp))
     ((eq lang 'python)
      (--em-toggle-comment-next-python))
     (t
      (message "Unsupported language mode")))))

(defun em-uncomment-next
    ()
  "Uncomment next printing statement."
  (interactive)
  (let
      ((lang
        (--em-get-language-type)))
    (cond
     ((eq lang 'elisp)
      (--em-uncomment-next-elisp))
     ((eq lang 'python)
      (--em-uncomment-next-python))
     (t
      (message "Unsupported language mode")))))

(defun em-toggle-comment-next
    ()
  "Toggle message statements at point based on current buffer's language."
  (interactive)
  (let
      ((lang
        (--em-get-language-type)))
    (cond
     ((eq lang 'elisp)
      (--em-toggle-comment-next-elisp))
     ((eq lang 'python)
      (--em-toggle-comment-next-python))
     (t
      (message "Unsupported language mode")))))

(defun em-toggle-at-point
    ()
  "Toggle message statements at point based on current buffer's language."
  (interactive)
  (let
      ((lang
        (--em-get-language-type)))
    (cond
     ((eq lang 'elisp)
      (--em-toggle-at-point-elisp))
     ((eq lang 'python)
      (--em-toggle-at-point-python))
     (t
      (message "Unsupported language mode")))))

;; Helper
;; ----------------------------------------

(defun --em-get-language-type
    ()
  "Determine what kind of language the current buffer is using."
  (cond
   ((or
     (derived-mode-p 'emacs-lisp-mode)
     (derived-mode-p 'lisp-mode)
     (derived-mode-p 'scheme-mode)
     (string-match "\\.el$"
                   (or
                    (buffer-file-name)
                    "")))
    'elisp)
   ((or
     (derived-mode-p 'python-mode)
     (string-match "\\.py$"
                   (or
                    (buffer-file-name)
                    "")))
    'python)
   (t nil)))

(provide 'emacs-message-main)

(when
    (not load-file-name)
  (message "emacs-message-main.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))