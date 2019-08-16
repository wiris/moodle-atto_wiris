@editor @editor_atto @atto @atto_wiris @_bug_phantomjs
Feature: MathType for Atto
  In order to check if formula can be created correctly in atto
  I need to create a formula in the user profile

  Background:
    Given the following config values are set as admin:
      | config | value | plugin |
      | toolbar | math = wiris | editor_atto |
    And the "wiris" filter is "on"
    And I log in as "admin"

  @javascript
  Scenario: Create a formula
    And I open my profile in edit mode
    And I press "MathType"
    And I set mathtype formula to "1+2"
    And I press accept button in Mathtype Editor
    And I press "Update profile"
    And I follow "Profile" in the user menu
    # Checking formula image outside edit element.
    Then a Wirisformula containing '1 plus 2' should exist
    # Checking formula image inside edit element.
    And I open my profile in edit mode
    Then a Wirisformula containing '1 plus 2' should exist
