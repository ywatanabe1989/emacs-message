<!-- ---
!-- Timestamp: 2025-03-03 01:09:09
!-- Author: ywatanabe
!-- File: /home/ywatanabe/.dotfiles/.emacs.d/lisp/emacs-message/README.md
!-- --- -->

# Emacs Message

[![Build Status](https://github.com/ywatanabe1989/emacs-message/workflows/tests/badge.svg)](https://github.com/ywatanabe1989/emacs-message/actions)

An Elisp package for toggling/enabling/diabling printing statements.

## Installation

1. Clone the repository:
```bash
git clone https://github.com/ywatanabe1989/emacs-message.git ~/.emacs.d/lisp/emacs-message
```

2. Add to your init.el:
```elisp
(add-to-list 'load-path "~/.emacs.d/lisp/emacs-message")
(require 'emacs-message)
```

## Usage

### Interactive Commands

| Command | Description |
|---------|-------------|
| `M-x em-toggle-at-point` | Toggle comment status of message statement at cursor position |
| `M-x em-toggle-all` | Toggle all message statements in the buffer |
| `M-x em-enable-all` | Enable (uncomment) all message statements in buffer |
| `M-x em-disable-all` | Disable (comment out) all message statements in buffer |

### Supported Languages

| Language | Target Statement |
|----------|------------------|
| Emacs Lisp | `(message ...)` |
| Python | `print(...)` |

## Contact

Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

<!-- EOF -->