;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-03 08:39:55>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/tests/test-emacs-message.el

(require 'ert)
(require 'emacs-message)

(ert-deftest test-emacs-message-loadable
    ()
  (should
   (featurep 'emacs-message)))

(ert-deftest test-emacs-message-elisp-loadable
    ()
  (should
   (featurep 'emacs-message-elisp)))

(ert-deftest test-emacs-message-python-loadable
    ()
  (should
   (featurep 'emacs-message-python)))

(ert-deftest test-emacs-message-main-loadable
    ()
  (should
   (featurep 'emacs-message-main)))

(provide 'test-emacs-message)

(when
    (not load-file-name)
  (message "test-emacs-message.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))