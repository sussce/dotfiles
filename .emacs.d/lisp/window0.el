;; window0.el Window stuff

(require 'key-chord)

(add-to-list 'display-buffer-alist
             '("*Help*" display-buffer-same-window))

(global-set-key (kbd "C-'") 'delete-window)

(key-chord-define-global ",d" 'other-window)
(key-chord-define-global "/d" 'split-window-right)
(key-chord-define-global "/s" 'split-window-below)

(defun make-window-dedicated (arg)
  "Set the current window as dedicated, 
so it will not be chosen as target for other buffers.
With C-u (ARG != 1; some prefix argument) 
set window as non-dedicated."
  (interactive "p")
  (set-window-dedicated-p nil (if (= 1 arg) t nil)))
 
;; (defun my/set-window-dedicated (arg)
;;   "Toggle loose window dedication.  If prefix ARG, set strong."
;;   (interactive "P")
;;   (let* ((dedicated (if arg t (if (window-dedicated-p) nil "loose"))))
;;     (message "setting window dedication to %s" dedicated)
;;     (set-window-dedicated-p (selected-window) dedicated)))
 
(provide 'window0)
;; window0.el ends
