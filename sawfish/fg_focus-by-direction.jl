(require 'sawfish.wm.workspace)
(require 'fg_wm)


(defvar fg-wx-win-dist-bonus 2
	"Multiplier for non-primary direction delta on distance calculations.")


(defun fg-wx-win-get-center (win)
	"Get (x . y) of the window center."
	(let
		((pos (window-position win))
			(dim (window-dimensions win)))
	(cons
		(+ (car pos) (/ (car dim) 2))
		(+ (cdr pos) (/ (cdr dim) 2)))))


(defun fg-wx-win-dist
	(w1 w2 #!key (kx 1) (ky 1) (by fg-wx-win-get-center))
	"Simplified distance between W1 and W2.
Calculated as the sum of deltas for each axis.
KX and KY specify multipliers for deltas on these axis'es.
BY is a function to convert window object to an (X . Y) point."
	(when by
		(setq
			w1 (funcall by w1)
			w2 (funcall by w2)))
	(+
		(* kx (abs (- (car w1) (car w2))))
		(* ky (abs (- (cdr w1) (cdr w2))))))

(defun fg-wx-win-dist-cx (w1 w2)
	(apply fg-wx-win-dist w1 w2
		#:ky fg-wx-win-dist-bonus
		(unless (windowp w1) (list #:by nil))))
(defun fg-wx-win-dist-cy (w1 w2)
	(apply fg-wx-win-dist w1 w2
		#:kx fg-wx-win-dist-bonus
		(unless (windowp w1) (list #:by nil))))


(defun fg-wx-win-focus-ops (dir)
	(case dir
		((up) (list <= cdr fg-wx-win-dist-cy)) ((down) (list >= cdr fg-wx-win-dist-cy))
		((left) (list <= car fg-wx-win-dist-cx)) ((right) (list >= car fg-wx-win-dist-cx))))

(defun fg-wx-focus-slide (win direction)
	"Slide the input focus to a window, located
in a specified direction from currently focused window.
DIRECTION should be specified as either 'left, 'right, 'up or 'down."
	(let*
		((win-c (fg-wx-win-get-center win))
			(ext-list (workspace-windows))
			ext-match ext-dist)
		(let-list
			(cmp cget cdist) (fg-wx-win-focus-ops direction)
			(while ext-list
				(let*
					((ext (car ext-list))
						(ext-c (fg-wx-win-get-center ext)))
					(when
						(and (not (eq ext win))
							(fg-wx-win-focusable-p ext)
							(cmp (cget ext-c) (cget win-c)))
						(let ((dist (cdist win-c ext-c)))
							(when (or (not ext-dist) (< dist ext-dist))
								(setq ext-match ext ext-dist dist)))))
				(setq ext-list (cdr ext-list))))
		(when ext-match
			(raise-window (set-input-focus ext-match)))))


;;###autoload
(defun fg-wx-focus-up (win) (interactive "%W") (fg-wx-focus-slide win 'up))
(defun fg-wx-focus-down (win) (interactive "%W") (fg-wx-focus-slide win 'down))
(defun fg-wx-focus-left (win) (interactive "%W") (fg-wx-focus-slide win 'left))
(defun fg-wx-focus-right (win) (interactive "%W") (fg-wx-focus-slide win 'right))
