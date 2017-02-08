#lang racket

(require "solfege.rkt")

(define (solfege->pitch s octave key)
  (+ s (* 12 octave) key))

(define (solfege->pitches s key)
  (apply set (map
              (lambda (octave) (solfege->pitch s octave key))
              (range 5 9))))
(module+ test (solfege->pitches 2 0))

(define (solfeges->pitches ss key)
  (apply set-union (set-map ss (curryr solfege->pitches key))))
(module+ test (solfeges->pitches (set 0 1) 0))

(define (solfegess->pitchess sss key) (map (curryr solfeges->pitches key) sss))

(provide solfeges->pitches solfegess->pitchess)