@editor @editor_atto @atto @_bug_phantomjs @atto_filterCourseEnabled
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
  Scenario: Check MathType enabled if filter disabled at course level but allow_editorplugin_active_course setting is enabled
    And I log in as "admin"
    And I navigate to "Plugins" in site administration
    And I click on "Manage filters" "link"
    And I click on "On" "option" in the "MathType by WIRIS" "table_row"
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Forum" to section "0"
    And I set the following fields to these values:
      | Forum name | News Forum |
    And I press "Save and return to course"
    And I navigate to "Filters" in current page administration
    And I click on "Off" "option" in the "MathType by WIRIS" "table_row"
    And I press "Save changes"
    And I am on "Course 1" course homepage
    And I follow "News Forum"
    And I press "Add a new discussion topic"
    Then "//button[@class='atto_wiris_button_wiris_editor']" "xpath_element" should not exist
    And I navigate to "Plugins" in site administration
    And I click on "MathType by WIRIS" "link"
    And I click on "id_s_filter_wiris_allow_editorplugin_active_course" "checkbox"
    And I press "Save changes"
    And I am on "Course 1" course homepage
    And I follow "News Forum"
    And I press "Add a new discussion topic"
    Then "//button[@class='atto_wiris_button_wiris_editor']" "xpath_element" should exist
    And I wait "800" seconds