(ns ghot.io.repos
  "Functions that supplement those in tentacles.repos."
  (:require [ghot.repos :refer [owned-by? owner-name]]
            [ghot.io.util :refer [verbose]]
            ; [tentacles.core :refer [api-call]]
            [tentacles.repos :as tr]
            [tentacles.users :as tu]
            [tentacles.search :as ts]))

(defn org-repos-for-topic
  "Returns a (possibly empty) sequential collection of maps that represent repositories, or throws."
  [org-name topic options]
  (:items (ts/search-repos nil {:user org-name :topic topic} options)))

(defn org-repos-watching
  "Returns a (possibly empty) sequential collection of maps that represent repositories owned by the
  org to which the user is subscribed (watching), or throws."
  [org-name options]
  (let [me (tu/me options)
        _ (verbose "Retrieved user:" me)
        response (tr/watching (:login me) options)
        _ (if (sequential? response)
              (verbose "Retrieved" (count response) "repos; first:" (first response))
              (verbose "Error occured retrieving repos:" response))]
    (filter #(owned-by? % org-name) response)))

(defn has-codeowners?
  ;; TODO doesn’t this need authentication?
  [{repo-name :name :as repo}]
  (boolean (tr/contents (owner-name repo) repo-name ".github/CODEOWNERS" {:str? true})))

;; WIP WIP WIP
; (defn- first-commit
;   [{repo-full-name :full_name :as _repo}]
;   ;; tentacles does not currently have DSL-level support for commit search. This is probably because
;   ;; the feature (of GitHub’s v3 API) is in beta (CONFIRM AND ADD LINK).
;   ;; TODO: the below is incorrect. Correct it!
;   ;; See https://developer.github.com/v3/search/#search-commits
;   (let [query (format "repo:%s merge:false" repo-full-name)]
;     (api-call :get "search/commits" [] query {:sort :author-date
;                                               :order :asc
;                                               :Accept "application/vnd.github.cloak-preview"
;                                               :per_page 1})))
