Feature: Get config values from environment variables

  Scenario: A value requested as a string DOES exist in the environment
     Given the environment DOES contain the variable UNDERWEAR_TYPE with the value boxers
     When the config value underwear_type is requested, specified as a lower-case string
     Then the result should be boxers
  
  Scenario: A value requested as a string does NOT exist in the environment
    Given the environment does NOT contain the variable UNDERWEAR_TYPE
    When the config value underwear_type is requested, specified as a lower-case string
    Then the result should be nil
  
  Scenario: A value requested as a symbol DOES exist in the environment
    Given the environment DOES contain the variable UNDERWEAR_TYPE with the value boxers
    When the config value :underwear_type is requested, specified as a lower-case symbol
    Then the result should be boxers
  
  Scenario: A value requested as a symbol does NOT exist in the environment
    Given the environment does NOT contain the variable UNDERWEAR_TYPE
    When the config value :underwear_type is requested, specified as a lower-case symbol
    Then the result should be nil
