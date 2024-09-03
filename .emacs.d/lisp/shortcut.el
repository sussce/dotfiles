;; shortcut.el Shortcut
;; ?interactive
;; ?commentary
;; ?list

(require 'key-chord)

(defvar bridges '("1.ams.nl.ngexits.geph.io" "1.mtl.ca.ngexits.geph.io" "1.pdx.us.ngexits.geph.io"
                  "1.sgp.sg.ngexits.geph.io" "1.waw.pl.ngexits.geph.io"

                  "2.mtl.ca.ngexits.geph.io" "2.pdx.us.ngexits.geph.io" "2.waw.pl.ngexits.geph.io"

                  "3.mtl.ca.ngexits.geph.io" "3.pdx.us.ngexits.geph.io" "3.waw.pl.ngexits.geph.io"
                  "4.pdx.us.ngexits.geph.io"

                  "ca-mtl-104.geph.io" "ca-mtl-105.geph.io" "ca-mtl-106.geph.io"
                  "ca-mtl-107.geph.io" "ca-mtl-108.geph.io" "ca-mtl-109.geph.io"
                  
                  "ch-zrh-01.exits.geph.io"
                  "cz-prg-101.geph.io"

                  "fr-par-101.geph.io" "fr-par-102.geph.io"
                  "fr-par-103.geph.io" "fr-par-104.geph.io"
                  "fr-par-105.geph.io" "fr-par-106.geph.io"
                  "fr-par-107.geph.io" "fr-par-108.geph.io"
                  "fr-par-109.geph.io" "fr-par-110.geph.io"
                  "fr-par-111.geph.io" "fr-par-112.geph.io"
                  
                  "jp-tyo-01.exits.geph.io"
                  
                  "tw-tpe-101.geph.io" "tw-tpe-102.geph.io"
                  "us-pdx-105.geph.io" "us-pdx-106.geph.io"
                  "us-pdx-107.geph.io" "us-sfo-101.geph.io"))

;;(makunbound 'shortcuts)
(defvar shortcuts
  (let ((map
         `(;; ?sh
           (("/opt/gowrite/gowrite2") . go)
           (("~/q5go/bin/q5go") . qgo)
           ((erc-connect) . irc)

           ;; server
           (("geph5-client" "-c" ,(expand-file-name
			                             ".geph.yaml"
			                             (or (bound-and-true-p home-directory) (getenv "HOME")))) . g5)

           (("geph4-client" "connect"
             "--exit-server" "us-pdx-105.geph.io"
             "--use-bridges" "--exclude-prc"
             "auth-password" "--username" "sus11" "--password" "11sus") . g)

           (("geph4-client" "connect"
             "--exit-server" "us-pdx-106.geph.io"
             "--use-bridges" "--exclude-prc"
             "auth-password" "--username" "sus11" "--password" "11sus") . g1)

           (("geph4-client" "connect"
             "--exit-server" "us-pdx-107.geph.io"
             "--use-bridges" "--exclude-prc"
             "auth-password" "--username" "sus11" "--password" "11sus") . g2)

           (("geph4-client" "connect"
             "--exit-server" "fr-par-101.geph.io"
             "--use-bridges" "--exclude-prc"
             "auth-password" "--username" "sus11" "--password" "11sus") . g3)
           
           (("stardict") . dic)
	         (("tor" "-f" ,(expand-file-name
			                    ".tor/torrc"
			                    (or (bound-and-true-p home-directory) (getenv "HOME")))) . tor)
           (("tor-browser") . torw)
	         ((ansi-term "/bin/bash") . sh)
           (("chromium" "--incognito" "--window-size=\"1300,960\"" "--no-proxy-server") . cw)
	         (("chromium" "--incognito" "--window-size=\"1300,960\"" "--proxy-bypass-list=localhost" "--proxy-server=127.0.0.1:9910" "--proxy-server=socks5://127.0.0.1:9909") . cwg)
	         (("firefox-esr" "-P" "default" "--private-window" "--no-remote") . w)
	         (("firefox-esr" "-P" "g" "--private-window" "--no-remote") . wg)
	         (("firefox-esr" "-P" "tor" "--private-window" "--no-remote") . wt)))
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
