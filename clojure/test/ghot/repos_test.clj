(ns ghot.repos-test
  (:require [clojure.test :refer [deftest is]]
            [ghot.repos :as gr]))

(deftest owner-name
  (is (= "Optimus Prime" (gr/owner-name {:owner {:login "Optimus Prime"}}))))
