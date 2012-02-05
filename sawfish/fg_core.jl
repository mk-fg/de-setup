;; This code is NOT a module, since macros are part of it's value



;;;; Convenience macros

(defmacro sprintf (#!rest body) `(format nil ,@body))
(defmacro sprint (arg) `(format nil "%s" ,arg))

(defmacro when-bound (specs #!rest body)
	(let (spec-list)
		(while specs
			(setq
				spec-list (cons (list (car specs) (cadr specs)) spec-list)
				specs (cddr specs)))
		`(when (and ,@(mapcar cadr spec-list))
			(let (,@(nreverse spec-list)) ,@body))))

(defmacro let-list (vars vals #!rest body)
	`(apply (lambda ,vars ,@body) ,vals))

(defmacro fg-defvar-setq-multi (#!rest body)
	"Define/set several variables,
given as tuples of VAR VAL.
VAL is evaluated, just like with regular setq."
	(let (defvars)
		(while body
			(setq
				defvars (cons `(defvar-setq ,(car body) ,(cadr body)) defvars)
				body (cddr body)))
		`(progn ,@defvars)))

(defmacro fg-custom-setq-multi (#!rest body)
	"Define several custom typed variables,
given as triples of TYPE VAR VAL.
Nothing is evaluated, so no extra quoting is necessary."
	(let (defvars)
		(while body
			(setq defvars
				(cons
					`(custom-set-typed-variable
						',(cadr body) ',(caddr body) ',(car body))
					defvars)
				body (cdddr body)))
		`(progn ,@defvars)))



;;;; String ops

(defun fg-string-pos (substr str)
	"Return position of the first occurence of SUBSTR in STR."
	(let
		((lenstr (length str))
			(lensub (length substr)))
		(if (>= lenstr lensub)
			(do
				((result nil)
					(start 0 (1+ start))
					(end lensub (+ start lensub 1)))
				((> end lenstr) result)
				(when
					(string= substr
						(substring str start end))
					(setq result start start lenstr)))
			nil)))

(defun fg-string-split (sep #!rest string)
	"Split STRING by SEP substring."
	(let*
		((strn (length string))
			(str (last string))
			(pos (fg-string-pos sep str)))
		(if (not pos)
			string
			(let
				((str (list
					(substring str 0 pos)
					(substring str (+ pos (length sep))))))
				(apply fg-string-split sep
					(if (<= strn 1) str
						(rplacd (nthcdr (- strn 2) string) str)
						string))))))

(defun fg-string-split-clean (sep string)
	"Split STRING by SEP substring, dropping empty pieces from resulting list."
	(delete "" (fg-string-split sep string)))

(defun fg-string-ws-p (char)
	(or (eq char ?\n) (eq char ?\r) (eq char ?\t) (eq char ?\ )))

(defun fg-string-strip (string)
	(let*
		((len (length string)) (idx 0) (cut t))
		(while (and cut (< idx len))
			(setq
				cut (fg-string-ws-p (aref string idx))
				idx (1+ idx)))
		(when (not cut)
			(setq
				string (substring string (- idx 1)))))
	(let*
		((len (length string)) (idx len) (cut t))
		(while (and cut (>= idx 0))
			(setq
				idx (1- idx)
				cut (fg-string-ws-p (aref string idx))))
		(when (not cut)
			(setq string (substring string 0 (1+ idx)))))
	string)



;;;; Alien interfaces

(defun fg-subprocess-command (program args)
	"Helper function to determine whether to use
shell-like invocation or process strict list of arguments."
	(let ((sh-cmd (fg-string-split-clean " " program)))
		(if (> (length sh-cmd) 1)
			(append sh-cmd args)
			(list* program args))))

(defun fg-subprocess (program #!key proc #!rest args)
	"Start a subprocess, specified either as a PROGRAM and a list of ARGS,
or a single space-delimeted list in PROGRAM. No shell involved either way."
	(apply start-process (or proc (make-process))
		(fg-subprocess-command program args)))

(defun fg-subprocess-output (program #!rest args)
	"Run process, returning it's output."
	(let*
		((proc (make-process))
			(pipe (set-process-output-stream proc (make-string-output-stream))))
		(apply fg-subprocess program #:proc proc args)
		(accept-process-output -1)
		(get-output-stream-string pipe)))
