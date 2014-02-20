Feature: View Order Status
	
  @javascript
  Scenario Outline: View appropriate status of orders in various valid statuses
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of a valid order with id '<order_id>'
    Then I should see the tracking status '<heading>' for the order
    And I should see the message '<message>'

    Examples:
      |  order_id          |  heading          | message            |
      |  VF123STAGED       |  In Progress      | in progress        |
      |  1-123PICKCONF     |  In Progress      | in progress        |
      |  SR1-123READY      |  In Progress      | in progress        |
      |  UP123BACKORDER    |  On Backorder     | on backorder       |
      |  1-123CANCELLED    |  Order Cancelled  | has been cancelled |
      |  SR1-123CLOSED     |  Order Shipped    | has been shipped   |
      |  VF123TERMINATED   |  Order Cancelled  | has been cancelled |
      |  1-123INPROGRESS   |  In Progress      | in progress        |

  @javascript
  Scenario: View correct details of the order that has multiple items, some of which are backordered
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of a valid order with id 'VF123BOMULTI'
    Then I should see the tracking status 'On Backorder' for the order
    And I should see the message 'on backorder'
	And I should see the right count and description for each item
	And I should see the estimated shipping date for the order
	
  @javascript
  Scenario: View individual status of items in a partially shipped order that has multiple items
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of a valid order with id 'VFMANYSTATUS'
    Then I should see the tracking status 'Transferring' for the order
	And I should see the right count, description and status for each item

  @javascript
  Scenario Outline: View correct status of orders that have items in different statuses
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of a valid order with id '<order_id>'
    Then I should see the tracking status '<heading>' for the order
    And I should see the message '<message>'

  Examples:
    | order_state_description               |  order_id          |  heading                 | message                    |
    | 1 shipped, 1 cancelled                |  1-MULTICANS       |  Shipped                 | has been shipped           |
    | 1 shipped with AP, 1 cancelled        |  1-MULTICANSAP     |  Transferring            | See below                  |
    | 1 shipped with AP, 1 cancelled, 1 BO  |  1-MULTICANBSAP    |  Transferring            | See below                  |
    | 1 shipped, 1 cancelled, 1 BO          |  1-MULTICANBS      |  Order Partially Shipped | has been partially shipped |
    | 1 cancelled, 1 BO                     |  SR1-CANBO         |  On Backorder            | on backorder               |
    | 1 shipped with AP, 1 BO               |  SR1-BSAP          |  Transferring            | See below                  |
    | 1 shipped, 1 BO                       |  SR1-BS            |  Order Partially Shipped | has been partially shipped |

  @javascript
  Scenario Outline: View appropriate error messages of orders in various errors states
    Given I am on the Track and Trace Home page '/tnt'
	When I search for the status of an order with id '<order_id>' that '<order_state_description>'
	Then I should see a '<error_message_description>' error message

    Examples:
      |  order_state_description   |  order_id          |  error_message_description      |
      |  doesnt exist              |  VF1NON1EXISTING   |  order ID was not found         |
      |  timed out from fusion     |  VF1TIMEOUT123     |  Service Unavailable            |
      |  has an unexpected status  |  1-1BADSTATUS      |  problem retrieving your order  |

  # This scanario tests the mobile megamenu. This test needs to be the last test in the suite, as
  # inspite of resetting http request headers after the test, subsequent requents are still identified as
  # being from a mobile device.
  @javascript @mobile
  Scenario: View mobile-specific header and footer when visiting the page via a mobile device
    Given I use a mobile device to visit the Track and Trace Home page '/tnt'
	Then I should see the mobile version of header and footer
