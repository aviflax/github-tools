(ns ghr.io.repos
  (:require [clojure.string :refer [lower-case]]
            [tentacles.repos :as tr]
            [tentacles.search :as ts]))

(defn warn
  [& strs]
  (binding [*out* *err*]
    (apply println strs)))

(defn org-repos-for-topic
  "Returns a (possibly empty) sequential collection of maps that represent repositories, or throws."
  [org-name topic]
  (let [result (ts/search-repos nil {:user org-name
                                     :topic topic})]
    (when (:incomplete_results result)
      (warn "Results may be incomplete as the query exceeded the GitHub API’s internal timeout."))
    (when (> (:total_count result) 100)
      (warn "Results ARE INCOMPLETE as there are more than 100 results and this tool does not"
            "currently return more than the first 100."))
    (:items result)))

(defn owner-name
  [repo]
  (get-in repo [:owner :login]))

(defn owned-by?
  [repo org-name]
  (apply = (map lower-case [(owner-name repo) org-name])))

(defn org-watching
  "Returns a (possibly empty) sequential collection of maps that represent repositories owned by the
  org to which the user is subscribed (watching), or throws."
  [org-name user-name]
  (filter (fn [repo] (owned-by? repo org-name))
          ;; TODO: what about pagination?
          (tr/watching user-name)))

(defn has-codeowners?
  [repo]
  (boolean (tr/contents (owner-name repo) (:simple_name repo) ".github/CODEOWNERS")))
