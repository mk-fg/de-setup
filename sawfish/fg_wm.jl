(defcustom fg-blip-default-timeout 3
	"Default timeout value for displaying floating messages (fg-blip function)."
  :type number
  :group misc)
(defcustom fg-blip-trim 600
	"Max langth of text to display in floating messages (fg-blip function)."
  :type number
  :group misc)

(require 'rep.io.timers)
(defun fg-blip (message #!optional timeout)
	(when (> (length message) fg-blip-trim)
		(setq message
			(format nil "%s ..."
				(substring message 0 fg-blip-trim))))
	(display-message message)
	(make-timer
		(lambda () (display-message nil))
		(or timeout fg-blip-default-timeout)))

(require 'sawfish.wm.util.selection)
(define-command 'fg-blip-selection
	(lambda () (fg-blip (x-get-selection 'PRIMARY)))
	#:class 'utility)


(defun fg-get-frame-dim (win func)
	(- (funcall func (window-frame-dimensions win))
		(funcall func (window-dimensions win))))
(defun fg-get-frame-w (win) (fg-get-frame-dim win car))
(defun fg-get-frame-h (win) (fg-get-frame-dim win cdr))

(defun fg-wx-to-left-half (win)
	(resize-window-to win
		(- (quotient (screen-width) 2) (fg-get-frame-w win))
		(- (screen-height) (fg-get-frame-h win)))
	(move-window-to win 0 0))

(defun fg-wx-to-right-half (win)
	(let ((half-w (quotient (screen-width) 2)))
		(resize-window-to win
			(- half-w (fg-get-frame-w win))
			(- (screen-height) (fg-get-frame-h win)))
		(move-window-to win half-w 0)))

(define-command 'fg-wx-to-left-half fg-wx-to-left-half #:spec "%W")
(define-command 'fg-wx-to-right-half fg-wx-to-right-half #:spec "%W")


(require 'sawfish.wm.ext.match-window)

(defmacro fg-wx-add-window-matchers (#!rest matchers)
	"Convenience macro to add several window matchers at once.
Both rules and actions won't be evaluated. Both can be either list or a single cons.
Example:
	(fg-wx-add-window-matchers
		(WM_CLASS . \"^Firefox/\") (workspace . 2)
		(WM_CLASS . \"^Opera/\") ((workspace . 3) (cycle-skip . t)))"
	(let (add-lines rules actions)
		(while matchers
			(setq
				rules (car matchers)
				actions (cadr matchers)
				matchers (cddr matchers))
			(unless (consp (car rules)) (setq rules `(,rules)))
			(unless (consp (car actions)) (setq actions `(,actions)))
			(setq add-lines (cons
				`(add-window-matcher (quote ,rules) (quote ,actions))
				add-lines)))
		`(progn ,@add-lines)))


;; This is to force-raise window that is being resized, especially since
;;  preceding "click" event might've lowered it, causes a minor winch though
(require 'sawfish.wm.commands.move-resize)
(add-hook 'before-resize-hook (lambda (win) (raise-window win)))

;; Focus *any* window in current ws if focused window is destroyed or on ws switch
(require 'sawfish.wm.util.window-order)

(defun fg-wx-win-focusable-p (win)
	"Is window focusable?"
	(and win
		(window-visible-p win)
		(window-mapped-p win)
		(window-in-cycle-p win)
		(not (window-get win 'ignored))))
