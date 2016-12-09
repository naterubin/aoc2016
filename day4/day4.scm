(require-extension irregex)
(require-extension srfi-1)
(require-extension srfi-13)
(require-extension srfi-69)

(define-record room-name name sector-id checksum)

(define room-name-regex "([A-Za-z|-]+)(\\d+)\\[([A-Za-z]+)\\]")

(define (parse-room-name name)
  (let ((match (irregex-match room-name-regex name)))
   (make-room-name
     (string-delete #\- (irregex-match-substring match 1))
     (string->number (irregex-match-substring match 2))
     (irregex-match-substring match 3))))

(define (letter-freq-comparison left right)
  (if (eq? (cdr left) (cdr right))
    (char<? (car left) (car right))
    (> (cdr left) (cdr right))))

(define (generate-frequency-map letters)
  (let ((letter-frequency (make-hash-table)))
   (map (lambda (letter)
          (if (hash-table-exists? letter-frequency letter)
            (hash-table-set!
              letter-frequency
              letter
              (add1 (hash-table-ref letter-frequency letter)))
            (hash-table-set! letter-frequency letter 1)))
        letters)
   (sort (hash-table->alist letter-frequency) letter-freq-comparison)))

(define (frequency-list->string freq-list)
  (list->string (map (lambda (pair) (car pair)) freq-list)))

(define (generate-checksum name)
  (frequency-list->string (take (generate-frequency-map (string->list name)) 5)))

(define (count-valid-rooms line sum)
  (if (eof-object? line)
    sum
    (let ((name (parse-room-name line)))
     (if (equal? (room-name-checksum name) (generate-checksum (room-name-name name)))
       (count-valid-rooms (read-line) (+ sum (room-name-sector-id name)))
       (count-valid-rooms (read-line) sum)))))

(define (main args)
  (print (count-valid-rooms (read-line) 0)))
