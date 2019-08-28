(ns ghot.io.cli.main-test
  (:require [clojure.test :refer [deftest is testing]]
            [ghot.io.cli :refer [exit-on-exit?]]
            [ghot.io.cli.main :as main])
  (:import [clojure.lang ExceptionInfo]))

(reset! exit-on-exit? false)

(deftest -main
  (testing "sad paths"
    (is (thrown? ExceptionInfo (main/-main)))
    (is (thrown? ExceptionInfo (main/-main "foo")))
    (is (thrown? ExceptionInfo (main/-main "list")))
    (is (thrown? ExceptionInfo (main/-main "listrepos")))
    (is (thrown? ExceptionInfo (main/-main "list-repos")))
    (is (thrown? ExceptionInfo (main/-main "list users")))))
