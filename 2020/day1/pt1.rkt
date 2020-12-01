#lang racket

(require racket/set)

(define report
  (let ([f (open-input-file "input.txt")])
    (map string->number (sequence->list (in-lines f)))))

(define pairs (mutable-set))

(define (build-report-pairs report)
  (for ([other (cdr report)])
    (set-add! pairs (sort (list (car report) other) <)))
  (if (not (empty? (cdr report)))
      (build-report-pairs (cdr report))
      '()))

(define triples (mutable-set))

(define (build-report-triples report)
  (for* ([(v1 i) (in-indexed (in-list report))]
        [(v2 j) (in-indexed (in-list report))]
        [(v3 k) (in-indexed (in-list report))])
    (if (and (not (= i j))
             (not (= j k)))
        (set-add! triples (sort (list v1 v2 v3) <))
        '())))

(build-report-pairs report)
(build-report-triples report)
(let* ([pair-list (set->list pairs)]
       [desired-pair (car (filter (λ (p) (= 2020 (apply + p))) pair-list))]
       [triple-list (set->list triples)]
       [desired-triple (car (filter (λ (p) (= 2020 (apply + p))) triple-list))])
  (values (apply * desired-pair)
          (apply * desired-triple)))
