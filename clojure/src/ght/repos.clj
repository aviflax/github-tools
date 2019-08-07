(ns ght.repos
  (:require [clojure.string :refer [lower-case]]))

(defn owner-name
  [repo]
  (get-in repo [:owner :login]))

(defn owned-by?
  "username can be an org name."
  [repo username]
  (apply = (map lower-case [(owner-name repo) username])))

(defn printable-name
  [repo org-name]
  (if (owned-by? repo org-name)
    (:name repo)
    (:full_name repo)))
