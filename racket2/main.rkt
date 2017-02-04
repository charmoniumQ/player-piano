#lang racket

(require racket/random)
(require "chords.rkt")
(require "audio.rkt")

(define chord-transitions (list
    [list I (list ii iii IV V vi vii*)]
    [list ii (list V vii*)]
    [list iii (list IV vi)]
    [list IV (list ii V vii*)]
    [list V (list I vi)]
    [list vi (list ii IV vii*)]
    [list vii* (list I V vi)]
))

(define (valid-chords prev-chord)
  (second (assoc prev-chord chord-transitions)))

; Root motion up a fourth, up a second, or down a third
; Dominant chords (V vii*) resolve
; Do not approach iii from ii IV V vii*
; i can go anywhere
; iii doesn't go to i

(define (generate num)
  (let generate ([chords (list I)] [n num])
    (if (= 0 n)
        (if (equal? I (last chords))
            chords
            (generate chords 1))
        (let* (
               [last-chord (last chords)]
               [next-chord (random-ref (valid-chords last-chord))]
               [chords_ (cons next-chord chords)])
          (generate chords_ (- n 1))))))

(define (voice chord)
  (map (lambda (n)
         (+ (* n 12) (random-ref chord)))
       (range 4)))

(define music (map voice (generate 15)))
(display music)
(newline)
(play (chords->rsound music 40 1))

; parallel fifths/octaves
; parallel movement
; tritones
; 
