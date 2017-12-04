(use vector-lib)
(require-extension srfi-1)
(require-extension matchable)

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

(define (quarter-list l)
  (match-let* (((start end) (split-list l))
               ((first second) (split-list start))
               ((third fourth) (split-list end)))
    (list first second third fourth)))

;; check each quarter to see if number is in it,
;; if so, weight each item in list starting at
;; middle-1, increasing outwards. add weight to
;; square number for answer to riddle

(define (which-quarter num quarters)
  (match-let (((first second third fourth) quarters))
    (cond
     ((memq num first) first)
     ((memq num second) second)
     ((memq num third) third)
     ((memq num fourth) fourth))))

(define (make-weight-vector len)
  (list->vector
   (map (lambda (i)
          (abs (- i (- (/ len 2) 1))))
        (iota len))))

(match-let* ((target 325489)
             ((square-num square) (get-square target))
             (quarter (which-quarter target (quarter-list square)))
             (weights (make-weight-vector (length quarter)))
             (target-index (vector-index (lambda (x) (= x target)) (list->vector quarter))))
  (print (+ (floor (/ square-num 2)) (vector-ref weights target-index))))
