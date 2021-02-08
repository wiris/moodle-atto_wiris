@filter @filter_wiris @filter_wiris_settings @wiris_settings @wiris_mathtype @atto @atto_wiris
Feature: Check the math and chem buttons visibility on text editors
In order to check the buttons visibility in atto editor
As an admin
I need to change the settings on the filter wiris
and disable the chemtype and mathtype buttons

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
  Scenario: Disable mathtype button and check that it is not visible in atto toolbar
    And I navigate to "Plugins > Filters" in site administration
    And I set the field "Math editor" to "0"
    And I press "Save changes"
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Page" to section "0"
    Then I check "MathType" in "Page content" field "does not" exist in Atto editor
    And I check "ChemType" in "Page content" field "does" exist in Atto editor

  @javascript
  Scenario: Disable chemtype button and check that it is not visible in atto toolbar
    And I navigate to "Plugins > Filters" in site administration
    And I set the field "Chemistry editor" to "0"
    And I press "Save changes"
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Page" to section "0"
    Then I check "MathType" in "Page content" field "does" exist in Atto editor
    And I check "ChemType" in "Page content" field "does not" exist in Atto editor

  @javascript
  Scenario: Disable mathtype & chemtype buttons and check that they are not visible in atto toolbar
    And I navigate to "Plugins > Filters" in site administration
    And I set the field "Math editor" to "0"
    And I set the field "Chemistry editor" to "0"
    And I press "Save changes"
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Page" to section "0"
    Then I check "MathType" in "Page content" field "does not" exist in Atto editor
    And I check "ChemType" in "Page content" field "does not" exist in Atto editor