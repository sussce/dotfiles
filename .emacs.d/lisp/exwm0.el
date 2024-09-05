;; exwm0.el

(require 'exwm)

;; Do not require this file directly in your user configuration
;; (require 'exwm-config)

(exwm-enable)

(setq exwm-workspace-minibuffer-position 'bottom
      exwm-workspace-display-echo-area-timeout 5)

;;(define-key exwm-mode-map (kbd "C-c") nil)
;(;define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)
;;(exwm-input-set-key (kbd "s-r") 'exwm-workspace-move-window)

;; (exwm-input-set-simulation-keys
;;       '(([?\C-b] . [left])
;;         ([?\C-f] . [right])
;;         ([?\C-p] . [up])
;;         ([?\C-n] . [down])
;;         ([?\C-a] . [home])
;;         ([?\C-e] . [end])
;;         ([?\M-v] . [prior])
;;         ([?\C-v] . [next])
;;         ([?\C-d] . [delete])
;;         ([?\C-k] . [S-end delete])))

;; (string-match "\\`\\(.*\\)\\( - [^-]*\\)\\'" title)
 
;; (defun exwm-get-firefox-url ()
;;   (interactive)
;;   (exwm-input--fake-key ?\C-l)
;;   (sleep-for 0.05)
;;   (exwm-input--fake-key [?\C-c ?\C-c])
;;   (sleep-for 0.05)
;;   ;;(gui-backend-get-selection 'CLIPBOARD 'STRING)
;;   )

;; (defun tempget()
;;   (interactive)
;;   (lambda ()
;;     (let ((content (gui-backend-get-selection 'PRIMARY 'text/html)))
;;       (list :content content))))


;; (define-key exwm-mode-map (kbd "C-c C-c") nil)
;;   (lambda () (interactive) (exwm-input--fake-key ?\C-c)))

(add-hook 'exwm-manage-finish-hook
          (lambda ()
            (cond ((and exwm-class-name
                        (member exwm-class-name '("Firefox" "firefox-esr" "Chromium")))
                   (exwm-input-set-local-simulation-keys '(([?\C-c ?\C-c] . ?\C-c))))
                  (t nil))))

(add-hook 'exwm-update-class-hook
          (lambda ()
            (exwm-workspace-rename-buffer exwm-class-name)))

(provide 'exwm0)
;; exwm0.el
