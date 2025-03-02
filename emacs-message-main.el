;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-02 22:28:45>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/emacs-message-main.el

;; Main
;; ----------------------------------------

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

(defun em-toggle-all
    ()
  "Toggle all message statements based on current buffer's language."
  (interactive)
  (let
      ((lang
        (--em-get-language-type)))
    (cond
     ((eq lang 'elisp)
      (--em-toggle-all-elisp))
     ((eq lang 'python)
      (--em-toggle-all-python))
     (t
      (message "Unsupported language mode")))))

(defun em-enable-all
    ()
  "Enable all message statements based on current buffer's language."
  (interactive)
  (let
      ((lang
        (--em-get-language-type)))
    (cond
     ((eq lang 'elisp)
      (--em-enable-all-elisp))
     ((eq lang 'python)
      (--em-enable-all-python))
     (t
      (message "Unsupported language mode")))))

(defun em-disable-all
    ()
  "Disable all message statements based on current buffer's language."
  (interactive)
  (let
      ((lang
        (--em-get-language-type)))
    (cond
     ((eq lang 'elisp)
      (--em-disable-all-elisp))
     ((eq lang 'python)
      (--em-disable-all-python))
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