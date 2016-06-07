;;; lentic-cookie.el -- Lentic with a magic cookie -*- lexical-binding: t -*-

;;; Header:

;; This file is not part of Emacs

;; Author: Phillip Lord <phillip.lord@russet.org.uk>
;; Maintainer: Phillip Lord <phillip.lord@russet.org.uk>
;; The contents of this file are subject to the GPL License, Version 3.0.

;; Copyright (C) 2016, Phillip Lord, Newcastle University

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; #+begin_src emacs-lisp
(require 'lentic-cookie)
(require 'lentic-chunk)
(require 'lentic-org)

(defvar lentic-script-temp-location
  temporary-file-directory "/lentic-script")

(defun lentic-script-hook (mode-hook init)
  (add-to-list 'lentic-init-functions
               init)
  (add-hook mode-hook
            (lambda ()
              (unless lentic-init
                (setq lentic-init init)))))

(defun lentic-script--lentic-file-1 (file)
  (concat
   lentic-script-temp-location
   (substring
    (file-name-sans-extension file)
    1)
   ".org"))

(defun lentic-script-lentic-file ()
  (lentic-script--lentic-file-1 (buffer-file-name)))

;;;###autoload
(defun lentic-python-script-init ()
  (lentic-org-python-oset
   (lentic-cookie-unmatched-commented-chunk-configuration
    "temp"
    :lentic-file
    (lentic-script-lentic-file))))

(lentic-script-hook 'python-mode-hook
                    'lentic-python-script-init)

;;;###autoload
(defun lentic-bash-script-init ()
  (lentic-m-oset
   (lentic-cookie-unmatched-commented-chunk-configuration
    "temp"
    :this-buffer (current-buffer)
    :comment "## "
    :comment-start "#\\\+BEGIN_SRC sh"
    :comment-stop "#\\\+END_SRC"
    :lentic-file
    (lentic-script-lentic-file))))

(lentic-script-hook 'shell-mode-hook
                    'lentic-bash-script-init)

;;;###autoload
(defun lentic-lua-script-init ()
  (lentic-m-oset
   (lentic-cookie-unmatched-commented-chunk-configuration
    "temp"
    :this-buffer (current-buffer)
    :comment "-- "
    :comment-start "#\\\+BEGIN_SRC lua"
    :comment-stop "#\\\+END_SRC"
    :lentic-file
    (lentic-script-lentic-file))))

(lentic-script-hook 'lua-mode-hook
                    #'lentic-lua-script-init)

(provide 'lentic-script)
;;; lentic-script ends here
;; #+end_src
