Feature: View Order Status
	
  @javascript
  Scenario Outline: View appropriate status of orders in various valid statuses
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of a valid order with id '<order_id>'
    Then I should see the tracking status '<heading>' for the order
    And I should see the message '<message>'

    Examples:
      |  order_id          |  heading          | message   |
      |  VF123FOUND        |  Order Shipped    | shipped |
#      |  VF123STAGED       |  In Progress      |
#      |  1-123PICKCONF     |  In Progress      |
#      |  SR1-123READY      |  In Progress      |
#      |  UP123BACKORDER    |  On Backorder     |
#      |  1-123CANCELLED    |  Order Cancelled  |
#      |  SR1-123CLOSED     |  Order Shipped    |
#      |  VF123TERMINATED   |  Order Cancelled  |
#      |  1-123INPROGRESS   |  In Progress      |

  @javascript
  Scenario Outline: View appropriate error messages of orders in various errors states
    Given I am on the Track and Trace Home page '/tnt'
	When I search for the status of an order with id '<order_id>' that '<order_state_description>'
	Then I should see a '<error_message_description>' error message

    Examples:
      |  order_state_description |  order_id          |  error_message_description   |
      |  doesnt exist            |  VF1NON1EXISTING   |  order ID was not found      |
      |  timed out from fusion   |  VF1TIMEOUT123     |  Service Unavailable         |
      #|  had unexpected status   |  1-BADSTATUS123    |  Blah Blah                   |

  # This scanario tests the mobile megamenu. This test needs to be the last test in the suite, as
  # inspite of resetting http request headers after the test, subsequent requents are still identified as
  # being from a mobile device.
  @javascript @mobile
  Scenario: View mobile-specific header and footer when visiting the page via a mobile device
    Given I use a mobile device to visit the Track and Trace Home page '/tnt'
	Then I should see the mobile version of header and footer
