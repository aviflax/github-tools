(ns ght.list
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
  [{repo-name :name :as repo}]
  (boolean (tr/contents (owner-name repo) repo-name ".github/CODEOWNERS")))

(defn printable-name
  [repo org-name]
  (if (owned-by? repo org-name)
    (:name repo)
    (:full_name repo)))
