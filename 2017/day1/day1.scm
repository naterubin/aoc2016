(use extras)
(use vector-lib)
(require-extension srfi-1)
(require-extension srfi-13)

(define (char->number c)
  (string->number (string c)))

(define (string->number-list s)
  (map char->number (string-fold-right cons '() s)))

(define (circular-vec-ref vec i)
  (vector-ref vec (modulo i (vector-length vec))))

(define (next-digit-matches vec jump)
  (vector-fold
   (lambda (i matches num)
     (if (= num (circular-vec-ref vec (+ i jump)))
         (cons num matches)
         matches))
   '()
   vec))

(define (get-last l)
  (if (null? (cdr l))
      (car l)
      (get-last (cdr l))))

(define (adjacent-matches input-string)
  (let* ((numbers (list->vector (string->number-list input-string)))
         (matches (next-digit-matches numbers 1)))
    (print (reduce + 0 matches))))

(define (half-across-matches input-string)
  (let* ((numbers (list->vector (string->number-list input-string)))
         (matches (next-digit-matches numbers (/ (vector-length numbers) 2))))
    (print (reduce + 0 matches))))

(define input-string (read-line))
(adjacent-matches input-string)
(half-across-matches input-string)
