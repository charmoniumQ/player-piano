#lang racket

(define (motion pitch pitches2)
  (cond
    [(and
      (set-member? pitches2 (add1 pitch))
      (set-member? pitches2 (sub1 pitch))) 'both]
    [(set-member? pitches2 (add1 pitch)) 'upward]
    [(set-member? pitches2 (sub1 pitch)) 'downward]
    ['neither]
    ))

(define (parallel pitch pitches2 interval)
  (eq? (motion pitch pitches2) (motion (+ pitch interval) pitches2)))

(define fifth 7) ; in semitones
(define octave 12) ; in semitones

(define parallel-fifth (curryr parallel fifth))
(define parallel-octave (curryr parallel octave))

(define (octave-redundant pitches)
  (if ((set-count pitches) . > . (set-count
                                  (for/set ([pitch pitches]) (modulo pitch octave))))
      #t
      #f))

(define (pitch-probability pitches prev-pitches)
  (*
   (expt 0.5 (count (curryr parallel-octave prev-pitches) pitches))
   (expt 0.8 (count (curryr parallel-fifth prev-pitches) pitches))
   (if (octave-redundant pitches) 0.9 1)
   ))

(define (solfeges->pitch solfeges octave_ i)
  (+
   (list-ref (sort (set->list solfeges) <) i)
   (* octave_ octave)))

(define (solfeges->pitch/i solfeges n start)
  (for/list ([i (range start (+ n start))])
    (solfeges->pitch solfeges (exact-floor (/ i 3)) (modulo i 3))))

(define (solfeges->pitches/all solfeges)
  (cartesian-product
   (solfeges->pitch/i solfeges 4 12) ; basses starting at octave 16/3 going up 5/3 octaves
   (solfeges->pitch/i solfeges 4 15)
   (solfeges->pitch/i solfeges 4 18)
   (solfeges->pitch/i solfeges 4 21)))

(define (solfeges->pitches/prob solfeges prev-pitches)
  (make-hasheq (map (lambda (pitches)
         (cons pitches (pitch-probability pitches prev-pitches)))
       (solfeges->pitches/all solfeges))))

(define (initial-solfeges->pitches/prob solfeges)
  (make-hasheq (map (lambda (pitches)
         (cons pitches 1))
       (solfeges->pitches/all solfeges))))

;(solfeges->pitches/prob '(0 4 7) '(77 81 84))

(provide solfeges->pitches/prob initial-solfeges->pitches/prob)