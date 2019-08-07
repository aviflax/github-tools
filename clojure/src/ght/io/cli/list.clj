(ns ght.io.cli.list
  "The CLI command for listing things. (Initially just repos.)"
  (:gen-class)
  (:require [clojure.tools.cli :refer [parse-opts]]))

(def opts-spec
  [[nil "--all"]
   [nil "--private" "List only private repos. Cannot be used with --public."]
   [nil "--public" "List only public repos. Cannot be used with --private."]
   [nil "--subscribed"]
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

(defn exit
  [code & msgs]
  (when (seq msgs)
    (apply println msgs))
  (System/exit code))

(defn check-opts
  [opts]
  (cond
    (and (:private opts) (:public opts))
    (exit 1 "--private and --public cannot be used together.")
    )
)

(defn -main
  [& args]
  (let [{opts :options :as parsed-args} (parse-opts args opts-spec)]
    (check-opts opts) ; exits or throws if there’s a problem
    
