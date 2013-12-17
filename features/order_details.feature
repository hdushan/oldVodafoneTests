Feature: View order details

  @javascript
  Scenario: See error message when wrong email format is entered
    Given I am on the email authentication page with order id 'vf123'
    When I enter email 'rubbish.com'
    Then I should see a 'Wrong Email format' error message

