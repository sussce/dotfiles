;; proxy0.el

(setq socks-override-functions 1
     socks-noproxy '("localhost")
     url-gateway-method 'socks
     socks-server '("Default server" "127.0.0.1" 9999 5))

(setq url-proxy-services
      '(("no_proxy" . "^\\(localhost\\|10.*\\)")
        ("http" . "127.0.0.1:19999")
        ("https" . "127.0.0.1:19999")
        ("ftp" . "127.0.0.1:19999")))

(provide 'proxy0)
;; proxy0.el
