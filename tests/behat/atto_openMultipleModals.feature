@editor @editor_atto @atto @atto_wiris @_bug_phantomjs
Feature: Open multiple modals
In order to check if it's possible open one modal per editor
As an admin
I need to open one modal per editor

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
    And I log in as "admin"

  @javascript
  Scenario: Open multiple modal windows
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Page" to section "0"
    And I set the following fields to these values:
      | Name | Test MathType for Atto on Moodle chemistry formulas |
    And I press "MathType" in "Description" field in Atto editor
    Then modal window with number 0 is opened
    And I press "MathType" in "Page content" field in Atto editor
    Then modal window with number 1 is opened