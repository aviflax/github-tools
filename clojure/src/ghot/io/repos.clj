(ns ghot.io.repos
  "Functions that supplement those in tentacles.repos."
  (:require [ghot.repos :refer [owned-by? owner-name]]
            ; [tentacles.core :refer [api-call]]
            [tentacles.repos :as tr]
            [tentacles.search :as ts]))

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
          (tr/watching user-name (assoc options :all-pages true))))

(defn has-codeowners?
  [{repo-name :name :as repo}]
  (boolean (tr/contents (owner-name repo) repo-name ".github/CODEOWNERS" {:str? true})))

;; WIP WIP WIP
; (defn- first-commit
;   [{repo-full-name :full_name :as _repo}]
;   ;; tentacles does not currently have DSL-level support for commit search. This is probably because
;   ;; the feature (of GitHub’s v3 API) is in beta (CONFIRM AND ADD LINK).
;   ;; TODO: the below is incorrect. Correct it!
;   (let [query (format "repo:%s merge:false" repo-full-name)]
;     (api-call :get "search" [] query {:sort :author-date
;                                       :order :asc
;                                       :per_page 1})))
