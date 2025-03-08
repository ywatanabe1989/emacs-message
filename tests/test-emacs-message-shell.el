;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-03-08 11:08:59>
;;; File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/tests/test-emacs-message-shell.el

(require 'ert)
(require 'emacs-message-shell)

(ert-deftest test-shell-find-next-message-clause ()
  "Test finding echo statements in shell scripts."
  (let ((temp-file (make-temp-file "emacs-message-test-" nil ".sh")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "#!/bin/bash\necho \"test message\"\n"))
          (with-current-buffer (find-file-noselect temp-file)
            (sh-mode)
            (goto-char (point-min))
            (let ((result (--em-find-next-message-clause-shell)))
              (should result)
              (should (= (car result) 13))
              (should (= (cadr result) 32))
              (set-buffer-modified-p nil)
              (kill-buffer))))
      (delete-file temp-file))))

(ert-deftest test-shell-commented-out-p ()
  "Test checking if a line is commented in shell scripts."
  (let ((temp-file (make-temp-file "emacs-message-test-" nil ".sh")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert
             "#!/bin/bash\n# echo \"commented\"\necho \"not commented\"\n"))
          (with-current-buffer (find-file-noselect temp-file)
            (sh-mode)
            (goto-char (point-min))
            (forward-line)
            (should (--em-commented-out-p-shell))
            (forward-line)
            (should-not (--em-commented-out-p-shell))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test-shell-comment-out-next ()
  "Test commenting out the next echo statement."
  (let ((temp-file (make-temp-file "emacs-message-test-" nil ".sh")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "#!/bin/bash\necho \"test message\"\n"))
          (with-current-buffer (find-file-noselect temp-file)
            (sh-mode)
            (goto-char (point-min))
            (--em-comment-out-next-shell)
            (should
             (string-match-p "#\\s-*echo \"test message\""
                             (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test-shell-uncomment-next ()
  "Test uncommenting the next echo statement."
  (let ((temp-file (make-temp-file "emacs-message-test-" nil ".sh")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "#!/bin/bash\n# echo \"test message\"\n"))
          (with-current-buffer (find-file-noselect temp-file)
            (sh-mode)
            (goto-char (point-min))
            (--em-uncomment-next-shell)
            (should
             (string-match-p "echo \"test message\"" (buffer-string)))
            (should-not (string-match-p "#\\s-*echo" (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test-shell-toggle-comment-next-commented ()
  "Test toggling a commented echo statement."
  (let ((temp-file (make-temp-file "emacs-message-test-" nil ".sh")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert
             "#!/bin/bash\n# echo \"commented message\"\n\necho \"uncommented message\"\n"))
          (with-current-buffer (find-file-noselect temp-file)
            (sh-mode)
            (goto-char (point-min))
            (--em-toggle-comment-next-shell)
            (should
             (string-match-p "echo \"commented message\""
                             (buffer-string)))
            (should-not
             (string-match-p "# echo \"commented message\""
                             (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test-shell-toggle-comment-next-uncommented ()
  "Test toggling an uncommented echo statement."
  (let ((temp-file (make-temp-file "emacs-message-test-" nil ".sh")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "#!/bin/bash\necho \"test message\"\n"))
          (with-current-buffer (find-file-noselect temp-file)
            (sh-mode)
            (goto-char (point-min))
            (--em-toggle-comment-next-shell)
            (should
             (string-match-p "#\\s-*echo \"test message\""
                             (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test-src-toggle-buffer ()
  "Test toggleing all echo statements in a buffer."
  (let ((temp-file (make-temp-file "emacs-message-test-" nil ".src")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert
             "#!/bin/bash\necho \"message 1\"\n# echo \"message 2\"\n"))
          (with-current-buffer (find-file-noselect temp-file)
            (sh-mode)
            (--em-toggle-buffer-shell)
            (should
             (string-match-p "echo \"message 1\"" (buffer-string)))
            (should
             (string-match-p "echo \"message 2\"" (buffer-string)))
            (should-not (string-match-p "#\\s-*echo" (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test-sh-toggle-buffer ()
  "Test toggleing all echo statements in a buffer."
  (let ((temp-file (make-temp-file "emacs-message-test-" nil ".sh")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert
             "#!/bin/bash\necho \"message 1\"\n# echo \"message 2\"\n"))
          (with-current-buffer (find-file-noselect temp-file)
            (sh-mode)
            (--em-toggle-buffer-shell)
            (should
             (string-match-p "echo \"message 1\"" (buffer-string)))
            (should
             (string-match-p "echo \"message 2\"" (buffer-string)))
            (should-not (string-match-p "#\\s-*echo" (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test-shell-uncomment-buffer ()
  "Test uncommenting all echo statements in a buffer."
  (let ((temp-file (make-temp-file "emacs-message-test-" nil ".sh")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert
             "#!/bin/bash\n# echo \"message 1\"\n# echo \"message 2\"\n"))
          (with-current-buffer (find-file-noselect temp-file)
            (sh-mode)
            (--em-uncomment-buffer-shell)
            (should
             (string-match-p "echo \"message 1\"" (buffer-string)))
            (should
             (string-match-p "echo \"message 2\"" (buffer-string)))
            (should-not (string-match-p "#\\s-*echo" (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test-shell-comment-out-buffer ()
  "Test commenting out all echo statements in a buffer."
  (let ((temp-file (make-temp-file "emacs-message-test-" nil ".sh")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert
             "#!/bin/bash\necho \"message 1\"\necho \"message 2\"\n"))
          (with-current-buffer (find-file-noselect temp-file)
            (sh-mode)
            (--em-comment-out-buffer-shell)
            (should
             (string-match-p "#\\s-*echo \"message 1\""
                             (buffer-string)))
            (should
             (string-match-p "#\\s-*echo \"message 2\""
                             (buffer-string)))
            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(ert-deftest test-shell-toggle-at-point ()
  "Test toggling an echo statement at point."
  (let ((temp-file (make-temp-file "emacs-message-test-" nil ".sh")))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert "#!/bin/bash\necho \"test message\"\n"))
          (with-current-buffer (find-file-noselect temp-file)
            (sh-mode)
            (forward-line)
            (--em-toggle-at-point-shell)
            (should
             (string-match-p "#\\s-*echo \"test message\""
                             (buffer-string)))

            ;; Toggle back
            (--em-toggle-at-point-shell)
            (should
             (string-match-p "echo \"test message\"" (buffer-string)))
            (should-not (string-match-p "#\\s-*echo" (buffer-string)))

            (set-buffer-modified-p nil)
            (kill-buffer)))
      (delete-file temp-file))))

(provide 'test-emacs-message-shell)

(when
    (not load-file-name)
  (message "test-emacs-message-shell.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))