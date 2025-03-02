;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-02 22:51:54>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/tests/test-emacs-message-python.el

;;; test-emacs-message-python.el --- Tests for emacs-message-python -*- lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-02 22:30:20>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/test-emacs-message-python.el

(require 'ert)
(require 'emacs-message-python)

(ert-deftest test--em-toggle-at-point-python-active-to-comment
    ()
  (with-temp-buffer
    (insert "def test():\n    print(\"test\")\n")
    (goto-char
     (point-min))
    (forward-line 1)
    (--em-toggle-at-point-python)
    (should
     (string=
      (buffer-string)
      "def test():\n    # print(\"test\")\n"))))

(ert-deftest test--em-toggle-at-point-python-comment-to-active
    ()
  (with-temp-buffer
    (insert "def test():\n    # print(\"test\")\n")
    (goto-char
     (point-min))
    (forward-line 1)
    (--em-toggle-at-point-python)
    (should
     (string=
      (buffer-string)
      "def test():\n    print(\"test\")\n"))))

(ert-deftest test--em-toggle-all-python
    ()
  (with-temp-buffer
    (insert "def test():\n    print(\"test1\")\n    print(\"test2\")\n")
    (--em-toggle-all-python)
    (should
     (string=
      (buffer-string)
      "def test():\n    # print(\"test1\")\n    # print(\"test2\")\n"))))

(ert-deftest test--em-enable-all-python
    ()
  (with-temp-buffer
    (insert "def test():\n    # print(\"test1\")\n    print(\"test2\")\n")
    (--em-enable-all-python)
    (should
     (string=
      (buffer-string)
      "def test():\n    print(\"test1\")\n    print(\"test2\")\n"))))

(ert-deftest test--em-disable-all-python
    ()
  (with-temp-buffer
    (insert "def test():\n    print(\"test1\")\n    # print(\"test2\")\n")
    (--em-disable-all-python)
    (should
     (string=
      (buffer-string)
      "def test():\n#     print(\"test1\")\n#     # print(\"test2\")\n"))))

(provide 'test-emacs-message-python)

(when
    (not load-file-name)
  (message "test-emacs-message-python.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))