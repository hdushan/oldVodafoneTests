Feature: View Order Status
	
  @javascript
  Scenario Outline: View appropriate status of orders in various valid statuses
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of a valid order with id '<order_id>'
    Then I should see the tracking status '<heading>' for the order
    And I should see the message '<message>'

    Examples:
      |  status_mix                                        |  order_id          |  heading          | message            |
	  |  BOOKED, BOOKED, NULL                              |  SR1-BOOKEDNULL    |  In Progress      | in progress        |
      |  BOOKED, AWAITING_SHIPPING, READY TO RELEASE       |  1-READYRELEASE    |  In Progress      | in progress        |
      |  BOOKED, AWAITING_SHIPPING, RELEASED TO WAREHOUSE  |  1-RELEASEWARE     |  In Progress      | in progress        |
      |  BOOKED, AWAITING_SHIPPING, STAGED/PICK CONFIRMED  |  VF123STAGEPICK    |  In Progress      | in progress        |
      |  BOOKED, AWAITING_SHIPPING, BACKORDERED            |  UP123BACKORDER    |  On Backorder     | on backorder       |
	  |  BOOKED, AWAITING_SHIPPING, SHIPPED                |  UPBOOKAWSHIPPED   |  Order Shipped    | has been shipped   |
	  |  BOOKED, SHIPPED, SHIPPED                          |  UPBOOKSHIP        |  Order Shipped    | has been shipped   |
	  |  BOOKED, CLOSED, SHIPPED                           |  UPBOOKCLOSE       |  Order Shipped    | has been shipped   |
	  |  CLOSED, CLOSED, SHIPPED                           |  1-CLOSESHIP       |  Order Shipped    | has been shipped   |
	  |  CLOSED, CANCELLED, CANCELLED                      |  1-CLOSECANCEL     |  Order Cancelled  | has been cancelled |
	  |  BOOKED, CANCELLED, CANCELLED                      |  1-BOOKCANCEL      |  Order Cancelled  | has been cancelled |
      |  CANCELLED, CANCELLED, CANCELLED                   |  1-123CANCELLED    |  Order Cancelled  | has been cancelled |
	  |  BOOKED, CANCELLED, NULL                           |  1-BOOKCANCELNUL   |  Order Cancelled  | has been cancelled |
	  |  CANCELLED, CANCELLED, NULL                        |  1-CANCELCANCEL    |  Order Cancelled  | has been cancelled |
      |  TERMINATED                                        |  VF123TERMINATED   |  Order Cancelled  | has been cancelled |
      |  IN PROGRESS                                       |  1-123INPROGRESS   |  In Progress      | in progress        |

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
  Scenario Outline: View correct status of orders that have multiple order line item details in different statuses
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of a valid order with id '<order_id>'
    Then I should see tracking statuses '<status1>' and '<status2> for the order

  Examples:
    | order_state_description               |  order_id          |  status1                 | status2                |
    | Each with a single shipping line      |  1-MULTIORDER      |  On Backorder            | Order Cancelled        |
    | 1 with multiple shipping lines        |  1-MULTIORDERSH    |  On Backorder            | Order Cancelled        |

  @javascript
  Scenario Outline: View correct quantities of orders that have multiple order line item details with the same description
    Given I am on the Track and Trace Home page '/tnt'
    When I search for the status of a valid order with id '<order_id>'
    Then I should see an item with '<num>' and '<item_status>' for the order
    And I should see an item with '<num2>' and '<item_status2>' for the order
    And I should see an item with '<num3>' and '<item_status3>' for the order

  Examples:
    | order_state_description                           | order_id    | num | item_status | num2 | item_status2 | num3 | item_status3  |
    | 6 and 2 in progress, one order                    | 1-MULTIAGG1 | 8 x |             | na   | na           | na   | na            |
    | as above plus 1 and 3 cancelled                   | 1-MULTIAGG2 | 8 x | In Progress | 4 x  | Cancelled    | na   | na            |
    | as above plus 1 and 2 in progress, separate order | 1-MULTIAGG3 | 8 x | In Progress | 4 x  | Cancelled    | 3 x  |               |

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
  # in spite of resetting http request headers after the test, subsequent requests are still identified as
  # being from a mobile device.
  @javascript @mobile
  Scenario: View mobile-specific header and footer when visiting the page via a mobile device
    Given I use a mobile device to visit the Track and Trace Home page '/tnt'
	Then I should see the mobile version of header and footer
