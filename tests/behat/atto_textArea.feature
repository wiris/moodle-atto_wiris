@editor @editor_atto @atto @atto_wiris @_bug_phantomjs @atto_wiris_bug01 @wiris_mathtype @3.x
Feature: Check if the raw code generated in html contains MathML instead of safeXML
In order to edit HTML code
As an admin
I need to not loose data editing HTML code

  Background:
    Given the following "courses" exist:
      | fullname | shortname | format |
      | Course 1 | C1        | topics |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | admin  | C1     | editingteacher |
    And the "wiris" filter is "on"
    And the "urltolink" filter is "off"
    And the "mathjaxloader" filter is "off"
    And I log in as "admin"

  @javascript
  Scenario: Transform formula to raw code in html
    And I navigate to "Plugins > Text editors > Atto toolbar settings" in site administration
    And I set the field "Toolbar config" to multiline:
    """
    math = wiris
    other = html
    """
    And I press "Save changes"
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Page" to section "0"
    And I set the following fields to these values:
      | Name | Test MathType for Atto on Moodle |
    And I press "MathType" in "Page content" field in Atto editor
    And I set MathType formula to '<math><mfrac><mn>1</mn><msqrt><mn>20</mn><mi>&#x3c0;</mi></msqrt></mfrac></math>'
    And I wait "1" seconds
    And I press accept button in MathType Editor
    # And I press "HTML" in "Page content" field in Atto editor
    # Then I wait until Wirisformula formula exists
    # Then I should see "<math xmlns=\"http://www.w3.org/1998/Math/MathML\"><mfrac><mn>1</mn><msqrt><mn>20</mn><mi>&#960;</mi></msqrt></mfrac></math>"
    And I press "Save and display"
    And I wait "2" seconds
    Then I wait until Wirisformula formula exists
    # Then a Wirisformula containing 'square root' should exist
