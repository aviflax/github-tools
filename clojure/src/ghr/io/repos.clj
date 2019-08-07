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
  (:items (ts/search-repos nil {:user org-name :topic topic}
                               {:all-pages true})))

(defn owner-name
  [repo]
  (get-in repo [:owner :login]))

(defn owned-by?
  "username can be an org name."
  [repo username]
  (apply = (map lower-case [(owner-name repo) username])))

(defn org-watching
  "Returns a (possibly empty) sequential collection of maps that represent repositories owned by the
  org to which the user is subscribed (watching), or throws."
  [org-name user-name]
  (filter (fn [repo] (owned-by? repo org-name))
          (tr/watching user-name {:all-pages true})))

(defn has-codeowners?
  [repo]
  (boolean (tr/contents (owner-name repo) (:simple_name repo) ".github/CODEOWNERS")))
