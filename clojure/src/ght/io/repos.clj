(ns ght.io.repos
  (:require [ght.repos :refer [owned-by? owner-name]]
            [tentacles.repos :as tr]))

(defn has-codeowners?
  [{repo-name :name :as repo}]
  (boolean (tr/contents (owner-name repo) repo-name ".github/CODEOWNERS" {:str? true})))
