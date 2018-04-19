@editor @editor_atto @atto @atto_wiris @_bug_phantomjs
Feature: MathType for Atto
  To teach maths to students, I need to write equations

  @javascript
  Scenario: Create a formula
    Given the following config values are set as admin:
    | config | value | plugin |
    | toolbar | math = wiris | editor_atto |
    And I log in as "admin"
    And I navigate to "Plugins" in site administration
    And I click on "Manage filters" "link"
    And I click on "On" "option" in the "MathType by WIRIS" "table_row"
    And I open my profile in edit mode
    And I click on "MathType" "button"
    And I switch to "wrs_modal_iframe_id" iframe
    And I wait "5" seconds
    And I set mathtype formula to "1+2"
    And I click on "//input[@class='wrs_button_accept']" "xpath_element"
    And I switch to the main frame
    And I click on "Update profile" "button"
    And I follow "Profile" in the user menu
    # Checking formula image outside edit element.
    Then "//img[@alt='1 plus 2']" "xpath_element" should exist
    # Checking formula image inside edit element.
    And I open my profile in edit mode
    Then "//img[@alt='1 plus 2']" "xpath_element" should exist
