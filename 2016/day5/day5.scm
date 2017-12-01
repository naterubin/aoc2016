(use md5 message-digest)
(use srfi-13)

(define door-id "uqwqemis")

(define (check-valid-digest digest)
  (equal?
    "00000"
    (string-take digest 5)))

(define (get-password-digit-from-digest digest)
  (list (string->number (substring digest 5 6)) (substring digest 6 7)))

(define (current-index index)
  (string-append door-id (number->string index)))

(define (find-password index password)
  (if (eq? 8 (length password))
    password
    (let ((digest (message-digest-string (md5-primitive) (current-index index))))
     (if (check-valid-digest digest)
       (find-password (add1 index) (append password (get-password-digit-from-digest digest)))
       (find-password (add1 index) password)))))

(define (sort-password password)
  (print password)
  (sort password (lambda (left right) (char<? (car left) (car right)))))

(define (main args)
  (print (map cdr (sort-password (find-password 0 '())))))
