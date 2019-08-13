(ns ghot.io.cli.list-repos
  "The CLI command for listing things. (Initially just repos.)"
  (:gen-class)
  (:require [clojure.data.json :as json]
            [clojure.pprint :refer [pprint]]
            [clojure.string :refer [blank? join]]
            [clojure.tools.cli :refer [parse-opts]]
            [ghot.io.cli.util :refer [exit]]
            [ghot.io.repos :refer [has-codeowners? org-repos-watching org-repos-for-topic]]
            [ghot.repos :refer [printable-name]]
            [tentacles.repos :refer [org-repos]]))

(def cli-opts-spec
  [;; Scope and auth options. All are required.
   [nil "--org ORG-NAME" "The GitHub username of the org owning repos to be listed."]
   [nil "--token TOKEN" "A GitHub Personal Access Token for interacting with the GitHub API."]

   ;; Mode options. One and only one of these must be specified.
   [nil "--all" "List all repos owned by the org."]
   [nil "--private" "List only private repos owned by the org."]
   [nil "--public" "List only public repos owned by the org."]
   [nil "--watching" (str "List the repos that the user (who owns the token) is watching and are"
                          " owned by the org.")]
   [nil "--forks" "List only forks owned by the org."]
   ;; TODO [nil "--forks-of REPO-NAME"]
   [nil "--sources" "List only sources owned by the org."]
   [nil "--topic TOPIC" "List only repos owned by the org with the specified topic."
    :default nil]
   [nil "--no-codeowners" "List only repos owned by the org that do not have a CODEOWNERS file."]

   ;; Optional options.
   [nil "--format FORMAT" "Specifies the output format."
    :default "names-only"
    :parse-fn keyword
    :validate [#{:names-only :json-stream} "Supported values are 'names-only' and 'json-stream'."]]
   ["-h" "--help" "Prints the synopsis and a list of the most commonly used commands and exits. Other options are ignored."]
   [nil  "--debug" "For developers of ghot."]
   [nil "--verbose"]])

(def mode-opts
  [:private :public :forks :sources :all :topic :no-codeowners :watching])

(def mode-opts-printable
  (str "--" (join ", --" (sort (map name mode-opts)))))

(def mode-opts-msg
  (str "one and only one of the mode options (" mode-opts-printable ") must be specified."))

(defn- usage-message
  [summary & specific-messages]
  (str "Usage: ghot list repos OPTIONS\n\nOptions:\n"
       summary
       "\n\n"
       (if (seq specific-messages)
         (join " " specific-messages)
         (str "NB: " mode-opts-msg))
       "\n\n"
       "Full documentation is at https://github.com/FundingCircle/ght/"))

(defn- check-cli-opts
  [{:keys [summary errors]
    {:keys [help org token] :as opts} :options}]
  (cond
    help
    (exit 0 (usage-message summary))

    errors
    (exit 1 (usage-message summary "Errors:\n  " (join "\n  " errors)))

    (or (nil? org) (blank? org))
    (exit 1 (usage-message summary "Error: --org is required"))

    (or (nil? token) (blank? token))
    (exit 1 (usage-message summary "Error: --token is required"))

    (not= 1 (->> (select-keys opts mode-opts)
                 (vals)
                 (remove not)
                 (count)))
    (exit 1 (usage-message summary "Error:" mode-opts-msg))))

(defn- repos-fn
  "Returns a function with the same signature as tentacles.repos/org-repos: (fn [org & [options]])
   wherein `org` is a String containing the org’s GitHub username."
  [{:keys [no-codeowners topic watching] :as _cli-opts}]
  (cond
    watching      (fn [org & [options]] (org-repos-watching org :TODO options))
    topic         (fn [org & [options]] (org-repos-for-topic org topic options))
    no-codeowners (fn [org & [options]] (filter has-codeowners? (org-repos org options)))
    :default      org-repos))

(defn- api-opts
  [{:keys [token] :as cli-opts}]
  {:oauth-token token
   :type (or (ffirst (filter second
                      (select-keys cli-opts [:private :public :forks :sources])))
             :all)
   :all-pages true})

(defn- print-list
  "Hopefully the repos coll is lazy so this streams."
  [repos org format]
  (case format
    :names-only
    (run! #(println (printable-name % org)) repos)
    :json-stream
    (run! #(println (json/write-str %)) repos)))

(defn -main
  [& args]
  (let [{{:keys [org format debug] :as cli-opts} :options :as parsed} (parse-opts args cli-opts-spec :in-order true)
        _ (when debug
            (pprint parsed))
        _ (check-cli-opts parsed) ; exits or throws if there’s a problem
        get-repos (repos-fn cli-opts)]
    ;; TODO: try to ensure the result is lazy so the output will “stream”
    (print-list (get-repos org (api-opts cli-opts))
                org
                format)))
