(use srfi-128)
(use srfi-113)

(define valid 0)

(define (sorted-word word)
  (list->string (sort (string->list word) char<?)))

(define (is-valid-recur words s)
  (cond
   ((null? words) #t)
   ((set-contains? s (sorted-word (car words))) #f)
   (else (is-valid-recur (cdr words) (set-adjoin s (sorted-word (car words)))))))

(define (is-valid words)
  (is-valid-recur words (set (make-comparator string? string=? string<? string-hash))))

(do ((line (read-line) (read-line))) ((eof-object? line))
  (if (is-valid (string-tokenize line)) (set! valid (add1 valid))))

(print valid)
