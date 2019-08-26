@editor @editor_atto @atto @atto_wiris @_bug_phantomjs
Feature: MathML should be rendered by MathJax if the MathJax filter is first
In order to check if MathType's MathML can be rendered by MathJax
As an admin
I need to see MathType formulas rendered by MathJax

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
  Scenario: Add an additional equation delimiter and post
    And I navigate to "Site administration" in site administration
    And I follow "Site security settings"
    And I check enable trusted content
    And I press "Save changes"
    And I navigate to "Plugins" in site administration
    And I follow "MathJax"
    And I set the following fields to these values:
      | Additional equation delimiters | <math |
    And I press "Save changes"
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Page" to section "0"
    And I set the following fields to these values:
      | Name | Test MathType for Atto on Moodle: MathJax |
    And I enable saveMode
    And I press "MathType" in "Page content" field in Atto editor
    And I set MathType formula to '<math><mfrac><mn>1</mn><msqrt><mn>2</mn><mi>&#x3c0;</mi></msqrt></mfrac></math>'
    And I press accept button in MathType Editor
    And I press "Save and display"
    Then MathJax element should exist
    And the "mathjaxloader" filter is "disabled"
    And I reload the page
    Then a Wirisformula containing 'square root' should exist
    And Wirisformula should has height 48 with error of 2