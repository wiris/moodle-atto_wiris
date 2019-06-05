@editor @editor_atto @atto @atto_wiris @_bug_phantomjs
Feature: Test I double struck (UTF-32)

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
  Scenario: Test I double struck (UTF-32)
    And I log in as "admin"
    And I navigate to "Plugins" in site administration
    And I click on "Manage filters" "link"
    And I click on "On" "option" in the "MathType by WIRIS" "table_row"
    And I navigate to "Plugins" in site administration
    And I click on "Atto toolbar settings" "link"
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
    And I wait "5" seconds
    And I set mathtype formula to '<math><mi mathvariant="normal">&#x1D540;</mi></math>'
    And I press accept button in Mathtype Editor
    And I press "HTML"
    And I press "HTML"
    And I press "Post to forum"
    And I click on "Test MathType for Atto on Moodle" "link"
    Then element 'img' containing attribute 'alt' with value 'straight 𝕀' should exist
    Then Wirisformula should has height 19 with error of 2
