;;; itbh-print.el --- Printing buffers using the web browser

;; Copyright (c) 2016 Christoph D. Hermann, ITBH

;; Author: Christoph D. Hermann <christoph.hermann@itbh.at>
;;
;; based on
;; https://github.com/zenitani/elisp/blob/master/itbh-print-mode.el and
;; https://github.com/jwiegley/nxhtml/blob/master/util/hfyview.el

;; This file is distributed under the terms of the GNU General Public
;; License version 3, or (at your option) any later version.

;;; Commentary:

;; This package requires htmlize.el <http://fly.srk.fer.hr/~hniksic/emacs/htmlize.el>.
;; To use,
;;
;; M-x itbh-print
;;

;;; Code:

(require 'htmlize)

(defvar itbh-print-kill-view-buffers t
  "If non-nil, delete temporary html buffers after sending them to the web browser.")

;;;###autoload
(defun itbh-print (&optional region-only)
  "Print the buffer or region using the web browser.
Convert the buffer or the region if available to html and print
it using the web browser.  If REGION-ONLY is non-nil then only the
region is printed."
  (interactive)
  (let* ((default-directory "~/") ;; When editing a remote file
         (htmlize-after-hook nil)
         (htmlize-generate-hyperlinks nil)
         (htmlize-output-type 'css)
         (htmlize-head-tags
          (concat "<script type='text/javascript'>\n"
                  " window.onload = function() { window.print(); }\n"
                  "</script>\n")))
    (message "printing...")
    (if region-only
        (itbh-print-htmlize-buffer-to-tempfile t)
      (itbh-print-htmlize-buffer-to-tempfile (use-region-p)))
    (message "printing... done")))

(defun itbh-print-htmlize-buffer-to-tempfile(region-only)
  "Convert buffer to html, preserving colors and decoration.
If REGION-ONLY is non-nil then only the region is sent to the TextEdit application.
Return a cons with temporary file name followed by temporary buffer."
  (save-excursion
    (let (;; Just use Fundamental mode for the temp buffer
          magic-mode-alist
          auto-mode-alist
          (html-temp-buffer
           (if (not region-only)
               (htmlize-buffer (current-buffer))
             (let ((start (mark)) (end (point)))
               (or (<= start end)
                   (setq start (prog1 end (setq end start))))
               (htmlize-region start end))))
          (file (make-temp-file "emacs-print-" nil ".html")))
      (set-buffer html-temp-buffer)
      (write-file file nil)
      (browse-url-of-buffer html-temp-buffer)
      (if itbh-print-kill-view-buffers (kill-buffer html-temp-buffer))
      file)))

(provide 'itbh-print)
;;; itbh-print.el  ends here
