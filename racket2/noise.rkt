#lang racket
(require rsound)
(require rsound/piano-tones)

(define (robust-clip rsound duration)
  (let* (
        [frames_want (exact-round (* duration FRAME-RATE))]
        [frames (rs-frames rsound)])
    (if (frames_want . > . frames)
         (robust-clip (rs-append* (make-list (exact-ceiling (/ frames_want frames)) rsound)) duration)
         (clip rsound 0 frames_want))))

(define (pitches->rsound pitches duration)
  (let* (
         [rsounds (map piano-tone pitches)]
         [rsounds_ (map
                    (curryr robust-clip duration)
                    rsounds)]
         [rsound (rs-overlay* rsounds_)])
    rsound))

(define (pitchess->rsound pitchess duration)
  (rs-append* (map (curryr pitches->rsound duration) pitchess)))

(provide pitches->rsound rs-append* pitchess->rsound play)