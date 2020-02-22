;;;; -- Debouncing script for crappy Razer mouse

(define (mono-time)
	"Return monotonic timestamp in seconds as real."
	(+ 0.0 (/ (get-internal-real-time) internal-time-units-per-second)))

(define razer-delay-min 0.2)
(define razer-wait-max 0.5)
(define razer-ts-start #f)
(define razer-ts-done #f)
(define razer-debug #f)

(define razer-press (lambda ()
	(let ((ts (mono-time)))
		(when
			;; Enforce min ts diff between "done" and "start" of the next one
			(or (not razer-ts-done) (>= (- ts razer-ts-done) razer-delay-min))
			(set! razer-ts-start ts)))))

(define razer-release (lambda (command)
	(let ((ts (mono-time)))
		(when razer-debug
			(format #t "razer: ~a/~a delay=~a[~a] wait=~a[~a]\n"
				razer-ts-start razer-ts-done
				(and razer-ts-done (- ts razer-ts-done)) razer-delay-min
				(and razer-ts-start (- ts razer-ts-start)) razer-wait-max))
		(when
			(and
				;; Enforce min ts diff between previous "done" and this one
				(or (not razer-ts-done) (>= (- ts razer-ts-done) razer-delay-min))
				;; Enforce max "click" wait time
				(and razer-ts-start (<= (- ts razer-ts-start) razer-wait-max)))
			(set! razer-ts-done ts)
			(when razer-debug (format #t "razer: --- click!\n"))
			;; XXX: something more liteweight than shell + xdotool maybe?
			(run-command command)))))


;;;; -- Mouse-2 (middle button) - bound as mouse-8

(xbindkey-function "b:8" (lambda () (razer-press)))
(xbindkey-function '(Release "b:8") (lambda () (razer-release "xdotool click 2")))

;; (xbindkey '("b:2") "echo click2+ >> ~/evtest.log")
;; (xbindkey '(Release "b:2") "echo click2- >> ~/evtest.log")


;;;; -- Mouse-9 to act as a "Page Down" button event

(xbindkey-function "b:9" (lambda () (razer-press)))
(xbindkey-function '(Release "b:9") (lambda () (razer-release "xdotool key Next")))
