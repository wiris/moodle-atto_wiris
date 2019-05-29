@editor @editor_atto @atto @_bug_phantomjs @atto_modal
Feature: MathType for Atto
  To teach maths to students, I need to write equations

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
  Scenario: Use atto to post
    And I log in as "admin"
    And I navigate to "Plugins" in site administration
    And I click on "Manage filters" "link"
    And I click on "On" "option" in the "MathType by WIRIS" "table_row"
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Forum" to section "0"
    And I set the following fields to these values:
      | Forum name | News Forum |
      | Description | |
    And I press "Save and return to course"
    And I follow "News Forum"
    And I press "Add a new discussion topic"
    And I set the following fields to these values:
      | Subject | Test MathType for Atto on Moodle |
    And I press "MathType"
    And I wait "5" seconds
    And I set mathtype formula to '<math><mfrac><mn>1</mn><msqrt><mn>2</mn><mi>&#x3c0;</mi></msqrt></mfrac></math>'
    And I click on "//button[@id='wrs_modal_button_accept[0]']" "xpath_element"
    And I press "Post to forum"
    And I click on "Test MathType for Atto on Moodle" "link"
    Then "//img[@alt='fraction numerator 1 over denominator square root of 2 pi end root end fraction']" "xpath_element" should exist
    Then "Wirisformula" should has height 48 with error of 2
