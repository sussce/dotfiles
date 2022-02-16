;; shortcut.el Shortcut stuff
;; ?interactive
;; ?commentary
;; ?list

(require 'key-chord)

(defvar shortcuts
  (let ((map
         `(((irc-connect) . irc)
           (("geph4-client" "connect" "--use-bridges" "--use-tcp" "--username" "riflce" "--password" "lfir") . g)
	         (("stardict") . dic)
	         (("tor" "-f" ,(expand-file-name
			                    ".tor/torrc"
			                    (or (bound-and-true-p home-directory) (getenv "HOME")))) . tor)
	         ((ansi-term "/bin/bash") . sh)
	         (("chromium"
             "--incognito" "--window-size=\"1300,960\"" "--proxy-bypass-list=localhost" "--proxy-server=127.0.0.1:9910" "--proxy-server=socks5://127.0.0.1:9909") . cw)
	         (("firefox-esr" "-P" "default" "--private-window" "--no-remote") . w)
	         (("firefox-esr" "-P" "geph" "--private-window" "--no-remote") . gw)
	         (("firefox-esr" "-P" "tor" "--private-window" "--no-remote") . tw)))
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
	    (shortcut '(dic))))

(key-chord-define-global ",l" 'shortcut)

(provide 'shortcut)
;; shortcut.el ends 02012-20  dsdkjHDSDJKD WHAT THE FUCK 
