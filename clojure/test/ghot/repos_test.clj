(ns ghot.repos-test
  (:require [clojure.test :refer [deftest is]]
            [ghot.repos :as gr]))

(deftest owner-username
  (is (= "Optimus Prime" (gr/owner-username {:owner {:login "Optimus Prime"}}))))
