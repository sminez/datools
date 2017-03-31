#!/usr/bin/hy
(import json)
(import requests)
(import [urllib.parse :as parse])

(setv token "e32443a4b3b1c2fa928d0aa5cf657cb7ea058818")
(setv URL "https://todoist.com/API/v7/sync")

(defn query [query-string]
  "Return a count of the number of tasks meeting query-string"
  (setv queries (.split query-string ", "))
  (setv params [(, "token" token) (, "queries" (.dumps json queries))])
  (setv req-url (.format "{}/query?{}" URL (.urlencode parse params)))
  (setv response (.get requests req-url))
  (print response)
  (setv json-response (.json response))
  (setv count (sum (list-comp
                    (len (get resp "data"))
                    (resp json-response))))
  count)

(defmain [&rest args]
  "Generate a formatted, pango coloured output for use with i3blocks"
  (setv over (query "overdue"))
  (setv today-and-over (query "today"))
  (setv coming-week (query "overdue, mon, tues, wed, thurs, fri, sat, sun"))
  (cond
   [(> over 0)
    ;; Things need doing NOW!
    (print (.format "<span foreground='#cb6077'> {}!/{}/{}</span>" over today-and-over coming-week))]
   [(and (> today-and-over 0) (> coming-week 0))
    ;; Still stuff to do today and a busy week ahead
    (print (.format "<span foreground='#f4bc87'> {}/{}/{}</span>" over today-and-over coming-week))]
   [(and (= today-and-over 0) (> coming-week 0))
    ;; Done for today but things due in the coming week
    (print (.format "<span foreground='#7bbda4'> {}/{}/{}</span>" over today-and-over coming-week))]
   [True
    ;; Clear skies for the week ahead!
    (print (.format "<span foreground='#beb55b'> {}/{}/{}</span>" over today-and-over coming-week))]))
