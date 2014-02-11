Feature: View Tracking Info

  @javascript
  Scenario: Show generic message when tracking info has error
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of a valid order with id 'VF123TRACKERR' that has tracking info error
    Then I should see the tracking status 'Order Shipped' for the order
    And I should see the message 'Your order has been shipped'
    And I should not see any shipping details
