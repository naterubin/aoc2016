(use extras)
(use vector-lib)
(require-extension srfi-1)
(require-extension srfi-13)

(define checksums '())

(define (max-in-vec vec)
  (vector-fold
   (lambda (i max-num num) (max max-num num))
   (vector-ref vec 0) vec))

(define (min-in-vec vec)
  (vector-fold
   (lambda (i min-num num) (min min-num num))
   (vector-ref vec 0) vec))

(define (max-minus-min vec)
  (- (max-in-vec vec) (min-in-vec vec)))

(define (even-divisors vec num)
  (vector-fold
   (lambda (i state divisor)
     (if (and (= 0 (modulo num divisor)) (not (= num divisor)))
         (cons divisor state)
         state))
   '() vec))

(define (row-product-args vec)
  (vector-fold
   (lambda (i state num)
     (if (and (null? state) (not (null? (even-divisors vec num))))
         (list num (car (even-divisors vec num)))
         state))
   '() vec))

(define (row-product vec)
  (print vec)
  (let ((args (row-product-args vec)))
    (/ (car args) (cadr args))))

(define (line->vector line)
  (list->vector (map string->number (string-tokenize line))))

(define (compute-checksum line fun)
  (fun (line->vector line)))

(define (compute-checksums fun)
  (let ((line (read-line)))
    (if (not (eof-object? line))
        (begin
          (set! checksums (cons (compute-checksum line fun) checksums))
          (compute-checksums fun)))))

(compute-checksums max-minus-min)
(print (reduce + 0 checksums))

(define checksums '())

(compute-checksums row-product)
(print (reduce + 0 checksums))
