Feature: Retrieve Repositories

  Scenario: No topic specified, happy path
    Given no topic is specified
    And a valid org is specified
    And an initialized client is supplied
    When I attempt to retrieve matching Repositories
    Then the result should be all of the org’s repositories

  Scenario: No topic specified, server unreachable
    Given no topic is specified
    And a valid org is specified
    And an initialized client is supplied
    And that the GitHub API is unreachable
    When I attempt to retrieve matching Repositories
    Then an exception should be raised

  Scenario: No topic specified, rate limit hit
    Given no topic is specified
    And a valid org is specified
    And an initialized client is supplied
    And that the user has hit the GitHub API’s rate limits
    When I attempt to retrieve matching Repositories
    Then a TooManyRequests exception should be raised

  Scenario: Topic specified, happy path
    Given a valid topic is specified
    And a valid org is specified
    And an initialized client is supplied
    When I attempt to retrieve matching Repositories
    Then the result should be those of the org’s repositories with that topic

  Scenario: Topic specified, server unreachable
    Given a valid topic is specified
    And a valid org is specified
    And an initialized client is supplied
    And that the GitHub API is unreachable
    When I attempt to retrieve matching Repositories
    Then an exception should be raised
  
  Scenario: Topic specified, rate limit hit
    Given a valid topic is specified
    And a valid org is specified
    And an initialized client is supplied
    And that the user has hit the GitHub API’s rate limits
    When I attempt to retrieve matching Repositories
    Then a TooManyRequests exception should be raised

  Scenario: Topic specified, happy path, one hundred results found
    Given a valid topic is specified
    And a valid org is specified
    And an initialized client is supplied
    And the client returns exactly one hundred repositories
    When I attempt to retrieve matching Repositories
    Then the result should be those one hundred repositories
    And a warning message should be printed to stderr
