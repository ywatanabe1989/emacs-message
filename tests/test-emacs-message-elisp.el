;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-03 00:22:07>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/tests/test-emacs-message-elisp.el

(require 'ert)
(require 'emacs-message-elisp)

(ert-deftest test--em-toggle-at-point-elisp-active-to-comment
    ()
  (with-temp-buffer
    (insert "(defun test ()\n  (message \"test\"))\n")
    (goto-char
     (point-min))
    (forward-line 1)
    (--em-toggle-at-point-elisp)
    (should
     (string=
      (buffer-string)
      "(defun test ()\n  ;; (message \"test\"))\n"))))

(ert-deftest test--em-toggle-at-point-elisp-comment-to-active
    ()
  (with-temp-buffer
    (insert "(defun test ()\n  ;; (message \"test\"))\n")
    (goto-char
     (point-min))
    (forward-line 1)
    (--em-toggle-at-point-elisp)
    (should
     (string=
      (buffer-string)
      "(defun test ()\n  (message \"test\"))\n"))))

(ert-deftest test--em-toggle-all-elisp
    ()
  (with-temp-buffer
    (insert "(defun test ()\n    ;; (message \"test1\")\n    (message \"test2\"))\n")
    (--em-toggle-all-elisp)
    (should
     (string=
      (buffer-string)
      "(defun test ()\n    (message \"test1\")\n    ;; (message \"test2\"))\n"))))

(ert-deftest test--em-enable-all-elisp
    ()
  (with-temp-buffer
    (insert "(defun test ()\n  ;; (message \"test1\")\n  (message \"test2\"))\n")
    (--em-enable-all-elisp)
    (should
     (string=
      (buffer-string)
      "(defun test ()\n  (message \"test1\")\n  (message \"test2\"))\n"))))

(ert-deftest test--em-disable-all-elisp
    ()
  (with-temp-buffer
    (insert "(defun test ()\n    (message \"test1\")\n    ;; (message \"test2\")\n)")

    (--em-disable-all-elisp)
    (should
     (string=
      (buffer-string)
      "(defun test ()\n    ;; (message \"test1\")\n    ;; (message \"test2\")\n)"))))

(provide 'test-emacs-message-elisp)

(when
    (not load-file-name)
  (message "test-emacs-message-elisp.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))