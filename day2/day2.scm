(define col 1)
(define row 1)

(define keypad
  '((1 2 3)
    (4 5 6)
    (7 8 9)))

(define code '())

(define (move direction)
  (cond
    ((equal? direction #\U) (if (eq? row 0) '() (set! row (sub1 row))))
    ((equal? direction #\D) (if (eq? row 2) '() (set! row (add1 row))))
    ((equal? direction #\L) (if (eq? col 0) '() (set! col (sub1 col))))
    ((equal? direction #\R) (if (eq? col 2) '() (set! col (add1 col))))))

(define (add-number-to-code)
  (set! code (append code (list (list-ref (list-ref keypad row) col)))))

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
