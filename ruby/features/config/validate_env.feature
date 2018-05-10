Feature: Validate that the environment contains the required variables with values

  Background:
    Given the environment does not contain GITHUB_ORG nor GITHUB_TOKEN

  Scenario: The required variables do NOT all exist
    When validate! is called then #abort should be called with a relevant message

  Scenario: The required variables DO all exist and DO have valid values
    Given all the required environment variables exist with VALID values
    When validate! is called
    Then the result should be nil

  Scenario: The required variables DO all exist but do NOT have valid values
    Given all the required environment variables exist with INvalid values
    When validate! is called then #abort should be called with a relevant message
