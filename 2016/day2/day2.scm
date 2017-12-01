(define col 0)
(define row 2)

(define keypad
  '((-1 -1 1 -1 -1)
    (-1 2 3 4 -1)
    (5 6 7 8 9)
    (-1 \#A \#B \#C -1)
    (-1 -1 \#D -1 -1)))

(define code '())

(define (move-finger direction)
  (cond
    ((equal? direction #\U) (if (eq? row 0) '() (set! row (sub1 row))))
    ((equal? direction #\D) (if (eq? row 4) '() (set! row (add1 row))))
    ((equal? direction #\L) (if (eq? col 0) '() (set! col (sub1 col))))
    ((equal? direction #\R) (if (eq? col 4) '() (set! col (add1 col))))))

(define (key-under-finger)
  (list-ref (list-ref keypad row) col))

(define (move direction)
  (let ((old-col col) (old-row row))
   (move-finger direction)
   (if (equal? (key-under-finger) -1)
     (begin
        (set! col old-col)
        (set! row old-row)))))

(define (add-number-to-code)
  (set! code (append code (list (key-under-finger)))))

(define (follow-line line)
  (map move (string->list line)))

(define (get-next-code-number line)
  (if (not (eof-object? line))
    (begin
      (follow-line line)
      (add-number-to-code)
      (get-next-code-number (read-line)))))

(define (main args)
  (get-next-code-number (read-line))
  (print code))
