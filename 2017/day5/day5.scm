(use extras)
(use vector-lib)

(define instruction-pointer 0)
(define jumps 0)
(define tape #())

(define (execute-tape)
  (let ((offset (vector-ref tape instruction-pointer)))
    (if (>= offset 3)
        (vector-set! tape instruction-pointer (sub1 offset))
        (vector-set! tape instruction-pointer (add1 offset)))
    (set! instruction-pointer (+ instruction-pointer offset))
    (set! jumps (add1 jumps))
    (if (>= instruction-pointer (vector-length tape))
        jumps
        (execute-tape))))

(do ((line (read-line) (read-line))) ((eof-object? line))
  (set! tape (vector-append tape (vector (string->number line)))))

(print (execute-tape))
