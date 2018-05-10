Feature: Validate that the environment contains the required variables with values

 Scenario: The required variables DO all exist and DO have valid values
   Given all the required environment variables exist
   And all the required environment variables have valid values
   When validate! is called
   Then the result should be nil

  Scenario: The required variables DO all exist but do NOT have valid values
    Given all the required environment variables exist
    When validate! is called
    Then Kernel#abort should be called with a relevant message

  Scenario: The required variables do NOT all exist
    Given the environment is missing ORG and TOKEN
    When validate! is called
    Then Kernel#abort should be called with a relevant message
