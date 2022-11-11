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

(setq socks-override-functions 1
      socks-noproxy '("localhost")
      url-gateway-method 'socks
      socks-server '("Default server" "127.0.0.1" 9909 5))

(setq url-proxy-services
      '(("no_proxy" . "^\\(localhost\\|10.*\\)")
        ("http" . "127.0.0.1:9910")
        ("https" . "127.0.0.1:9910")
        ("ftp" . "127.0.0.1:9910")))

(setq focus-follows-mouse 'auto-raise
      mouse-autoselect-window t)

(electric-pair-mode 1)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp-third" user-emacs-directory))
(add-to-list 'custom-theme-load-path (expand-file-name "lisp-third/themes" user-emacs-directory))

(setq custom-file (expand-file-name "pref.el" user-emacs-directory))

(require 'package0)

(require 'exwm)
(require 'exwm-config)
(exwm-config-default)

(require 'colorless-themes)
(require 'key-chord)
(require 'expand-region)
(require 'flycheck)
(require 'company)
(require 'js2-mode)
(require 'flow-minor-mode)
(require 'xref-js2)
(require 'flycheck-flow)
(require 'company-flow)
;(require 'pdf-tools)

(eval-after-load 'colorless-themes
 '(load-theme 'less t))
(eval-after-load 'key-chord
 '(key-chord-mode 1))

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
;(require 'pdf0)
(require 'shortcut)
;;(require 'modeline0)
;;(require 'minibuffer0)
;;(require 'devlisp)
;;(require 'devc)
;;(require 'web0)
;;(require 'mail0)
;;(require 'media0)

;; (set-face-attribute 'default nil :family "Iosevka" :height 120)

(when (file-exists-p custom-file)
  (load custom-file 'noerror))

(provide 'init)
;; init.el ends
