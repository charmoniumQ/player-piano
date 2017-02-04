#lang racket
(require rsound)
(require rsound/piano-tones)
(module+ test (require rackunit))

(define (chord->rsound chord key sec)
	(let* (
		[absolute-chord (map (curry + key) chord)]
		[rsounds (map piano-tone absolute-chord)]
		[rsound (rs-overlay* rsounds)]
		[clipped-rsound (clip rsound 0 (exact-round (* sec FRAME-RATE)))])
	clipped-rsound))

(define (chords->rsound chords key sec)
	(let* (
		[rsounds (map (curryr chord->rsound key sec) chords)]
		[rsound (rs-append* rsounds)])
	rsound))

(define (rchord->chord rchord key)
	(map (curry + key) rchord))

;(define music '(
;[0 4 7]
;[0 5 9]
;[0 4 7]
;[-1 2 7]
;[0 4 12]
;))

;(play (chords->rsound music 50 1))

(provide play chord->rsound chords->rsound)
