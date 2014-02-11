Feature: View Tracking Info

  @wip @javascript
  Scenario: Show generic message when tracking info has error
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of a valid order with id 'VF123STAGED' that has tracking info error
    #Then I should only see the generic 'Order Shipped' tracking information message 'Your order has been shipped.'
    Then I should see the tracking status 'In Progress' for the order
