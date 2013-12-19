Feature: View order details

  @javascript
  Scenario: See error message when wrong email format is entered
    Given I am on the email authentication page with order id 'vf123'
    When I enter email 'rubbish.com'
    Then I should see a 'Email is invalid.' error message

  @javascript
  Scenario: See error message when wrong date of birth is entered
    Given I am on the dob authentication page with order id 'vf123'
    When I enter dob 'wrong'
    Then I should see a 'Date of birth is invalid.' error message