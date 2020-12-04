#lang racket

(define row% (class object%
               (super-new)
               (init x)

               (define trees
                 (map (λ (c) (eq? c #\#)) (string->list x)))

               (define width (length trees))

               (define/public (tree-at-column col)
                 (list-ref trees (modulo col width)))))

(define toboggan% (class object%
                    (super-new)
                    (init run rise)

                    (define slope (list run rise))

                    (define/public (sled rows)
                      (for/fold ([hits 0])
                                ([row (in-vector rows 0 #f (second slope))]
                                 [col (in-range 0 +inf.0 (first slope))])
                        (if (send row tree-at-column col)
                            (+ hits 1)
                            hits)))))

(define rows
  (let ([f (open-input-file "input.txt")])
    (list->vector
     (for/list ([line (in-lines f)])
      (new row% [x line])))))

(let ([t1 (new toboggan% [rise 1] [run 1])]
      [t2 (new toboggan% [rise 1] [run 3])]
      [t3 (new toboggan% [rise 1] [run 5])]
      [t4 (new toboggan% [rise 1] [run 7])]
      [t5 (new toboggan% [rise 2] [run 1])])
  (apply * (map (λ (t) (send t sled rows)) (list t1 t2 t3 t4 t5))))
