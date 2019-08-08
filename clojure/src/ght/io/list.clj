(ns ght.io.list
  (:require [ght.repos :refer [owned-by? owner-name]]
            [tentacles.repos :as tr]
            [tentacles.search :as ts]))

; (defn warn
;   [& strs]
;   (binding [*out* *err*]
;     (apply println strs)))

(defn org-repos-for-topic
  "Returns a (possibly empty) sequential collection of maps that represent repositories, or throws."
  [org-name topic & options]
  (:items (ts/search-repos nil {:user org-name :topic topic}
                               (assoc options :all-pages true))))

(defn org-repos-watching
  "Returns a (possibly empty) sequential collection of maps that represent repositories owned by the
  org to which the user is subscribed (watching), or throws."
  [org-name user-name & options]
  (filter (fn [repo] (owned-by? repo org-name))
          (tr/watching user-name {:all-pages true} options)))
