Feature: Landing page

  Scenario: Submit track order form with non-existant order
    Given I navigate to '/tnt'
    When I view status of an order 'NON_EXISTING' that does not exist
    Then I should see the error message

  Scenario: Submit track order form with an order id that exists
    Given I navigate to '/tnt'
    When I view status of an order 'FOUND_123' that exists
    Then I should see the tracking status for the order 'FOUND_123'