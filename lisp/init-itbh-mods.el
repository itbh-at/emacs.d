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


(provide 'init-itbh-mods)
;;; init-itbh-mods.el ends here
