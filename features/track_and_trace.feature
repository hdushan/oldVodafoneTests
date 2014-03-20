Feature: View Order Status

  @javascript
  Scenario Outline: View appropriate status of orders in various valid statuses
    Given I am on the Track and Trace Home page '/tracking'
    When I search for the status of a valid order with id '<order_id>'
    Then I should see the tracking status '<heading>' for the order
    And I should see the message '<message>'

    Examples:
      |  status_mix                                        |  order_id          |  heading          | message                                 |
	  |  BOOKED, BOOKED, NULL                              |  SR1-BOOKEDNULL    |  We’re working on your order.   | Check back soon for an update           |
      |  BOOKED, AWAITING_SHIPPING, READY TO RELEASE       |  1-READYRELEASE    |  We’re working on your order.   | Check back soon for an update           |
      |  BOOKED, AWAITING_SHIPPING, RELEASED TO WAREHOUSE  |  1-RELEASEWARE     |  We’re working on your order.   | Check back soon for an update           |
      |  BOOKED, AWAITING_SHIPPING, STAGED/PICK CONFIRMED  |  VF123STAGEPICK    |  We’re working on your order.   | Check back soon for an update           |
      |  BOOKED, AWAITING_SHIPPING, BACKORDERED            |  UP123BACKORDER    |  On backorder.    | currently waiting for more stock        |
	  |  BOOKED, AWAITING_SHIPPING, SHIPPED                |  UPBOOKAWSHIPPED   |  Order shipped.   |                                         |
	  |  BOOKED, SHIPPED, SHIPPED                          |  UPBOOKSHIP        |  Order shipped.   |                                         |
	  |  BOOKED, CLOSED, SHIPPED                           |  UPBOOKCLOSE       |  Order shipped.   |                                         |
	  |  CLOSED, CLOSED, SHIPPED                           |  1-CLOSESHIP       |  Order shipped.   |                                         |
	  |  CLOSED, CANCELLED, CANCELLED                      |  1-CLOSECANCEL     |  Order cancelled. | You haven’t been charged for this order |
	  |  BOOKED, CANCELLED, CANCELLED                      |  1-BOOKCANCEL      |  Order cancelled. | You haven’t been charged for this order |
      |  CANCELLED, CANCELLED, CANCELLED                   |  1-123CANCELLED    |  Order cancelled. | You haven’t been charged for this order |
	  |  BOOKED, CANCELLED, NULL                           |  1-BOOKCANCELNUL   |  Order cancelled. | You haven’t been charged for this order |
	  |  CANCELLED, CANCELLED, NULL                        |  1-CANCELCANCEL    |  Order cancelled. | You haven’t been charged for this order |
      |  TERMINATED                                        |  VF123TERMINATED   |  Order cancelled. | You haven’t been charged for this order |
      |  IN PROGRESS                                       |  1-123INPROGRESS   |  We’re working on your order.   | Check back soon for an update           |

  @javascript
  Scenario: View correct details of the order that has multiple items, some of which are backordered
    Given I am on the Track and Trace Home page '/tracking'
    When I search for the status of a valid order with id 'VF123BOMULTI'
    Then I should see the tracking status 'On backorder.' for the order
    And I should see the message 'currently waiting'
	And I should see the right count and description for each item
	And I should see the estimated shipping date for the order

  @javascript
  Scenario: View individual status of items in a partially shipped order that has multiple items
    Given I am on the Track and Trace Home page '/tracking'
    When I search for the status of a valid order with id 'VFMANYSTATUS'
    Then I should see the tracking status 'Partially shipped.' for the order
    Then I should see the AusPost status 'Transferring' for the order
	And I should see the right count, description and status for each item

  @javascript
  Scenario Outline: View correct status of orders that have items in different statuses
    Given I am on the Track and Trace Home page '/tracking'
    When I search for the status of a valid order with id '<order_id>'
    Then I should see the tracking status '<heading>' for the order
    And I should see the message '<message>'

  Examples:
    | order_state_description               |  order_id          |  heading            | message                             |
    | 1 shipped, 1 cancelled                |  1-MULTICANS       |  Order shipped.     |                                     |
    | 1 shipped with AP, 1 cancelled        |  1-MULTICANSAP     |  Order shipped.     |                                     |
    | 1 shipped with AP, 1 cancelled, 1 BO  |  1-MULTICANBSAP    |  Partially shipped. | Part of your order is on its way.   |
    | 1 shipped, 1 cancelled, 1 BO          |  1-MULTICANBS      |  Partially shipped  | Part of your order is on its way.   |
    | 1 cancelled, 1 BO                     |  SR1-CANBO         |  On backorder.      | currently waiting for more stock    |
    | 1 shipped with AP, 1 BO               |  SR1-BSAP          |  Partially shipped. | Part of your order is on its way.   |
    | 1 shipped, 1 BO                       |  SR1-BS            |  Partially shipped. | Part of your order is on its way.   |

  @javascript
  Scenario Outline: View correct status of orders that have multiple order line item details in different statuses
    Given I am on the Track and Trace Home page '/tracking'
    When I search for the status of a valid order with id '<order_id>'
    Then I should see tracking statuses '<status1>' and '<status2> for the order

  Examples:
    | order_state_description               |  order_id          |  status1                 | status2                 |
    | Each with a single shipping line      |  1-MULTIORDER      |  On backorder.           | Order cancelled.        |
    | 1 with multiple shipping lines        |  1-MULTIORDERSH    |  On backorder.           | Order cancelled.        |

  @javascript
  Scenario Outline: View correct quantities of orders that have multiple order line item details with the same description
    Given I am on the Track and Trace Home page '/tracking'
    When I search for the status of a valid order with id '<order_id>'
    Then I should see an item with '<num>' and '<item_status>' for the order
    And I should see an item with '<num2>' and '<item_status2>' for the order
    And I should see an item with '<num3>' and '<item_status3>' for the order

  Examples:
    | order_state_description                           | order_id    | num | item_status    | num2 | item_status2  | num3 | item_status3  |
    | 6 and 2 in progress, one order                    | 1-MULTIAGG1 | 8 x |                | na   | na            | na   | na            |
    | as above plus 1 and 3 cancelled                   | 1-MULTIAGG2 | 8 x | Pending.       | 4 x  | Cancelled.    | na   | na            |
    | as above plus 1 and 2 in progress, separate order | 1-MULTIAGG3 | 8 x | Pending.       | 4 x  | Cancelled.    | 3 x  |               |

  @javascript
  Scenario Outline: View appropriate error messages of orders in various errors states
    Given I am on the Track and Trace Home page '/tracking'
	When I search for the status of an order with id '<order_id>' that '<order_state_description>'
	Then I should see a '<error_message_description>' error message

    Examples:
      |  order_state_description                 |  order_id          |  error_message_description                |
      |  doesnt exist                            |  VF1NON1EXISTING   |  entered your tracking number exactly     |
      |  timed out from fusion                   |  VF1TIMEOUT123     |  Sorry, we’ve just had a technical mishap. Please try again in a few minutes.                  |
      |  has an unexpected status                |  1-1BADSTATUS      |  Sorry, we’ve just had a technical mishap. Please try again in a few minutes.                  |
      |  fusion thinks is invalid                |  VF123VALFAULT     |  entered your tracking number exactly     |
      |  causes a generic system fault in fusion |  VF123SYSFAULT     |  Sorry, we’ve just had a technical mishap. Please try again in a few minutes.                  |

  # This scanario tests the mobile megamenu. This test needs to be the last test in the suite, as
  # in spite of resetting http request headers after the test, subsequent requests are still identified as
  # being from a mobile device.
  @javascript @mobile
  Scenario: View mobile-specific header and footer when visiting the page via a mobile device
    Given I use a mobile device to visit the Track and Trace Home page '/tracking'
	Then I should see the mobile version of header and footer
