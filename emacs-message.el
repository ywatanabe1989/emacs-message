;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-02 22:25:24>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/emacs-message.el

(require 'emacs-message-elisp)
(require 'emacs-message-python)
(require 'emacs-message-main)

(provide 'emacs-message)

(when
    (not load-file-name)
  (message "emacs-message.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))