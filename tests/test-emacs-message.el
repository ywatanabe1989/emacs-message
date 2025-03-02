;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-02 22:30:36>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/tests/-test-emacs-message.el

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

(ert-deftest test-emacs-message-functions-exist
    ()
  (should
   (fboundp 'em-toggle-at-point))
  (should
   (fboundp 'em-toggle-all))
  (should
   (fboundp 'em-enable-all))
  (should
   (fboundp 'em-uncomment-all)))

(provide '-test-emacs-message)

(when
    (not load-file-name)
  (message "-test-emacs-message.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))