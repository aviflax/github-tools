(ns ght.io.repos
  (:require [ght.repos :refer [owned-by? owner-name]]
            [tentacles.core :refer [api-call]]
            [tentacles.repos :as tr]))

(defn has-codeowners?
  [{repo-name :name :as repo}]
  (boolean (tr/contents (owner-name repo) repo-name ".github/CODEOWNERS" {:str? true})))

;; WIP WIP WIP
(defn- first-commit
  [{repo-full-name :full_name :as _repo}]
  ;; tentacles does not currently have DSL-level support for commit search. This is probably because
  ;; the feature (of GitHub’s v3 API) is in beta (CONFIRM AND ADD LINK).
  ;; TODO: the below is incorrect. Correct it!
  (let [query (format "repo:%s merge:false" repo-full-name)]
    (api-call :get "search" [] query {:sort :author-date
                                      :order :asc
                                      :per_page 1})))
