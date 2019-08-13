(ns ghot.io.cli.util)

;; Set to false for development or testing.
(defonce exit-on-exit? (atom true))

(defn exit
  [code & msgs]
  (when (seq msgs)
    (apply println msgs))
  (if @exit-on-exit?
    (System/exit code)
    (throw (ex-info "Normally the system would have exited here." {:exit-code code}))))

; TODO: should probably really just use some kind of logging “framework”
; (defn warn
;   [& strs]
;   (binding [*out* *err*]
;     (apply println strs)))
