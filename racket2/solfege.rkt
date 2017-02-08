#lang racket
(require "chords.rkt")

(define triad-data
  (hasheq
   'diminished (seteq 0 3 6)
   'minor (seteq 0 3 7)
   'major (seteq 0 4 7)
   'augmented (seteq 0 4 8)
   ))

(define (root-chord root chord)
  (apply set (set-map
   chord
   (lambda (n) (modulo (+ n root) 12)))))

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
         [triad (hash-ref triad-data quality)]
         [root (diatonic->chromatic degree)]
         [rchord (root-chord root triad)]
         [rchord_ (set-union rchord (apply set added))])
    rchord_))


(define chord->solfeges-data
  (hasheq
   I (roman 0 'major '())
   ii (roman 1 'minor '())
   iii (roman 2 'minor '())
   IV (roman 3 'major '())
   V (roman 4 'major '())
   vi (roman 5 'minor '())
   vii* (roman 6 'diminished '())
   ))

(define (chord->solfeges chord) (hash-ref chord->solfeges-data chord))
(module+ test (chord->solfeges I))

(define (chords->solfegess chords) (map chord->solfeges chords))
(module+ test (chords->solfegess '(I)))

(provide chord->solfeges chords->solfegess)