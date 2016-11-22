#lang racket
(module+ test (require rackunit))

; Nearest-multiple quotient
(define (NM-quotient a b) (round (/ a b)))
(module+ test (check-eq? (NM-quotient 10 3) 3))
(module+ test (check-eq? (NM-quotient 8 3) 3))
(module+ test (check-eq? (NM-quotient -10 3) -3))
(module+ test (check-eq? (NM-quotient -8 3) -3))

(define (NM-multiple a b) (* (NM-quotient a b) b))
(module+ test (check-eq? (NM-multiple 10 3) 9))
(module+ test (check-eq? (NM-multiple -10 3) -9))

(define (NM-remainder a b) (- a (NM-multiple a b)))
(module+ test (check-eq? (NM-remainder 10 3) 1))
(module+ test (check-eq? (NM-remainder -10 3) -1))

(define (list-index-of e list)
	(let loop ([list list] [i 0])
		(if (null? list)
			#f
			(if (equal? (car list) e)
				i
				(loop (cdr list) (+ i 1))))))
(module+ test (check-eq? (list-index-of 3 '(7 8 3 4)) 2))
(module+ test (check-eq? (list-index-of 3 '(2 1 4 5)) #f))

(provide (all-defined-out))
