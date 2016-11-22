#lang racket
(require "pitch.rkt")
(module+ test (require rackunit))

(struct interval
	(quality number)
	#:transparent
	#:guard (lambda (quality number type-name)
		(if
			(and
				(list? (member quality '(perfect augmented diminished major minor)))
				(list? (member number '(unison second third fourth fifth sixth seventh octave))))
			(values quality number)
			(error type-name "Type error ~e ~e" quality number))))

(define (interval-number-note interval)
	(case (interval-number interval)
		[(unison) 0]
		[(second) 1]
		[(third) 2]
		[(fourth) 3]
		[(fifth) 4]
		[(sixth) 5]
		[(seventh) 6]
		[(octave) 7]))

(define (interval->semitones interval)
	(let* (
		[base
			(case (interval-number interval)
				[(unison) 0]
				[(second) 3/2]
				[(third) 7/2]
				[(fourth) 3]
				[(fifth) 4]
				[(sixth) 17/2]
				[(seventh) 19/2]
				[(octave) 7]
				[else (error "Not a valid interval number " (interval-number interval))])]
		[modifier
		 	(case (interval-number interval)
				[(unison fourth fifth octave)
					(case (interval-quality interval)
						[(perfect) 0]
						[(augmented) 1]
						[(diminished) -1]
						[else (error "Not a valid quality " (interval-quality interval))])]
				[(second third sixth seventh)
					(case (interval-quality interval)
						[(major) 1/2]
						[(minor) -1/2]
						[(augmented) 3/2]
						[(diminished) -3/2]
						[else (error "Not a valid quality " (interval-quality interval))])]
				[else (error "Not a valid interval number " (interval-number interval))])])
	(exact-round (+ base modifier))))

(define (interval->pitch interval root)
	(semitones->pitch
		(+ (pitch->semitones root) (interval->semitones interval)) ; semitones of new pitch
		(+ (pitch-note root) (interval-number-note interval)))) ; note to align it to
(module+ test (check-equal?
	(string->pitch "E4 f")
	(interval->pitch (interval 'minor 'third) (string->pitch "C4"))))
(module+ test (check-equal?
	(string->pitch "D4 s")
	(interval->pitch (interval 'augmented 'second) (string->pitch "C4"))))
