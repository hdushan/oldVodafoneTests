Feature: View Order Status

  @javascript
  Scenario: View status and details of an order
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of a valid order with id 'VF123FOUND'
    Then I should see the tracking status for the order 'VF123FOUND'

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
	
  # This feature tests the mobile megamenu. This test needs to be the last test in the suite, as
  # inspite of resetting http request headers after the test, subsequent requents are still identified as
  # being from a mobile device.
  @javascript @mobile
  Scenario: View mobile-specific header and footer when visiting the page via a mobile device
    Given I use a mobile device to visit the Track and Trace Home page '/tnt'
	Then I should see the mobile version of header and footer
