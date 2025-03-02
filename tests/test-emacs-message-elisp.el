;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-03 08:11:37>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/tests/test-emacs-message-elisp.el

(require 'ert)
(require 'emacs-message-elisp)

(ert-deftest test-elisp-find-next-message-clause
    ()
  (let
      ((temp-file
        (make-temp-file "emacs-message-test-" nil ".el")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "(defun foo ()\n  (message \"test\"))\n"))
          (with-current-buffer
              (find-file-noselect temp-file)
            (emacs-lisp-mode)
            (goto-char
             (point-min))
            (let
                ((result
                  (--em-find-next-message-clause-elisp)))
              (should result)
              (should
               (=
                (car result)
                17))
              (should
               (=
                (cadr result)
                33))
              (set-buffer-modified-p nil)
              (kill-buffer))))
      (delete-file temp-file))))

(ert-deftest test-elisp-find-next-message-clause-multiline
    ()
  (let
      ((temp-file
        (make-temp-file "emacs-message-test-" nil ".el")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "(defun foo ()\n  (message\n   \"test\"\n   \"more\"))\n"))
          (with-current-buffer
              (find-file-noselect temp-file)
            (emacs-lisp-mode)
            (goto-char
             (point-min))
            (let
                ((result
                  (--em-find-next-message-clause-elisp)))
              (should result)
              (should
               (=
                (car result)
                17))
              (should
               (=
                (cadr result)
                46))
              (set-buffer-modified-p nil)
              (kill-buffer))))
      (delete-file temp-file))))

(ert-deftest test-elisp-commented-out-p
    ()
  (let
      ((temp-file
        (make-temp-file "emacs-message-test-" nil ".el")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert ";; (message \"test\")\n(message \"not-commented\")"))
          (with-current-buffer
              (find-file-noselect temp-file)
            (emacs-lisp-mode)
            (goto-char
             (point-min))
            (should
             (--em-commented-out-p-elisp))
            (forward-line)
            (should-not
             (--em-commented-out-p-elisp))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test-elisp-comment-out-next
    ()
  (let
      ((temp-file
        (make-temp-file "emacs-message-test-" nil ".el")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "(defun foo ()\n  (message \"test\"))\n"))
          (with-current-buffer
              (find-file-noselect temp-file)
            (emacs-lisp-mode)
            (goto-char
             (point-min))
            (--em-comment-out-next-elisp)
            (should
             (string-match-p ";;\\s-*(message \"test\")"
                             (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test-elisp-uncomment-next
    ()
  (let
      ((temp-file
        (make-temp-file "emacs-message-test-" nil ".el")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "(defun foo ()\n  ;; (message \"test\"))\n"))
          (with-current-buffer
              (find-file-noselect temp-file)
            (emacs-lisp-mode)
            (goto-char
             (point-min))
            (--em-uncomment-next-elisp)
            (should
             (string-match-p "(message \"test\")"
                             (buffer-string)))
            (should-not
             (string-match-p ";;"
                             (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test-elisp-toggle-comment-next-commented
    ()
  (let
      ((temp-file
        (make-temp-file "emacs-message-test-" nil ".el")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "(defun foo ()\n  ;; (message \"test\"))\n"))
          (with-current-buffer
              (find-file-noselect temp-file)
            (emacs-lisp-mode)
            (goto-char
             (point-min))
            (--em-toggle-comment-next-elisp)
            (should
             (string-match-p "(message \"test\")"
                             (buffer-string)))
            (should-not
             (string-match-p ";;"
                             (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test-elisp-toggle-comment-next-uncommented
    ()
  (let
      ((temp-file
        (make-temp-file "emacs-message-test-" nil ".el")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "(defun foo ()\n  (message \"test\"))\n"))
          (with-current-buffer
              (find-file-noselect temp-file)
            (emacs-lisp-mode)
            (goto-char
             (point-min))
            (--em-toggle-comment-next-elisp)
            (should
             (string-match-p ";;\\s-*(message \"test\")"
                             (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test-elisp-toggle-buffer
    ()
  (let
      ((temp-file
        (make-temp-file "emacs-message-test-" nil ".el")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "(defun foo ()\n  (message \"test1\")\n  (message \"test2\"))\n"))
          (with-current-buffer
              (find-file-noselect temp-file)
            (emacs-lisp-mode)
            (--em-toggle-buffer-elisp)
            (sleep-for 0.1)
            (should
             (string-match-p ";;\\s-*(message \"test1\")"
                             (buffer-string)))
            (should
             (string-match-p ";;\\s-*(message \"test2\")"
                             (buffer-string)))
            (--em-toggle-buffer-elisp)
            (should
             (string-match-p "(message \"test1\")"
                             (buffer-string)))
            (should
             (string-match-p "(message \"test2\")"
                             (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test-elisp-uncomment-buffer
    ()
  (let
      ((temp-file
        (make-temp-file "emacs-message-test-" nil ".el")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "(defun foo ()\n  ;; (message \"test1\")\n  ;; (message \"test2\"))\n"))
          (with-current-buffer
              (find-file-noselect temp-file)
            (emacs-lisp-mode)
            (save-buffer)
            (let
                ((inhibit-message t)
                 (buffer-contents
                  (buffer-string)))
              (--em-uncomment-buffer-elisp))
            (should
             (string-match-p "(message \"test1\")"
                             (buffer-string)))
            (should
             (string-match-p "(message \"test2\")"
                             (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test-elisp-comment-out-buffer
    ()
  (let
      ((temp-file
        (make-temp-file "emacs-message-test-" nil ".el")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "(defun foo ()\n  (message \"test1\")\n  (message \"test2\"))\n"))
          (with-current-buffer
              (find-file-noselect temp-file)
            (emacs-lisp-mode)
            (--em-comment-out-buffer-elisp)
            (should
             (string-match-p ";;\\s-*(message \"test1\")"
                             (buffer-string)))
            (should
             (string-match-p ";;\\s-*(message \"test2\")"
                             (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(provide 'test-emacs-message-elisp)

(when
    (not load-file-name)
  (message "test-emacs-message-elisp.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))