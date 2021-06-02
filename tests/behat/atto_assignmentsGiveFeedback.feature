@editor @editor_atto @atto @atto_wiris @wiris_mathtype @atto_wiris_assignments
Feature: Formulas are rendered on an Assignment feedback
  In order to check that formulas can be included on an assignment feedback
  As an admin
  I need to create a MathType formula on an assignment's feedback

  Background:
    Given the following config values are set as admin:
      | config | value | plugin |
      | toolbar | math = wiris | editor_atto |
    And the following "users" exist:
      | username | firstname | lastname | email |
      | student1 | Student | 1 | student1@example.com |
    And the following "courses" exist:
      | fullname | shortname | format |
      | Course 1 | C1        | topics |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | admin  | C1     | editingteacher |
      | student1 | C1 | student |
    And the "wiris" filter is "on"
    And the "mathjaxloader" filter is "off"
    And the "urltolink" filter is "off"
    And I log in as "admin"

  @javascript
  Scenario: Grade an assignment with a Formula and ensure it display correctly in the gradebook
    # 01. Create the assignment
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Assignment" to section "0"
    And I set the following fields to these values:
      |  Assignment name | Test MathType for Atto on Moodle |
    And I click on "Online text" "checkbox"
    And I click on "File submissions" "checkbox"
    Then I press "Save and display"
    And I should see "Grade"
    # A super shitty-wat to click on the 'Grade' link since "I press" and 'I click on "Grade" "link"' don't work.
    # And I click on "Grade" "link" # Does not work.
    And I click on ".btn-primary" "css_element" in the "//div[@class='submissionlinks']" "xpath_element"
    # 02. Grade the assignment.
    And I click on "MathType" "button"
    And I set MathType formula to '<math><mfrac><mn>1</mn><msqrt><mn>2</mn><mi>&#x3c0;</mi></msqrt></mfrac></math>'
    And I press accept button in MathType Editor
    Then I press "Save changes"
    # 03. Validate the formula is rendered on both contexts.
    Then I wait until Wirisformula formula exists
    And a Wirisformula containing 'square root' should exist
    # These next steps don't work for Moodle3_7 and below.
    # Then I follow "View all submissions"
    # And I wait until Wirisformula formula exists
    # And a Wirisformula containing 'square root' should exist
