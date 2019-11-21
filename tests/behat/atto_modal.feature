@editor @editor_atto @atto @atto_wiris @_bug_phantomjs
Feature: Use atto to post
In order to check if MathType formula can be displayed correctly
As an admin
I need to create a MathType formula

  Background:
    Given the following config values are set as admin:
      | config | value | plugin |
      | toolbar | math = wiris | editor_atto |
    And the following "courses" exist:
      | fullname | shortname | format |
      | Course 1 | C1        | topics |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | admin  | C1     | editingteacher |
    And the "wiris" filter is "on"
    And I log in as "admin"

  @javascript
  Scenario: Post with atto
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Page" to section "0"
    And I set the following fields to these values:
      | Name | Test MathType for Atto on Moodle |
    And I press "MathType" in "Page content" field in Atto editor
    And I set MathType formula to '<math><mfrac><mn>1</mn><msqrt><mn>2</mn><mi>&#x3c0;</mi></msqrt></mfrac></math>'
    And I press accept button in MathType Editor
    And I press "Save and display"
    Then a Wirisformula containing 'square root' should exist
    And Wirisformula should has height 48 with error of 2

  @javascript
  Scenario: Not open more than one modal per formula
    # Insert formula.
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Page" to section "0"
    And I set the following fields to these values:
      | Name | Test MathType for Atto on Moodle |
    And I press "MathType" in "Page content" field in Atto editor
    And I set MathType formula to '<math xmlns="http://www.w3.org/1998/Math/MathML"><mn>1</mn><mo>+</mo><mn>2</mn></math>'
    And I press accept button in MathType Editor
    # Open it with the button.
    And I click on image with alt equals to "1 plus 2"
    And I press "MathType" in "Page content" field in Atto editor
    Then modal window with number 0 is opened
    # Open it with dbClick.
    And I dbClick on image with alt equals to "1 plus 2"
    Then modal window with number 1 is not opened

