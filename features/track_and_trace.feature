Feature: Landing page

  Scenario: View landing page
    When I navigate to '/tnt'
    Then I can see the Track and Trace landing page

  Scenario: Submit track order form with wrong input
    Given I navigate to '/tnt'
    When I submit track form with wrong tracking id
    Then I should see the error message

  Scenario: Submit track order form with correct input
    Given I navigate to '/tnt'
    When I submit track form with correct tracking id
    Then I should see the tracking status