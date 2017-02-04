#lang racket
(module+ test (require rackunit))

; rrchord means relative relative chord
; It is relative to the root, but also relative to the key.
; If the rr-chord could be minor triad
; then the associated r-chord could be iii chord
; and the associated chord could be [E, G, B]
(define (rrchord->rchord rrchord root)
	(map
		(lambda (n) (modulo (+ n root) 12))
		rrchord))

; https://en.wikipedia.org/wiki/Triad_(music)#Construction
(define rr-triad '(
	[diminished (0 3 6)]
	[minor (0 3 7)]
	[major (0 4 7)]
	[augmented (0 4 8)]
))

; converts a pitch on a 7-tone scale to pitches on a 12-tone scale
(define (diatonic->chromatic a)
	(case a
		[(0) 0] ; whole
		[(1) 2] ; whole
		[(2) 4] ; half
		[(3) 5] ; whole
		[(4) 7] ; whole
		[(5) 9] ; whole
		[(6) 11] ; half
))

(define (roman degree quality added)
	(let* (
			[rrchord (second (assv quality rr-triad))]
			[root (diatonic->chromatic degree)]
			[rchord (rrchord->rchord rrchord root)]
			[rchord_ (append rchord added)])
		(sort rchord_ <)))

; TODO: don't predefine these
; Interpret on the fly instead
(define I (roman 0 'major '()))
(define ii (roman 1 'minor '()))
(define iii (roman 2 'minor '()))
(define IV (roman 3 'major '()))
(define V (roman 4 'major '()))
(define vi (roman 5 'minor '()))
(define vii* (roman 6 'diminished '()))

(module+ test (check-equal? vii* '(2 5 11)))

(provide I ii iii IV V vi vii*)