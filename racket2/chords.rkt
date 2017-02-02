#lang racket

(define (note? n)
	(and
		(integer? n)
		(0 . <= . n)
		(n . <= . 12)))

; https://en.wikipedia.org/wiki/Triad_(music)#Construction
(define rel-chords '(
	[diminished-triad (0 3 6)]
	[minor-triad (0 3 7)]
	[major-triad (0 4 7)]
	[augmented-triad (0 4 8)]
))
