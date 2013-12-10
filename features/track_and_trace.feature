Feature: View Order Status

  Scenario: View status of an order that doesnt exist
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of an order with id 'NON_EXISTING' that does not exist
    Then I should see an error message that the order could not be found

  Scenario: View status of an order
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of a valid order with id 'FOUND_123'
    Then I should see the tracking status for the order 'FOUND_123'

  Scenario: Show system timeout when connection timeout
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of an order with id 'TIMEOUT_123' that timed out
    Then I should see an system error message on the form page