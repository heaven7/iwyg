Feature: User accounts
  In Order to set user accounts
  I want to create, edit and delete user accounts

  Scenario Outline: Creating a new account
 #   Given I am not authenticated
    Given I am on register 
    And I fill in "user_login" with "<login>"
    And I fill in "user_email" with "<email>"
    And I fill in "user_password" with "<password>"
    And I fill in "user_password_confirmation" with "<password>"
    And I press "Anmelden"
    Then I should see "Bitte bestätige deinen Account."

    Examples:
      | login   | email           | password   |
      | testing | testing@man.net | secretpass |
      | foobar  | foo@bar.com     | fr33z3     |

#Scenario: Willing to edit my account
#    Given I am a new, authenticated user # beyond this step, your work!
#    When I want to edit my account
#    Then I should see the account initialization form
#    And I should see "Your account has not been initialized yet. Do it now!"
    # And more view checking stuff