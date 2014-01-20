Feature: View Order Status
  @javascript
  Scenario: View status and details of an order
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of a valid order with id 'VF1FOUND123'
    Then I should see the tracking status for the order 'VF1FOUND123'

  @javascript
  Scenario: View status of an order that doesnt exist
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of an order with id 'VF1NON1EXISTING' that does not exist
    Then I should see a 'not found' error message

  @javascript
  Scenario: Show system timeout when connection timeout
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of an order with id 'VF1TIMEOUT123' that timed out
    Then I should see a 'timeout' error message
