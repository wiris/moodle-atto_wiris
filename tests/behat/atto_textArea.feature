@editor @editor_atto @atto @atto_wiris @_bug_phantomjs
Feature: Check if the raw code generated in html contains MathML instead of safeXML

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

  @javascript
  Scenario: Check if the raw code generated in html contains MathML instead of safeXML
    And I log in as "admin"
    And I navigate to "Plugins" in site administration
    And I follow "Manage filters"
    And I click on "On" "option" in the "MathType by WIRIS" "table_row"
    And I navigate to "Plugins" in site administration
    And I follow "Atto toolbar settings"
    And I set the field "Toolbar config" to multiline:
    """
    math = wiris
    other = html
    """
    And I press "Save changes"
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Forum" to section "0"
    And I set the following fields to these values:
      | Forum name | News Forum |
    And I press "Save and return to course"
    And I follow "News Forum"
    And I press "Add a new discussion topic"
    And I set the following fields to these values:
      | Subject | Test MathType for Atto on Moodle |
    And I press "MathType"
    And I set MathType formula to '<math><mfrac><mn>1</mn><msqrt><mn>20</mn><mi>&#x3c0;</mi></msqrt></mfrac></math>'
    And I press accept button in MathType Editor
    And I press "HTML"
    Then the field "Message" matches value "<p><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><mfrac><mn>1</mn><msqrt><mn>20</mn><mi>&#960;</mi></msqrt></mfrac></math><br></p>"
    And I press "Post to forum"
    And I follow "Test MathType for Atto on Moodle"
    Then a Wirisformula containing 'square root' should exist
