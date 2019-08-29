(ns ghot.repos-test
  (:require [clojure.test :refer [deftest is]]
            [ghot.repos :as gr]))

(deftest owner-username
  (is (= "Optimus Prime" (gr/owner-username {:owner {:login "Optimus Prime"}})))
  (is (= "" (gr/owner-username {:owner {:login ""}})))
  (is (nil? (gr/owner-username {:owner {}})))
  (is (nil? (gr/owner-username {})))
  (is (nil? (gr/owner-username nil))))
