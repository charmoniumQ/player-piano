#lang racket
(require "chords.rkt")

(define initial-chords/prob (hasheq I 1 i 1 vii* 0.3))
(define final-chords/prob (hasheq I 1 i 1))

(define chord-probability-data
  (hasheq
   ; major
   I (hasheq ii 1 II 1 iii 1 IV 1 V 1 vi 1 vii* 1)
   ii (hasheq V 1 vii* 1)
   iii (hasheq IV 1 vi 1)
   IV (hasheq ii 1 II 1 V 1 vii* 1)
   V (hasheq i 1 I 1 vi 1 bVI 1) ; modulates to minor
   vi (hasheq ii 1 II 1 IV 1 vii* 1)
   vii* (hasheq I 1 V 1 vi 1 i 1 V 1 bVI 1) ; modulates to minor
   ; minor
   i (hasheq ii* 1 bIII 1 iv 1 V 1 bVI 1 vii* 1)
   ii* (hasheq V 1 vii* 1)
   bIII (hasheq iv 1 bVI 1)
   iv (hasheq ii* 1  II 1 V 1 vii* 1)
   bVI (hasheq ii* 1 II 1 iv 1 vii* 1)
   ; tonicization
   II (hasheq V 1 iii 1)
   ))

;(define (chord-transitions prev-chord)
;  (apply set
;         (hash-keys (hash-ref chord-probability-data prev-chord))))
;(module+ test (set-map initial-chords chord-transitions))

(define (next-chord/prob prev-chord)
  (hash-ref chord-probability-data prev-chord))

(provide initial-chords/prob final-chords/prob next-chord/prob)