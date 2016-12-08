(define triangle-1 '())
(define triangle-2 '())
(define triangle-3 '())

(define (is-triangle-possible? triangle)
  (and
    (> (+ (car triangle) (cadr triangle)) (caddr triangle))
    (> (+ (car triangle) (caddr triangle)) (cadr triangle))
    (> (+ (cadr triangle) (caddr triangle)) (car triangle))))

(define (parse-line line)
  (map string->number (string-split line)))

(define (append-to-triangles line)
  (let ((parsed-line (parse-line line)))
   (set! triangle-1 (cons (car parsed-line) triangle-1))
   (set! triangle-2 (cons (cadr parsed-line) triangle-2))
   (set! triangle-3 (cons (caddr parsed-line) triangle-3))))

(define (reset-triangles)
  (set! triangle-1 '())
  (set! triangle-2 '())
  (set! triangle-3 '()))

(define (count-possible-triangles line count)
  (if (eof-object? line)
    count
    (begin
      (append-to-triangles line)
      (if (eq? 3 (length triangle-1))
        (let ((possible-triangles 0))
         (if (is-triangle-possible? triangle-1)
           (set! possible-triangles (add1 possible-triangles)))
         (if (is-triangle-possible? triangle-2)
           (set! possible-triangles (add1 possible-triangles)))
         (if (is-triangle-possible? triangle-3)
           (set! possible-triangles (add1 possible-triangles)))
         (reset-triangles)
         (count-possible-triangles (read-line) (+ count possible-triangles)))
        (count-possible-triangles (read-line) count)))))

(define (main args)
  (print (count-possible-triangles (read-line) 0)))
