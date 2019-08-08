(ns ght.io.cli.list
  "The CLI command for listing things. (Initially just repos.)"
  (:gen-class)
  (:require [clojure.data.json :as json]
            [clojure.string :refer [join]]
            [clojure.tools.cli :refer [parse-opts]]
            [ght.io.repos :refer [has-codeowners? org-repos-watching org-repos-for-topic]]
            [ght.repos :refer [printable-name]]
            [tentacles.repos :refer [org-repos]]))

(def cli-opts-spec
  [[nil "--org ORG-NAME" "The GitHub username of the org owning repos to be listed."]
   [nil "--all" "List all repos owned by the org."]
   [nil "--private" "List only private repos owned by the org."]
   [nil "--public" "List only public repos owned by the org."]
   [nil "--watching" "List the repos that the user is watching and are owned by the org."]
   [nil "--forks" "List only forks owned by the org."]
   ;; TODO [nil "--forks-of REPO-NAME"]
   [nil "--sources" "List only sources owned by the org."]
   [nil "--topic TOPIC" "List only repos owned by the org with the specified topic."
    :default nil]
   [nil "--no-codeowners" "List only repos owned by the org that do not have a CODEOWNERS file."]
   [nil "--format FORMAT" "Specifies the output format."
    :default :names-only
    :parse-fn keyword
    :validate [#{:names-only :json-stream} "Supported values are 'names-only' and 'json-stream'."]]
   ["-h" "--help" "Prints the synopsis and a list of the most commonly used commands and exits. Other options are ignored."]
   ["-v" "--verbose"]])

(def mutually-exclusive-opts [:private :public :forks :sources
                              :all :topic :no-codeowners :watching])

(def meo-printable (str "--" (join ", --" (sort (map name mutually-exclusive-opts)))))

(defn- usage-message [summary & specific-messages]
  (str "Usage: ght list repos OPTIONS\n\nOptions:\n"
       summary
       "\n\n"
       (if specific-messages
         (join " " specific-messages)
         (str "NB: the options " meo-printable " are mutually exclusive."))
       "\n\n"
       "Full documentation is at https://github.com/FundingCircle/ght/"))

(def exit-on-exit? "Set to false for testing." (atom true))

(defn exit
  [code & msgs]
  (when (seq msgs)
    (apply println msgs))
  (if @exit-on-exit?
    (System/exit code)
    (throw (ex-info "Normally the system would have exited here." {:exit-code code}))))

(defn- check-cli-opts
  [{:keys [summary errors]
    {:keys [help]} :options :as opts}]
  (cond
    help
    (exit 0 (usage-message summary))

    errors
    (exit 1 (usage-message summary "Errors:\n  " (join "\n  " errors)))

    (> 1 (->> (select-keys opts mutually-exclusive-opts)
              (vals)
              (remove not)
              (count)))
    (exit 1 (usage-message summary "Error: the options" meo-printable "are mutually exclusive."))))

; (defn warn
;   [& strs]
;   (binding [*out* *err*]
;     (apply println strs)))

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
  [cli-opts]
  {:type (or (ffirst (filter second
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
  (let [{{:keys [org format] :as cli-opts} :options :as parsed} (parse-opts args cli-opts-spec)
        _ (check-cli-opts parsed) ; exits or throws if there’s a problem
        get-repos (repos-fn cli-opts)]
    ;; TODO: try to ensure the result is lazy so the output will “stream”
    (print-list (get-repos org (api-opts cli-opts))
                org
                format)))
