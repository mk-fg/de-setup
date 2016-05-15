(define (mono-time)
	"Return monotonic timestamp in seconds as real."
	(+ 0.0 (/ (get-internal-real-time) internal-time-units-per-second)))


;;;; -- Mouse-2 (middle button) click debouncing for crappy Razer mouse

(define razer-delay-min 0.2)
(define razer-wait-max 0.5)
(define razer-ts-start #f)
(define razer-ts-done #f)
(define razer-debug #f)

(xbindkey-function '("b:8") (lambda ()
	(let ((ts (mono-time)))
		(when
			;; Enforce min ts diff between "done" and "start" of the next one
			(or (not razer-ts-done) (>= (- ts razer-ts-done) razer-delay-min))
			(set! razer-ts-start ts)))))

(xbindkey-function '(Release "b:8") (lambda ()
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
			(run-command "xdotool click 2"))))) ;; XXX: something more liteweight maybe?

;; (xbindkey '("b:2") "echo click2+ >> ~/evtest.log")
;; (xbindkey '(Release "b:2") "echo click2- >> ~/evtest.log")
