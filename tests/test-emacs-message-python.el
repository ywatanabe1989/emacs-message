;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-03 08:15:56>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/tests/test-emacs-message-python.el

(ert-deftest test--em-find-next-print-clause-python
    ()
  "Test the print clause finder on single-line print statements."
  (let
      ((temp-file
        (make-temp-file "emacs-message-test-" nil ".py")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "def test():\n    print(\"on\")\n"))
          (with-current-buffer
              (find-file-noselect temp-file)
            (goto-char
             (point-min))
            (let
                ((bounds
                  (--em-find-next-print-clause-python)))
              (should bounds)
              (should
               (=
                (car bounds)
                17))
              ;; Start of 'print'
              (should
               (=
                (cadr bounds)
                28))
              ;; End after ')'
              (kill-buffer))))
      (delete-file temp-file))))

(ert-deftest test--em-find-next-print-clause-python-multi-line
    ()
  "Test the print clause finder on multi-line print statements."
  (let
      ((temp-file
        (make-temp-file "emacs-message-test-" nil ".py")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "def test():\n    print(\n        \"on\"\n        \"on\"\n    )\n"))
          (with-current-buffer
              (find-file-noselect temp-file)
            (python-mode)
            (goto-char
             (point-min))
            (let
                ((bounds
                  (--em-find-next-print-clause-python)))
              (should bounds)
              (should
               (=
                (car bounds)
                17))
              ;; Start of 'print'
              (should
               (=
                (cadr bounds)
                55))
              ;; End after final ')'
              (kill-buffer))))
      (delete-file temp-file))))

(ert-deftest test--em-toggle-comment-next-python
    ()
  "Test toggling comment on a print statement."
  (let
      ((temp-file
        (make-temp-file "emacs-message-test-" nil ".py")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "def test():\n    print(\"test\")\n"))
          (with-current-buffer
              (find-file-noselect temp-file)
            (python-mode)
            (goto-char
             (point-min))
            (--em-toggle-comment-next-python)
            (should
             (string-match-p "# print(\"test\")"
                             (buffer-string)))
            ;; Toggle back
            (goto-char
             (point-min))
            (--em-toggle-comment-next-python)
            (should
             (string-match-p "print(\"test\")"
                             (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test--em-toggle-buffer-python
    ()
  "Test toggling all print statements in a buffer."
  (let
      ((temp-file
        (make-temp-file "emacs-message-test-" nil ".py")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "def test():\n    print(\"on\")\n\ndef test2():\n    # print(\"off\")\n"))
          (with-current-buffer
              (find-file-noselect temp-file)
            (python-mode)
            (--em-toggle-buffer-python)
            (should
             (string-match-p "# print(\"on\")"
                             (buffer-string)))
            (should
             (string-match-p "print(\"off\")"
                             (buffer-string)))
            ;; Toggle back
            (--em-toggle-buffer-python)
            (should
             (string-match-p "print(\"on\")"
                             (buffer-string)))
            (should
             (string-match-p "# print(\"off\")"
                             (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(provide 'test-emacs-message-python)
(when
    (not load-file-name)
  (message "test-emacs-message-python.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide 'test-emacs-message-python)

(when
    (not load-file-name)
  (message "test-emacs-message-python.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))