;; shortcut.el Shortcut
;; ?interactive
;; ?commentary
;; ?list

(require 'key-chord)

;;(makunbound 'shortcuts)
(defvar shortcuts
  (let ((map
         `(;; ?sh
           ((erc-connect) . irc)

           (("geph5-client" "-c" ,(expand-file-name
			                             ".geph.yaml"
			                             (or (bound-and-true-p home-directory) (getenv "HOME")))) . g5)
           (("stardict") . dic)
	         (("tor" "-f" ,(expand-file-name
			                    ".tor/torrc"
			                    (or (bound-and-true-p home-directory) (getenv "HOME")))) . tor)
           (("tor-browser") . tw)
	         ((ansi-term "/bin/bash") . sh)
           (("chromium" "--incognito" "--window-size=\"1300,960\"" "--no-proxy-server") . cw)
	         (("chromium" "--incognito" "--proxy-bypass-list=localhost" "--proxy-server=127.0.0.1:9999" "--proxy-server=socks5://127.0.0.1:9999") . cwg)
	         (("firefox" "-P" "0" "--private-window" "--no-remote") . w)
	         (("firefox" "-P" "g" "--private-window" "--no-remote") . wg)
	         (("firefox" "-P" "tor" "--private-window" "--no-remote") . wt)))
	      (symbol-valid (lambda (arg)
			                  (if (symbolp arg)
			                      (or (fboundp arg)
				                        (and (boundp arg)
				                             (or (functionp (symbol-value arg))
					                               (macrop (symbol-value arg)))))
			                    (functionp arg)))))
    (mapc (lambda (arg)
	          (let ((sym (cdr arg)) (any (caar arg)))
	            (put sym 'bind-eval-form (funcall symbol-valid any))))
	        map))
  "((PROGRAM ARGS) . ALIAS)")

(defun kill-system-process (&rest args)
  (declare (obsolete "temporarily obsoleted." 26.1))
  (interactive)
  (let ((pids (list-system-processes))
	palist pname)
    (dolist (pid pids)
      (setq palist (process-attributes pid))
      (when palist
	(setq pname (alist-get 'comm palist))
	(dolist (arg args)
	  (if (equal pname arg)
	      (signal-process pid 9)))))))

(defun shortcut-interactive-args (prompt)
  (let ((input (read-string prompt)))
    (list (mapcar 'intern (split-string input)))))

;; ?action
(defun shortcut (alias &optional action)
  (interactive (shortcut-interactive-args "symbol: "))
  (unless (called-interactively-p 'interactive)
    (if (nlistp alias) (error "Error args, %S" alias)))
  (let ((exec-path (cons
                    (expand-file-name "sh" (or (bound-and-true-p home-directory) (getenv "HOME")))
			              exec-path))
	      (symbols alias) symbol)
    (while (prog1
	             (and (setq symbol (pop symbols)) symbols)
	           (let* ((pair (rassq symbol shortcuts))
		                (key (cdr pair)) (value (car pair)))
	             (catch 'done
		             (when (and pair (consp value))
		               (let ((program (car value)) (args (cdr value)))
		                 (if (get key 'bind-eval-form)
			                   (apply program args)
		                   (let ((file  (executable-find program)))
			                   (and file
			                        (let ((default-directory (file-name-directory file)))
				                        (apply 'start-process program nil program args)))))
		                 (throw 'done t)))
		             (message "No association with symbol, %S" symbol)))))))

(add-hook 'emacs-startup-hook
	  (lambda ()
	    ;; (shortcut '(dic))
      ))

(key-chord-define-global ",l" 'shortcut)

(provide 'shortcut)
;; shortcut.el ends
