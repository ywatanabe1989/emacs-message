;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-03 08:11:10>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/tests/test-emacs-message-main.el

(ert-deftest test--em-get-language-type-elisp-by-mode
    ()
  (with-temp-buffer
    (emacs-lisp-mode)
    (should
     (eq
      (--em-get-language-type)
      'elisp))))

(ert-deftest test--em-get-language-type-elisp-by-filename
    ()
  (with-temp-buffer
    (let
        ((buffer-file-name "/tmp/test.el"))
      (should
       (eq
        (--em-get-language-type)
        'elisp)))))

(ert-deftest test--em-get-language-type-python-by-mode
    ()
  (with-temp-buffer
    (python-mode)
    (should
     (eq
      (--em-get-language-type)
      'python))))

(ert-deftest test--em-get-language-type-python-by-filename
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
(ert-deftest test-em-toggle-buffer-dispatches-elisp
    ()
  (with-temp-buffer
    (emacs-lisp-mode)
    (insert "(message \"test\")")
    (goto-char
     (point-min))
    (cl-letf
        (((symbol-function '--em-toggle-buffer-elisp)
          (lambda
            ()
            (insert "ELISP-CALLED")))
         ((symbol-function '--em-toggle-buffer-python)
          (lambda
            ()
            (insert "PYTHON-CALLED"))))
      (em-toggle-buffer)
      (should
       (string=
        (buffer-string)
        "ELISP-CALLED(message \"test\")")))))

(ert-deftest test-em-toggle-buffer-dispatches-python
    ()
  (with-temp-buffer
    (python-mode)
    (insert "print(\"test\")")
    (goto-char
     (point-min))
    (cl-letf
        (((symbol-function '--em-toggle-buffer-elisp)
          (lambda
            ()
            (insert "ELISP-CALLED")))
         ((symbol-function '--em-toggle-buffer-python)
          (lambda
            ()
            (insert "PYTHON-CALLED"))))
      (em-toggle-buffer)
      (should
       (string=
        (buffer-string)
        "PYTHON-CALLEDprint(\"test\")")))))

(ert-deftest test-em-uncomment-buffer-dispatches-elisp
    ()
  (with-temp-buffer
    (emacs-lisp-mode)
    (insert ";; (message \"test\")")
    (goto-char
     (point-min))
    (cl-letf
        (((symbol-function '--em-uncomment-buffer-elisp)
          (lambda
            ()
            (insert "ELISP-CALLED")))
         ((symbol-function '--em-uncomment-buffer-python)
          (lambda
            ()
            (insert "PYTHON-CALLED"))))
      (em-uncomment-buffer)
      (should
       (string=
        (buffer-string)
        "ELISP-CALLED;; (message \"test\")")))))

(ert-deftest test-em-uncomment-buffer-dispatches-python
    ()
  (with-temp-buffer
    (python-mode)
    (insert "# print(\"test\")")
    (goto-char
     (point-min))
    (cl-letf
        (((symbol-function '--em-uncomment-buffer-elisp)
          (lambda
            ()
            (insert "ELISP-CALLED")))
         ((symbol-function '--em-uncomment-buffer-python)
          (lambda
            ()
            (insert "PYTHON-CALLED"))))
      (em-uncomment-buffer)
      (should
       (string=
        (buffer-string)
        "PYTHON-CALLED# print(\"test\")")))))

(ert-deftest test-em-comment-out-buffer-dispatches-elisp
    ()
  (with-temp-buffer
    (emacs-lisp-mode)
    (insert "(message \"test\")")
    (goto-char
     (point-min))
    (cl-letf
        (((symbol-function '--em-comment-out-buffer-elisp)
          (lambda
            ()
            (insert "ELISP-CALLED")))
         ((symbol-function '--em-comment-out-buffer-python)
          (lambda
            ()
            (insert "PYTHON-CALLED"))))
      (em-comment-out-buffer)
      (should
       (string=
        (buffer-string)
        "ELISP-CALLED(message \"test\")")))))

(ert-deftest test-em-comment-out-buffer-dispatches-python
    ()
  (with-temp-buffer
    (python-mode)
    (insert "print(\"test\")")
    (goto-char
     (point-min))
    (cl-letf
        (((symbol-function '--em-comment-out-buffer-elisp)
          (lambda
            ()
            (insert "ELISP-CALLED")))
         ((symbol-function '--em-comment-out-buffer-python)
          (lambda
            ()
            (insert "PYTHON-CALLED"))))
      (em-comment-out-buffer)
      (should
       (string=
        (buffer-string)
        "PYTHON-CALLEDprint(\"test\")")))))

(ert-deftest test-em-toggle-comment-next-dispatches-elisp
    ()
  (with-temp-buffer
    (emacs-lisp-mode)
    (insert "(message \"test\")")
    (goto-char
     (point-min))
    (cl-letf
        (((symbol-function '--em-toggle-comment-next-elisp)
          (lambda
            ()
            (insert "ELISP-CALLED")))
         ((symbol-function '--em-toggle-comment-next-python)
          (lambda
            ()
            (insert "PYTHON-CALLED"))))
      (em-toggle-comment-next)
      (should
       (string=
        (buffer-string)
        "ELISP-CALLED(message \"test\")")))))

(ert-deftest test-em-toggle-comment-next-dispatches-python
    ()
  (with-temp-buffer
    (python-mode)
    (insert "print(\"test\")")
    (goto-char
     (point-min))
    (cl-letf
        (((symbol-function '--em-toggle-comment-next-elisp)
          (lambda
            ()
            (insert "ELISP-CALLED")))
         ((symbol-function '--em-toggle-comment-next-python)
          (lambda
            ()
            (insert "PYTHON-CALLED"))))
      (em-toggle-comment-next)
      (should
       (string=
        (buffer-string)
        "PYTHON-CALLEDprint(\"test\")")))))

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

(ert-deftest test-em-uncomment-next-dispatches-elisp
    ()
  (with-temp-buffer
    (emacs-lisp-mode)
    (insert ";; (message \"test\")")
    (goto-char
     (point-min))
    (cl-letf
        (((symbol-function '--em-uncomment-next-elisp)
          (lambda
            ()
            (insert "ELISP-CALLED")))
         ((symbol-function '--em-uncomment-next-python)
          (lambda
            ()
            (insert "PYTHON-CALLED"))))
      (em-uncomment-next)
      (should
       (string=
        (buffer-string)
        "ELISP-CALLED;; (message \"test\")")))))

(ert-deftest test-em-uncomment-next-dispatches-python
    ()
  (with-temp-buffer
    (python-mode)
    (insert "# print(\"test\")")
    (goto-char
     (point-min))
    (cl-letf
        (((symbol-function '--em-uncomment-next-elisp)
          (lambda
            ()
            (insert "ELISP-CALLED")))
         ((symbol-function '--em-uncomment-next-python)
          (lambda
            ()
            (insert "PYTHON-CALLED"))))
      (em-uncomment-next)
      (should
       (string=
        (buffer-string)
        "PYTHON-CALLED# print(\"test\")")))))

(ert-deftest test-em-unsupported-language
    ()
  (with-temp-buffer
    (c-mode)
    (let
        ((inhibit-message nil)
         (message-log-max nil))
      (should-not
       (--em-get-language-type)))
    (cl-letf
        (((symbol-function 'message)
          (lambda
            (format-string &rest args)
            (should
             (string-match-p "Unsupported language mode" format-string)))))
      (em-toggle-buffer)
      (em-uncomment-buffer)
      (em-comment-out-buffer)
      (em-toggle-comment-next)
      (em-uncomment-next)
      (em-toggle-at-point))))

(provide 'test-emacs-message-main)

(when
    (not load-file-name)
  (message "test-emacs-message-main.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))