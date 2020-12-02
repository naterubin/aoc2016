#lang racket

(define (char-occurrences str c)
  (length (filter (λ (x) x) (map (λ (c1) (eq? c c1)) (string->list str)))))

(define password% (class object%
                    (init pass special-char min-occur max-occur)
                    (define my-pass pass)
                    (define my-special-char special-char)
                    (define my-min-occur min-occur)
                    (define my-max-occur max-occur)
                    (super-new)

                    (define/public (valid?)
                      (let ([occurs (char-occurrences my-pass my-special-char)])
                        (and (>= occurs my-min-occur)
                             (<= occurs my-max-occur))))

                    (define/public (valid-two?)
                      (let ([first-match (eq? my-special-char (string-ref my-pass (- my-min-occur 1)))]
                            [second-match (eq? my-special-char (string-ref my-pass (- my-max-occur 1)))])
                        (xor first-match second-match)))))


(define (password-factory input)
  (let ([match (regexp-match #px"(\\d+)-(\\d+) (\\w): (\\w+)" input)])
    (new password%
         [pass (list-ref match 4)]
         [special-char (string-ref (list-ref match 3) 0)]
         [min-occur (string->number (list-ref match 1))]
         [max-occur (string->number (list-ref match 2))])))

(define passwords '())

(let ([f (open-input-file "input.txt")])
  (for ([line (in-lines f)])
    (set! passwords (cons (password-factory line) passwords))))

(printf "Part I : ~a valid passwords\n" (length (filter (λ (p) (send p valid?)) passwords)))

(printf "Part II: ~a valid passwords\n" (length (filter (λ (p) (send p valid-two?)) passwords)))
