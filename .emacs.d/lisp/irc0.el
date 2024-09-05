;; irc0.el

(require 'erc)

(push 'sasl erc-modules)
;; (push 'notifications erc-modules)
(erc-update-modules)

;; (erc-toggle-debug-irc-protocol)

(setq erc-server-auto-reconnect t
      erc-server-reconnect-timeout 20)

(setopt erc-sasl-mechanism 'external)

(setq erc-config-directory (expand-file-name ".irc" home-directory)
      erc-log-directory (expand-file-name "log" erc-config-directory)
      erc-ssl-directory (expand-file-name "ssl" erc-config-directory))

(setq erc-nick "suss"
      erc-user-full-name " "
      erc-server "irc.libera.chat"
      erc-port 6697)

(setq erc-hide-list '("JOIN" "PART" "QUIT" "TOPIC"))
;; (setq erc-track-exclude-types '("NICK" "333" "353"))

(setq erc-autojoin-channels-alist '(("libera.chat")))

(setq erc-quit-reason 'erc-part-reason-various
      erc-quit-reason-various-alist '(("^$" "")))

(setq erc-auto-set-away t
      erc-auto-discard-away t
      erc-autoaway-message "away %i seconds"
      erc-autoaway-idle-seconds 120)

(setq erc-try-new-nick-p t
      erc-nick-uniquifier "_")

(setq erc-join-buffer 'bury)
(setq erc-tags-format nil)

(defconst var/libera "Libera.Chat")
(defconst var/libera-session "irc.libera.chat:6697")
(defvar var/irc-session nil)

(defvar erc-server-reg
  (let ((begin "\\`")
        (end "\\'") fm fm_srv)
    (setq fm_srv (concat var/libera "\\(/" erc-nick "\\)?"))
    (setq fm (concat begin fm_srv end))))

(defvar erc-session-reg
  (let ((begin "\\`")
        (end "\\'") fm fm_srv)
    (setq fm_srv (concat var/libera-session "\\(" "<[0-9]>" "\\)?" ))
    (setq fm (concat begin fm_srv end))))

(defun erc-live-p (&rest args)
  (let ((bufs (buffer-list)))
    (catch 'return
      (dolist (buf bufs)
        (when (and
             (erc-server-buffer-p buf)
             (or (string-match erc-server-reg (buffer-name buf))
                 (string-match erc-session-reg (buffer-name buf))))
          (setq var/irc-session buf)
          (throw 'return t))))))
(advice-add 'erc-tls :before-until #'erc-live-p)

(defun erc-connect ()
  (interactive)
  (if (not (erc-live-p))
      (erc-tls
       :server erc-server
       :port erc-port
       :user erc-nick
       :client-certificate `(,(expand-file-name "nick.key" erc-ssl-directory)
                             ,(expand-file-name "nick.crt" erc-ssl-directory)))
    (message "ignore connect to %s" var/irc-session)))

(defun erc-kill-check (&optional arg)
  (interactive "P")
  (unless (and (symbolp current-prefix-arg) (eql '- current-prefix-arg))
    (message "ignore kill %s" (buffer-name))
    (error "ignore kill %s" (buffer-name))))
(add-hook 'erc-kill-server-hook 'erc-kill-check)

(defun erc-server-send-ping (buf)
  "Send a ping to the IRC server buffer in BUF.
Additionally, detect whether the IRC process has hung."
  (if (and (buffer-live-p buf)
           (with-current-buffer buf
             erc-server-last-received-time))
      (with-current-buffer buf
        (if (and erc-server-send-ping-timeout
                 (time-less-p
                  erc-server-send-ping-timeout
                  (time-since erc-server-last-received-time)))
            (progn
              ;; if the process is hung, kill it
              (setq erc-server-timed-out t)
              (erc-cmd-QUIT ""))
          (erc-server-send (format "PING %.0f" (erc-current-time)))))
    ;; remove timer if the server buffer has been killed
    (let ((timer (assq buf erc-server-ping-timer-alist)))
      (when timer
        (cancel-timer (cdr timer))
        (setcdr timer nil)))))

;; for read-only, `erc-text-matched-hook'
;; instead of sending a desktop notification, just print the message
;; to your special mentions buffer `erc-notifications-notify-on-match'
;; (erc-cmd-QUERY "*mentions*")
;; And then, from your hook: (erc-display-message nil 'notice
;;            (get-buffer "*mentions*") "hi") 

;; (defun erc-cmd-CMD (&rest ignore)
;;   "/CMD"
;;   (let ((output))
;;     (erc-send-message (concat "CMD (" output ")" ))))

(key-chord-define-global "ij" 'erc-join-channel)
(key-chord-define-global "ia" 'erc-track-switch-buffer)

(provide 'irc0)
;; irc0.el
