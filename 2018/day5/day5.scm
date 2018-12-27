(use-modules (srfi srfi-1))

(define (opposite-polarity unit1 unit2)
  (if (char-lower-case? unit1)
    (char-upper-case? unit2)
    (char-lower-case? unit2)))

(define (units-cancel? unit1 unit2)
  (if (opposite-polarity unit1 unit2)
    (eq? (char-upcase unit1) (char-upcase unit2))
    #f))

(define (react-polymer input)
    (let ((polymer '()))
      (set! polymer (cons (read-char input) polymer))
      (do ((unit (read-char input) (read-char input)))
          ((eof-object? unit) #nil)
            (if (and (not (= 0 (length polymer))) (units-cancel? unit (car polymer)))
              (set! polymer (cdr polymer))
              (set! polymer (cons unit polymer))))
      polymer))

(display "Count after initial reaction: ")
(display (length (call-with-input-file "input.txt" react-polymer)))
(newline)

(define (make-exclude-port inport exclude-char)
  (make-soft-port
    (vector
      #f
      #f
      #f
      (lambda ()
        (let loop ((next-char (read-char inport)))
         (if (and (not (eof-object? next-char))
                  (eq? (char-upcase next-char) (char-upcase exclude-char)))
           (loop (read-char inport))
           next-char)))
      (lambda () (close inport)))
    "r"))

(for-each (lambda (ch)
            (let ((ex-port (make-exclude-port (open-file "input.txt" "r") ch)))
                  (display ch)
                  (display ": ")
                  (display (length (react-polymer ex-port)))
                  (newline)
                  (close ex-port)))
          (map integer->char (iota 26 97)))
