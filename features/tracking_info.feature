Feature: View Tracking Info

  @javascript
  Scenario: Show events when tracking info has them
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of a valid order with id 'UPAPFOUND' that has tracking events
    Then I should see the tracking status 'Delivered' for the order
    And I should see the message 'See below for further information about your order's travels'
    And I should see the shipping events from AusPost

  @javascript
  Scenario: Show generic message when tracking info has error
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of a valid order with id 'UPAPTIME' that has tracking info error
    Then I should see the tracking status 'Order Shipped' for the order
    And I should see the message 'Your order has been shipped'
    And I should not see any shipping details

  @javascript
  Scenario: Show Vodafone status when tracking info has no status
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of a valid order with id 'UPAPINTER' that has no AusPost status
    Then I should see the tracking status 'Order Shipped' for the order
    And I should see the message 'Your order has been shipped'
    And I should not see any shipping details
