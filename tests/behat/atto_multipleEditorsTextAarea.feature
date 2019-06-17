@editor @editor_atto @atto @atto_wiris @_bug_phantomjs
Feature: Checks formula creation in forms with multiple editors

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
  Scenario: Checks formula creation in forms with multiple editors
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
    And I add a "Quiz" to section "1"
    And I set the field "Name" to "Quiz 1"
    And I press "Save and return to course"
    And I follow "Quiz 1"
    And I press "Edit quiz"
    And I follow "Add"
    And I follow "a new question"
    And I click on "Short answer" "radio"
    And I press "submitbutton"
    And I press MathType in Question text text field
    And I set MathType formula to '<math xmlns="http://www.w3.org/1998/Math/MathML"><msqrt><mn>2</mn></msqrt></math>'
    And I press accept button in MathType Editor
    And I press HTML in Question text text field
    And I press MathType in General feedback text field
    And I set MathType formula to '<math xmlns="http://www.w3.org/1998/Math/MathML"><msqrt><mn>3</mn></msqrt></math>'
    And I press accept button in MathType Editor
    And I press HTML in General feedback text field
    And I press MathType in Answer1 Feedback text field
    And I set MathType formula to '<math xmlns="http://www.w3.org/1998/Math/MathML"><msqrt><mn>4</mn></msqrt></math>'
    And I press accept button in MathType Editor
    And I press HTML in Answer1 Feedback text field
    Then the field "Question text" matches value "<p><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><msqrt><mn>2</mn></msqrt></math><br></p>"
    Then the field "General feedback" matches value "<p><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><msqrt><mn>3</mn></msqrt></math><br></p>"
    Then the field "Feedback" matches value "<p><math xmlns=\"http://www.w3.org/1998/Math/MathML\"><msqrt><mn>4</mn></msqrt></math><br></p>"
    Then element 'img' containing attribute 'alt' with value 'square root of 2' should exist
    Then element 'img' containing attribute 'alt' with value 'square root of 3' should exist
    Then element 'img' containing attribute 'alt' with value 'square root of 4' should exist
    And I set the following fields to these values:
      | Question name | Short 1 |
      | Answer 1 | 10 |
    And I click on "100%" "option" in the "#id_fraction_0" "css_element"
    And I press "submitbutton"
    And I follow "Quiz 1"
    And I navigate to "Preview" in current page administration
    Then a Wirisformula containing 'square root of 2' should exist
    And I set the field "Answer" to "10"
    And I follow "Finish attempt ..."
    And I press "Submit all and finish"
    And I click on "Submit all and finish" "button" in the "Confirmation" "dialogue"
    Then a Wirisformula containing 'square root of 2' should exist
    Then a Wirisformula containing 'square root of 3' should exist
    Then a Wirisformula containing 'square root of 4' should exist