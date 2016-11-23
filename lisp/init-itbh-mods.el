;;; init-itbh-mods --- ITBH modifications

;;; Commentary:

;;; Code:

;;----------------------------------------------------------------------------
;; Use GUI on mouse events
;;----------------------------------------------------------------------------
(setq use-file-dialog t)
(setq use-dialog-box t)


;;----------------------------------------------------------------------------
;; Override keys for increasing and decreasing font size
;;----------------------------------------------------------------------------
(global-set-key (kbd "C-M-+") 'default-text-scale-increase)
(global-set-key (kbd "C-M--") 'default-text-scale-decrease)

;;----------------------------------------------------------------------------
;; Enable printing using the web browser
;;----------------------------------------------------------------------------
(require 'itbh-print)
(global-set-key (kbd "C-c i p") 'itbh-print)

(provide 'init-itbh-mods)
;;; init-itbh-mods.el ends here
