;; package.el Package stuff -*- lexical-binding: t -*-

(require 'package)

(add-to-list 'package-archives '("erc" . "https://emacs-erc.gitlab.io/bugs/archive/"))
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(provide 'package0)
;; package0.el ends
