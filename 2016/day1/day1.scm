(require-extension srfi-13)
(require-extension srfi-69)
(require-extension s)

(define orientation 'N)
(define vertical-blocks 0)
(define horizontal-blocks 0)
(define visited-locations (make-hash-table))

(define (location-visited? location)
  (let ((x (first location)) (y (second location)))
   (if (hash-table-exists? visited-locations x)
     (if (member y (hash-table-ref visited-locations x)) #t #f)
     #f)))

(define (add-location location)
  (let ((x (first location)) (y (second location)))
    (if (hash-table-exists? visited-locations x)
        (hash-table-set! visited-locations
                        x
                        (cons y (hash-table-ref visited-locations x)))
        (hash-table-set! visited-locations x (list y)))))

(define (enumerate-blocks direction magnitude)
  (let ((blocks-moved (+ 1 magnitude)))
    (case direction
        ('N (cdr (map list (iota (abs blocks-moved) horizontal-blocks 0) (iota (abs blocks-moved) vertical-blocks 1))))
        ('S (cdr (map list (iota (abs blocks-moved) horizontal-blocks 0) (iota (abs blocks-moved) vertical-blocks -1))))
        ('E (cdr (map list (iota (abs blocks-moved) horizontal-blocks 1) (iota (abs blocks-moved) vertical-blocks 0))))
        ('W (cdr (map list (iota (abs blocks-moved) horizontal-blocks -1) (iota (abs blocks-moved) vertical-blocks 0)))))))

(define (move direction magnitude)
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

(define (blocks-away directions)
    (map (lambda (direction)
            (reorient (first direction))
            (move orientation (string->number (second direction))))
        directions)
    (print (+ (abs vertical-blocks) (abs horizontal-blocks))))

(define (blocks-visited-in-direction direction)
  (enumerate-blocks orientation (string->number (second direction))))

(define (which-locations-visited locations)
  (filter location-visited? locations))

(define (add-locations locations)
  (map add-location locations))

(define (find-first-double-visit directions)
  (if (> (length directions) 0)
    (begin
        (reorient (first (car directions)))
        (let ((blocks (blocks-visited-in-direction (car directions))))
            (if (> (length (which-locations-visited blocks)) 0)
                (car (which-locations-visited blocks))
                (begin
                    (add-locations blocks)
                    (move orientation (string->number (second (car directions))))
                    (find-first-double-visit (cdr directions))))))
    '()))

(define (main args)
  (cond
    ((equal? (first args) "find_double")
     (hash-table-set! visited-locations 0 '(0))
     (let ((first-double (find-first-double-visit (parse-input (read-line)))))
      (print (+ (abs (first first-double)) (abs (second first-double))))))
    ((equal? (first args) "blocks_away")
     (print (blocks-away (parse-input (read-line)))))
    (else (print "Invalid action"))))
