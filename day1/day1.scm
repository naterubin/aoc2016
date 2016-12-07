(require-extension srfi-13)
(require-extension s)

(define orientation 'N)
(define vertical-blocks 0)
(define horizontal-blocks 0)

(define (modify-blocks direction magnitude)
  (case direction
    ('N (set! vertical-blocks (+ vertical-blocks magnitude)))
    ('S (set! vertical-blocks (- vertical-blocks magnitude)))
    ('E (set! horizontal-blocks (+ horizontal-blocks magnitude)))
    ('W (set! horizontal-blocks (- horizontal-blocks magnitude)))))

(define (turn-right)
  (case orientation
    ('N (set! orientation 'E))
    ('E (set! orientation 'S))
    ('S (set! orientation 'W))
    ('W (set! orientation 'N))))

(define (turn-left)
  (case orientation
    ('N (set! orientation 'W))
    ('W (set! orientation 'S))
    ('S (set! orientation 'E))
    ('E (set! orientation 'N))))

(define (reorient turn-direction)
  (cond
    ((equal? turn-direction "R") (turn-right))
    ((equal? turn-direction "L") (turn-left))))

(define (parse-input input)
  (map (lambda (instruction)
         (list (substring/shared instruction 0 1) (substring/shared instruction 1)))
       (map s-trim (string-split input ","))))

(define (main args)
  (let ((directions (parse-input (read-line))))
   (map (lambda (direction)
          (reorient (first direction))
          (modify-blocks orientation (string->number (second direction))))
        directions)
   (print (+ (abs vertical-blocks) (abs horizontal-blocks)))))
