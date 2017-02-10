;;; acmelike-shell-command.el --- Acme-like additions for shell-command

;; Copyright 2014, 2017 Tim Baumgard

;;; License

;; This program is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation, either version 3 of the License, or (at your option) any later
;; version.

;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
;; details.

;; You should have received a copy of the GNU General Public License along with
;; this program. If not, see <http://www.gnu.org/licenses/>.

;;; Code:

(defun shell-command-region (start end)
	"Use the contents of the region as a shell command, putting the
output of the command in a temporary buffer."
	(interactive "r")
	(let* ((command (buffer-substring start end))
				 (is-async (string-match "[ \t]*&[ \t]*\\'" command))
				 (output-buffer-name (if is-async "*Async Shell Command*" "*Shell Command Output*")))
		(shell-command command output-buffer-name "*Shell Command Error*")
		(pop-to-buffer output-buffer-name)))

(defun shell-command-replace-region (start end)
	"Use the contents of the region as a shell command, replacing
the contents with the output of the command. Asynchronous
commands will be executed synchronously."
	(interactive "r")
	(let* ((command (buffer-substring start end))
				 (is-async (string-match "[ \t]*&[ \t]*\\'" command)))
		(if is-async (message "%s" "Executing asynchronous shell command synchronously"))
		(goto-char end)
		(backward-delete-char (- end start))
		(shell-command command t "*Shell Command Error*")))

(defun async-shell-command-region (start end)
	"Use the contents of the region as a shell command that is
executed asynchronously, putting the output of the command in a
temporary buffer."
	(interactive "r")
	(let ((command (buffer-substring start end)))
		(async-shell-command command "*Async Shell Command*" "*Async Shell Command Error*")
		(pop-to-buffer "*Async Shell Command*")))
