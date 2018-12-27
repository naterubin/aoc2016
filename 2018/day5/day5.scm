(define (opposite-polarity unit1 unit2)
  (if (char-lower-case? unit1)
    (char-upper-case? unit2)
    (char-lower-case? unit2)))

(define (units-cancel? unit1 unit2)
  (if (opposite-polarity unit1 unit2)
    (eq? (char-upcase unit1) (char-upcase unit2))
    #f))

(define polymer '())

(call-with-input-file "input.txt"
  (lambda (input)
    (begin
      (set! polymer (cons (read-char input) polymer))
      (do ((unit (read-char input) (read-char input)))
          ((eof-object? unit) #nil)
            (if (and (not (= 0 (length polymer))) (units-cancel? unit (car polymer)))
              (set! polymer (cdr polymer))
              (set! polymer (cons unit polymer))))
      (display (length polymer)))))
