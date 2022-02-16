;; devjs.el JS stuff

(add-to-list 'auto-mode-alist '("\\.js\\'" . js-mode))
(add-hook 'js-mode-hook 'dev/with-minor)

(defun dev/with-minor ()
  (hs-minor-mode)
  (company-mode)
  (require 'flow-minor-mode)
  (flow-minor-enable-automatically))

;; additional integrations
;; flycheck-flow
(with-eval-after-load 'flycheck
  (flycheck-add-mode 'javascript-flow 'flow-minor-mode)
  (flycheck-add-mode 'javascript-eslint 'flow-minor-mode)
  (flycheck-add-next-checker 'javascript-flow 'javascript-eslint))

;;company-flow
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-flow))

(provide 'devjs)
;; devjs.el ends
