#lang racket
(require "util.rkt")
(module+ test (require rackunit))

(define (letter->note a)
	(case a
		[(a) 5]
		[(b) 6]
		[(c) 0]
		[(d) 1]
		[(e) 2]
		[(f) 3]
		[(g) 4]))

(define (note->letter a)
	(case a
		[(0) 'c]
		[(1) 'd]
		[(2) 'e]
		[(3) 'f]
		[(4) 'g]
		[(5) 'a]
		[(6) 'b]))

(define (note->semitones a)
	(case a
		[(0) 0] ; whole
		[(1) 2] ; whole
		[(2) 4] ; half
		[(3) 5] ; whole
		[(4) 7] ; whole
		[(5) 9] ; whole
		[(6) 11])) ; half

(struct pitch
	(note octave accidental)
	; note is a number representing the note's single-letter name (see note->letter and letter->note)
	; octave is an integer representing the octave (4 in C4)
	; accidental is the specifying the number of sharps applied (negative for flats)
	#:transparent
	#:guard (lambda (note octave accidental type-name)
		(if (and
				(and (integer? note) (0 . <= . note) (note . <= . 6))
				(integer? octave)
				(integer? accidental))
			(values note octave accidental)
			(error type-name "Type error ~e ~e ~e" note octave accidental))))

(define (string->pitch s_)
	; Letter-name + up to two-digit octave + a space + F for flat or S for sharp (repeat F or S if necessary)
	(let* (
		[s (string-downcase s_)]
		[i_ (list-index-of #\space (string->list s))]
		[i (if i_ i_ (string-length s))]
		[letter (string->symbol (substring s 0 1))]
		[octave (string->number (substring s 1 i))]
		[note (letter->note letter)]
		[accidental-list (string->list (substring s i))]
		[sharps (count (lambda (x) (char=? x #\s)) accidental-list)]
		[flats (count (lambda (x) (char=? x #\f)) accidental-list)]
		[accidentals (- sharps flats)])
		(pitch note octave accidentals)))
(module+ test (check-equal?
	(pitch 2 4 0)
	(string->pitch "E4")))
(module+ test (check-equal?
	(pitch 3 4 2)
	(string->pitch "F4 ss")))
(module+ test (check-equal?
	(pitch 0 -1 -1)
	(string->pitch "C-1 F")))


(define (pitch->semitones p)
	;; # of semitones from A0
	(+
		(* 12 (pitch-octave p))
		(note->semitones (pitch-note p))
		(pitch-accidental p)))

(define (pitch->midi p)
	(-
		(pitch->semitones p)
		(pitch->semitones (string->pitch "C-1"))))
(module+ test (check-eq?
	(pitch->midi (string->pitch "F4 s"))
	66))

(define (semitones->pitch s_ note)
	(let* (
		[s (- s_ (note->semitones note))]
		[octave (NM-quotient s 12)]
		[accidental (NM-remainder s 12)])
		(pitch note octave accidental)))
(module+ test (check-equal?
	(pitch 3 4 2)
	(semitones->pitch (pitch->semitones (string->pitch "F4 ss")) (letter->note 'f))))

(provide (all-defined-out))
