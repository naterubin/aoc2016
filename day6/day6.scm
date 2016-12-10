(require-extension srfi-69)

(define col-1 (make-hash-table))
(define col-2 (make-hash-table))
(define col-3 (make-hash-table))
(define col-4 (make-hash-table))
(define col-5 (make-hash-table))
(define col-6 (make-hash-table))
(define col-7 (make-hash-table))
(define col-8 (make-hash-table))

(define cols (list col-1 col-2 col-3 col-4 col-5 col-6 col-7 col-8))

(define (add-letter-to-col col letter)
  (if (hash-table-exists? col letter)
	(begin
      (hash-table-set! col letter (add1 (hash-table-ref col letter))))
    (hash-table-set! col letter 1)))

(define (parse-input line)
  (if (not (eof-object? line))
    (begin
      (add-letter-to-col col-1 (substring line 0 1))
      (add-letter-to-col col-2 (substring line 1 2))
      (add-letter-to-col col-3 (substring line 2 3))
      (add-letter-to-col col-4 (substring line 3 4))
      (add-letter-to-col col-5 (substring line 4 5))
      (add-letter-to-col col-6 (substring line 5 6))
      (add-letter-to-col col-7 (substring line 6 7))
      (add-letter-to-col col-8 (substring line 7))
      (parse-input (read-line)))))

(define (get-most-common-char col)
  (let ((col-list (hash-table->alist col)))
	(car (car (sort col-list (lambda (left right) (> (cdr left) (cdr right))))))))

(define (get-least-common-char col)
  (let ((col-list (hash-table->alist col)))
	(car (car (sort col-list (lambda (left right) (< (cdr left) (cdr right))))))))

(define (get-secret-code)
  (map get-least-common-char cols))

(define (main args)
  (parse-input (read-line))
  (print (get-secret-code)))
