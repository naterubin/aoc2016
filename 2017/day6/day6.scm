(use srfi-128)
(use srfi-113)
(use vector-lib)

(define list-comp
  (make-list-comparator (make-comparator number? equal? < number-hash)
                        list? null? car cdr))
(define configs-seen (set list-comp))
(define cycles 0)
(define banks '())

(define (largest-bank)
  (vector-fold
   (lambda (i max num)
     (if (> num (cdr max)) (cons i num) max))
   (cons -1 0) banks))

(define (next-bank i)
  (let ((next-i (add1 i)))
    (if (>= next-i (vector-length banks))
        0
        next-i)))

(define (distribute start amount)
  (if (> amount 0)
      (begin
        (vector-set! banks start (add1 (vector-ref banks start)))
        (if (= start (sub1 (vector-length banks)))
            (distribute 0 (sub1 amount))
            (distribute (add1 start) (sub1 amount))))))

(define (distribute-until-found)
  (let ((max (largest-bank)))
    (vector-set! banks (car max) 0)
    (distribute (next-bank (car max)) (cdr max))
    (if (not (set-contains? configs-seen (vector->list banks)))
        (begin
          (set-adjoin! configs-seen (vector->list banks))
          (set! cycles (add1 cycles))
          (distribute-until-found))
        (set! cycles (add1 cycles)))))

(set! banks (list->vector (map string->number (string-tokenize (read-line)))))
(distribute-until-found)
(print cycles)

(set! cycles 0)
(set! configs-seen (set list-comp))
(set-adjoin! configs-seen (vector->list banks))
(distribute-until-found)
(print cycles)
