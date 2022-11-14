@editor @editor_atto @atto @atto_wiris @_bug_phantomjs @wiris_mathtype @atto_wiris_latex @atto_wiris_compatibility
Feature: Check empty LaTeX edition
In order to check the edition of a formula in LaTeX
As an admin
I need to edit an empty LaTeX with MathType

  Background:
    Given the following "courses" exist:
      | fullname | shortname | format |
      | Course 1 | C1        | topics |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | admin  | C1     | editingteacher |
    And the "wiris" filter is "on"
    And the "mathjaxloader" filter is "disabled"
    And the "urltolink" filter is "off"
    And I log in as "admin"

  @javascript
  Scenario: Insert MathType formula to an empty LaTeX
    And I navigate to "General > Security > Site security settings" in site administration
    And I check enable trusted content
    And I press "Save changes"
    And I navigate to "Plugins > Text editors > Atto toolbar settings" in site administration
    And I set the field "Toolbar config" to multiline:
    """
    other = html
    math = wiris
    """
    And I press "Save changes"
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Page" to section "0"
    And I set the following fields to these values:
      | Name | Test MathType for Atto on Moodle |
      | Page content | $$$$ |
    And I click on "Page content" field
    And I place caret at position "2" in "Page content" field
    And I press "MathType" in "Page content" field in Atto editor
    And I set MathType formula to '<math><mfrac><mn>1</mn><msqrt><mn>2</mn><mi>&#x3c0;</mi></msqrt></mfrac></math>'
    And I wait "1" seconds
    And I press accept button in MathType Editor
    And I wait "1" seconds
    Then "$$\frac1{\sqrt{2\pi}}$$" "text" should exist
    And I press "Save and display"
    And I wait "1" seconds
    And I navigate to "Settings" in current page administration
    Then "$$\frac1{\sqrt{2\pi}}$$" "text" should exist
