#lang racket
(require profile)
(require racket/random)
(require "prob_chords.rkt")
(require "solfege.rkt")
(require "prob_pitches.rkt")
(require "noise.rkt")

(define (sort-hash-by-val hash)
  (sort (hash->list hash) < #:key (lambda (pair) (cdr pair))))

(define (partial-sum lst)
  (define (partial-sum-helper lst acc out-list)
    (if (null? lst)
        out-list
        (let* (
               [elem (car lst)]
               [key (car elem)]
               [val (cdr elem)]
               [acc+ (+ acc val)])
        (partial-sum-helper (cdr lst) acc+ (append out-list (list (cons key acc+)))))))
  (partial-sum-helper lst 0 '()))

(define (find-first lst v)
  (let* (
         [elem (car lst)]
         [key (car elem)]
         [val (cdr elem)])
    (if (v . <= . val) key (find-first (cdr lst) v))))

(define (hash-pick hash)
  (let* (
         [lst (hash->list hash)]
         [lst_ (partial-sum lst)]
         [total (cdr (last lst_))]
         [r (* total (random))]
         [selected (find-first lst_ r)]
         ) selected))
  

(define (generate-chords-helper num duration vol chords pitchess rsounds)
  (if (= 0 num)
      (if (eq? (hash-pick final-chords/prob) (last chords))
          (list chords pitchess (rs-append* rsounds))
          (generate-chords-helper 1 duration vol chords pitchess rsounds))
      (if (null? chords)
          (let* (
                 [chord (hash-pick initial-chords/prob)]
                 [solfeges (chord->solfeges chord)]
                 
                 [pitches (hash-pick (initial-solfeges->pitches/prob solfeges))]
                 [rsound (pitches->rsound pitches duration vol)]
                 )
            (generate-chords-helper
             (sub1 num)
             duration
             vol
             (append chords (list chord))
             (append pitchess (list pitches))
             (append rsounds (list rsound))))
          (let* (
                 [prev-chord (last chords)]
                 [chord (hash-pick (next-chord/prob prev-chord))]
                 [solfeges (chord->solfeges chord)]
                 [prev-pitches (last pitchess)]
                 [pitches (hash-pick (solfeges->pitches/prob solfeges prev-pitches))]
                 [rsound (pitches->rsound pitches duration vol)]
                 )
            (generate-chords-helper
             (sub1 num)
             duration
             vol
             (append chords (list chord))
             (append pitchess (list pitches))
             (append rsounds (list rsound)))))))

(define (generate-chords num duration vol)
  (generate-chords-helper num duration vol '() '() '()))

(define music (generate-chords 9 0.7 1.5))

(first music)
(second music)
(read-line)
(rs-write (third music) "thing.wav")
(play (third music))
