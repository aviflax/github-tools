(ns ght.io.cli.list
  "The CLI command for listing things. (Initially just repos.)"
  (:gen-class)
  (:require [clojure.string :refer [join]]
            [clojure.tools.cli :refer [parse-opts]]
            [ght.io.list :refer [org-repos-watching org-repos-for-topic]]
            [ght.io.repos :refer [has-codeowners?]]
            [tentacles.repos :refer [org-repos]]))

(def cli-opts-spec
  [[nil "--org ORG-NAME" "The GitHub username of the org owning repos to be listed."]
   [nil "--all"]
   [nil "--private" "List only private repos. Cannot be used with --public."]
   [nil "--public" "List only public repos. Cannot be used with --private."]
   [nil "--watching" "List the repos of the specified org which the user is watching."]
   [nil "--forks" "List only forks. Cannot be used with --sources."]
   ;; TODO [nil "--forks-of REPO-NAME"]
   [nil "--sources" "List only sources. Cannot be used with --forks."]
   [nil "--topic TOPIC" "List only repos with the specified topic."]
   [nil "--no-codeowners" "List only repos that do not have a CODEOWNERS file."]
   [nil "--format FORMAT" "Specifies the output format."
    :default :names-only
    :parse-fn keyword
    :validate [#{:names-only :json-stream} "Supported values are 'names-only' and 'json-stream'."]]
   ["-h" "--help" "Prints the synopsis and a list of the most commonly used commands and exits. Other options are ignored."]
   ["-v" "--verbose"]])

(defn- usage-message [summary & specific-messages]
  (str "Usage: ght list repos OPTIONS\n\nOptions:\n"
       summary
       (when specific-messages
         (str "\n\n"
              (join " " specific-messages)))
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
    {:keys [help private public forks sources]} :options}]
  (cond
    help
    (exit 0 (usage-message summary))

    errors
    (exit 1 (usage-message summary "Errors:\n  " (join "\n  " errors)))

    (and private public)
    (exit 1 (usage-message summary "Error: --private and --public cannot be used together."))

    (and forks sources)
    (exit 1 (usage-message summary "Error: --forks and --sources cannot be used together."))))

; (defn warn
;   [& strs]
;   (binding [*out* *err*]
;     (apply println strs)))

(defn- repos-fn
  "Returns a function with the same signature as tentacles.repos/org-repos: (fn [org & [options]])
   wherein `org` is a String containing the org’s GitHub username."
  [{:keys [no-codeowners topic watching] :as _cli-opts}]
  (cond
    ;; TODO: this approach seems to mean that we can’t filter watching repos by a topic
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

(defn -main
  [& args]
  (let [{:keys [org options] :as parsed} (parse-opts args cli-opts-spec)]
    (check-cli-opts (select-keys parsed [:summary :errors :options])) ; exits or throws if there’s a problem
    ((repos-fn options) org (api-opts options))))
