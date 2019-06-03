@editor @editor_atto @atto @_bug_phantomjs @atto_frenchQuotes
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
  Scenario: Checking french quotes to prevent dissapear and post
    And I log in as "admin"
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Forum" to section "0"
    And I set the following fields to these values:
      | Forum name | News Forum |
    And I press "Save and return to course"
    And I follow "News Forum"
    And I press "Add a new discussion topic"
    And I set the following fields to these values:
      | Subject | Test MathType for Atto on Moodle |
      | Message | &laquo;Bonjour&raquo; |
    And I press "Post to forum"
    And I click on "Test MathType for Atto on Moodle" "link"
    Then "&laquo;Bonjour&raquo;" "text" should exist
    And I click on "Edit" "link"
    Then "//img[@class='Wirisformula']" "xpath_element" should not exist