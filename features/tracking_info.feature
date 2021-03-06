Feature: View Tracking Info

  @javascript
  Scenario: Show events when tracking info has them
    Given I am on the Track and Trace Home page '/tracking'
    When I search for the status of a valid order with id 'UPAPFOUND' that has tracking events
    Then I should see the AusPost status 'Delivered' for the order
    And I should see the AusPost tracking number 'AP123FOUND'
    And I should see a link to 'http://auspost.com.au/track/track.html?id=AP123FOUND' with text 'AusPost'
    And I should see the shipping events from AusPost

  @javascript
  Scenario: Show generic message when tracking info has business exception
    Given I am on the Track and Trace Home page '/tracking'
    When I search for the status of a valid order with id 'UPAPERROR'
    Then I should see the AusPost status 'on the truck' for the order
    And I should see the AusPost status message 'Your order should arrive within 5 days'

  @javascript
  Scenario: Show generic message when tracking info has error
    Given I am on the Track and Trace Home page '/tracking'
    When I search for the status of a valid order with id 'UPAPTIME'
    Then I should see the AusPost status 'on the truck' for the order
    And I should see the AusPost status message 'currently working with AusPost'
    And I should not see any shipping events

  @javascript
  Scenario: Show generic message when tracking info has unexpected structure
    Given I am on the Track and Trace Home page '/tracking'
    When I search for the status of a valid order with id 'UPAPWTF'
    Then I should see the AusPost status 'on the truck' for the order
    And I should see the AusPost status message 'currently working with AusPost'
    And I should not see any shipping events

  @javascript
  Scenario: Show generic message when tracking info has unexpected structure
    Given I am on the Track and Trace Home page '/tracking'
    When I search for the status of a valid order with id 'UPAPMULTI'
    Then I should see multiple AusPost statuses
    And I should see the message 'shipped in multiple packages'
    And I should see exactly 10 shipping events from AusPost

  @javascript
  Scenario: Show generic AusPost status when tracking info has no status
    Given I am on the Track and Trace Home page '/tracking'
    When I search for the status of a valid order with id 'UPAPINTER' that has no AusPost status
    Then I should see the tracking status 'Order shipped.' for the order
    And I should see the AusPost status 'on the truck' for the order
    And I should not see any shipping events
