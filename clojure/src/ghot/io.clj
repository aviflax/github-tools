(ns ghot.io)

; TODO: should probably really just use some kind of logging “framework”

;; May be changed during development or testing, or via a CLI flag.
(defonce verbose? (atom false))

(defn verbose
  [& vs]
  (when @verbose?
    (apply println (concat ["\nVERBOSE:"] vs))))

; (defn warn
;   [& strs]
;   (binding [*out* *err*]
;     (apply println strs)))
