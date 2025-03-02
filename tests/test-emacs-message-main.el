;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-02 22:57:23>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/tests/test-emacs-message-main.el

(ert-deftest test--em-get-language-type-elisp
    ()
  (with-temp-buffer
    (emacs-lisp-mode)
    (should
     (eq
      (--em-get-language-type)
      'elisp))))

(ert-deftest test--em-get-language-type-elisp-by-get-language-type
    ()
  (with-temp-buffer
    (emacs-lisp-mode)
    (should
     (eq
      (--em-get-language-type)
      'elisp))))

(ert-deftest test--em-get-language-type-python
    ()
  (with-temp-buffer
    (python-mode)
    (let
        ((buffer-file-name "/tmp/test.py"))
      (should
       (eq
        (--em-get-language-type)
        'python)))))

(ert-deftest test--em-get-language-type-unsupported
    ()
  (with-temp-buffer
    (c-mode)
    (should
     (eq
      (--em-get-language-type)
      nil))))

(ert-deftest test-em-toggle-at-point-dispatches-elisp
    ()
  (with-temp-buffer
    (emacs-lisp-mode)
    (insert "(message \"test\")")
    (goto-char
     (point-min))
    (cl-letf
        (((symbol-function '--em-toggle-at-point-elisp)
          (lambda
            ()
            (insert "ELISP-CALLED")))
         ((symbol-function '--em-toggle-at-point-python)
          (lambda
            ()
            (insert "PYTHON-CALLED"))))
      (em-toggle-at-point)
      (should
       (string=
        (buffer-string)
        "ELISP-CALLED(message \"test\")")))))

(ert-deftest test-em-toggle-at-point-dispatches-python
    ()
  (with-temp-buffer
    (python-mode)
    (insert "print(\"test\")")
    (goto-char
     (point-min))
    (cl-letf
        (((symbol-function '--em-toggle-at-point-elisp)
          (lambda
            ()
            (insert "ELISP-CALLED")))
         ((symbol-function '--em-toggle-at-point-python)
          (lambda
            ()
            (insert "PYTHON-CALLED"))))
      (em-toggle-at-point)
      (should
       (string=
        (buffer-string)
        "PYTHON-CALLEDprint(\"test\")")))))

(provide 'test-emacs-message-main)
(when
    (not load-file-name)
  (message "test-emacs-message-main.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide 'test-emacs-message-main)

(when
    (not load-file-name)
  (message "test-emacs-message-main.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))