@atto @atto_wiris @wiris_mathtype @atto_insert_formula @mtmoodle-91
Feature: Insert ChemType formula with atto editor
In order to check whether a ChemType formula can be displayed correctly
As an admin
I need to write a ChemType formula

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
    And the "urltolink" filter is "off"
    And the "mathjaxloader" filter is "off"
    And I log in as "admin"

  @javascript @4.x @4.x_atto
  Scenario: MTMOODLE-91 - User inserts ChemType with atto
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Page" to section "0" using the activity chooser
    And I set the following fields to these values:
      | Name | Test MathType for Atto on Moodle chemistry formulas |
    And I press "ChemType" in "Page content" field in Atto editor
    And I wait until MathType editor is displayed
    And I set MathType formula to '<math><mi mathvariant="normal">H</mi><mn>2</mn><mi mathvariant="normal">O</mi></math>'
    And I wait "3" seconds
    And I press accept button in MathType Editor
    And I press "Save and display"
    Then I wait until Wirisformula formula exists
    Then ChemType formula should exist
    And Wirisformula should has height 19 with error of 2

  @javascript @3.x @3.x_atto @4.0 @4.0_atto
  Scenario: MTMOODLE-91 - User inserts ChemType with atto
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Page" to section "0"
    And I set the following fields to these values:
      | Name | Test MathType for Atto on Moodle chemistry formulas |
    And I press "ChemType" in "Page content" field in Atto editor
    And I set MathType formula to '<math><mi mathvariant="normal">H</mi><mn>2</mn><mi mathvariant="normal">O</mi></math>'
    And I wait "1" seconds
    And I press accept button in MathType Editor
    And I press "Save and display"
    And I wait "1" seconds
    Then I wait until Wirisformula formula exists
    Then ChemType formula should exist
    And Wirisformula should has height 19 with error of 2
