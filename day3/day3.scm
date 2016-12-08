(define (is-triangle-possible? triangle)
  (and
    (> (+ (car triangle) (cadr triangle)) (caddr triangle))
    (> (+ (car triangle) (caddr triangle)) (cadr triangle))
    (> (+ (cadr triangle) (caddr triangle)) (car triangle))))

(define (parse-triangle triangle)
  (map string->number (string-split triangle)))

(define (count-possible-triangles triangle count)
  (if (not (eof-object? triangle))
    (if (is-triangle-possible? (parse-triangle triangle))
        (count-possible-triangles (read-line) (add1 count))
        (count-possible-triangles (read-line) count))
    count))

(define (main args)
  (print (count-possible-triangles (read-line) 0)))

