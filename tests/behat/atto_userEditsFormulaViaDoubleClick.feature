@atto @atto_wiris @wiris_mathtype @atto_edit_formula @mtmoodle-34
Feature: Edit MathType formula with atto editor via double click
In order to check if MathType formula can be edited via double click
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
    And the "mathjaxloader" filter is "off"
    And the "urltolink" filter is "off"
    And I log in as "admin"

  @javascript @4.x @4.x_atto
  Scenario: MTMOODLE-34 - Edit MathType formula via double click
    # Course
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Page" to section "0" using the activity chooser
    And I set the following fields to these values:
      | Name | Test MathType for Atto on Moodle chemistry formulas |
    # Insert formula.
    And I press "MathType" in "Page content" field in Atto editor
    And I wait until MathType editor is displayed
    And I wait "3" seconds
    And I set MathType formula to '<math xmlns="http://www.w3.org/1998/Math/MathML"><mn>1</mn><mo>+</mo><mn>1</mn></math>'
    And I wait "1" seconds
    And I press accept button in MathType Editor
    # Assert that dbClick works
    And I wait until Wirisformula formula exists
    And I dbClick on WirisFormula with alt equals to "1 plus 1"
    And I wait until MathType editor is displayed
    And I wait "3" seconds
    And I set MathType formula to '<math xmlns="http://www.w3.org/1998/Math/MathML"><msqrt><mi>y</mi></msqrt></math>'
    And I wait "1" seconds
    And I press accept button in MathType Editor
    And I press "Save and display"
    # Check final formula
    And I wait until Wirisformula formula exists
    Then a Wirisformula containing '1 plus 1' should not exist
    And a Wirisformula containing 'square root of y' should exist

  @javascript @4.0 @4.0_atto
  Scenario: MTMOODLE-34 - Edit MathType formula via double click
    # Course
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Page" to section "0"
    And I set the following fields to these values:
      | Name | Test MathType for Atto on Moodle chemistry formulas |
    # Insert formula.
    And I press "MathType" in "Page content" field in Atto editor
    And I wait until MathType editor is displayed
    And I wait "3" seconds
    And I set MathType formula to '<math xmlns="http://www.w3.org/1998/Math/MathML"><mn>1</mn><mo>+</mo><mn>1</mn></math>'
    And I wait "1" seconds
    And I press accept button in MathType Editor
    # Assert that dbClick works
    And I wait until Wirisformula formula exists
    And I dbClick on WirisFormula with alt equals to "1 plus 1"
    And I wait until MathType editor is displayed
    And I wait "3" seconds
    And I set MathType formula to '<math xmlns="http://www.w3.org/1998/Math/MathML"><msqrt><mi>y</mi></msqrt></math>'
    And I wait "1" seconds
    And I press accept button in MathType Editor
    And I press "Save and display"
    # Check final formula
    And I wait until Wirisformula formula exists
    Then a Wirisformula containing '1 plus 1' should not exist
    And a Wirisformula containing 'square root of y' should exist
