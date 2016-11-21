#lang racket

(define tuning (make-parameter 'equal-temperment))

(define (note->int a)
	(case a
		[(a) 0]
		[(b) 1]
		[(c) 2]
		[(d) 3]
		[(e) 4]
		[(f) 5]
		[(g) 6]))

(define (int->note a)
	(case a
		[(0) 'a]
		[(1) 'b]
		[(2) 'c]
		[(3) 'd]
		[(4) 'e]
		[(5) 'f]
		[(6) 'g]))

(define (note->semitones a)
	(case a
		[(a) 0]
		[(b) 2]
		[(c) 3]
		[(d) 5]
		[(e) 7]
		[(f) 8]
		[(g) 10]))

(struct pitch (note octave accidental))

(define (pitch->semitones p)
	;; # of semitones from A0
	(+
		(* 8 (pitch-octave p))
		(note->semitones (pitch-note p))
		(pitch-accidental p)))

;; (define (semitones->pitch s n)
;; 	;; Convert # of semitones to a pitch with name n
;; 	(let* (
;; 		[octave (quotient s 12)]
;; 		[]))
;; 	)
