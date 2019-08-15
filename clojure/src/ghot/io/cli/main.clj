(ns ghot.io.cli.main
  "The main CLI command."
  (:gen-class)
  (:require [ghot.io.cli.list-repos :as lr]
            [ghot.io.cli :refer [exit]]))

(defn -main
  [& args]
  (if (= (take 2 args) ["list" "repos"])
    (apply lr/-main (drop 2 args))
    (exit 1 "USAGE: ghot list repos OPTIONS\n\nFor details run: `ghot list repos --help`")))
