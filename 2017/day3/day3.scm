(require-extension srfi-1)

(define (numbers-in-square dim start)
  (iota (+ (* dim 2) (* (- dim 2) 2)) start))

(define (get-square-recur num dim start)
  (let ((square (numbers-in-square dim start)))
    (if (memq num square)
        (list dim square)
        (get-square-recur num (+ dim 2) (+ (last square) 1)))))

(define (get-square num)
  (get-square-recur num 3 2))

(define (split-list l)
  (let ((len (/ (length l) 2)))
    (list (take l len) (drop l len))))

;; doesn't work, match-let undefined
(define (quarter-list l)
  (match-let (((list start end) (split-list l)))
    (list (split-list start) (split-list end))))

;; check each quarter to see if number is in it,
;; if so, weight each item in list starting at
;; middle-1, increasing outwards. add weight to
;; square number for answer to riddle
