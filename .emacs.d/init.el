;; init.el -*- lexical-binding: t -*-

(setq debug-on-error t)

;; Reduce garbage collection frequency, for faster initialization.
(setq gc-cons-threshold 100000000)

(setq home-directory (getenv "HOME")
      org-directory (expand-file-name "org" home-directory)
      root-source-directory (expand-file-name "src" home-directory)
      source-directory (expand-file-name "emacs" root-source-directory)
      emacs-source-directory (expand-file-name "emacs" root-source-directory)      
      react-source-directory (expand-file-name "react/packages" root-source-directory))

(setq focus-follows-mouse 'auto-raise
      mouse-autoselect-window t)

(electric-pair-mode 1)

(setq custom-file (expand-file-name "pref.el" user-emacs-directory))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp-third" user-emacs-directory))
(add-to-list 'custom-theme-load-path (expand-file-name "lisp-third/themes" user-emacs-directory))

(require 'package0)

(require 'exwm)

(require 'colorless-themes)
(eval-after-load 'colorless-themes
  '(load-theme 'less t))

(require 'key-chord)
(eval-after-load 'key-chord
  '(key-chord-mode 1))

(require 'expand-region)
(require 'flycheck)
(require 'company)
(require 'js2-mode)
(require 'flow-minor-mode)
(require 'xref-js2)
(require 'flycheck-flow)
(require 'company-flow)
;; (require 'pdf-tools)

(require 'macro0)
(require 'window0)
(require 'buffer0)
(require 'eval0)
(require 'region0)
(require 'search0)
(require 'dev0)
(require 'devjs)
(require 'org0)
(require 'exwm0)
(require 'irc0)
;; (require 'proxy0)
;; (require 'modeline0)
;; (require 'minibuffer0)
;; (require 'devlisp)
;; (require 'devc)
;; (require 'web0)
;; (require 'mail0)
;; (require 'media0)
;; (require 'pdf0)
(require 'shortcut)

(when (file-exists-p custom-file)
  (load custom-file 'noerror))

;; (set-face-attribute 'default nil :family "Iosevka" :height 120)

(provide 'init)
;; init.el
