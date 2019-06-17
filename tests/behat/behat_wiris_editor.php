<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Methods related to the interaction with the MathType.
 * @package    filter
 * @subpackage wiris
 * @copyright  WIRIS Europe (Maths for more S.L)
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

// NOTE: no MOODLE_INTERNAL test here, this file may be required by behat before including /config.php.

require_once(__DIR__ . '/behat_wiris_base.php');

class behat_wiris_editor extends behat_wiris_base {

     /**
      * @Transform /^(\d+)$/
      */
    public function cast_string_to_number($string) {
        return intval($string);
    }

    /**
     * Once the editor has been opened and focused, set the MathType formula to the specified value.
     *
     * @Given I set MathType formula to :value
     * @param  string $value value to which we want to set the field
     * @throws ElementNotFoundException If MathType does not exist, it will throw an invalid argument exception.
     */
    public function i_set_mathtype_formula_to($value) {
        $this->spin(
            function($context) {
                return $context->getSession()->getPage()->find('xpath', '//div[contains(@class,\'wrs_editor\')]//span[@class=\'wrs_container\']');
                }
            ,
            false,
            5
        );
        $session = $this->getSession(); // Get the mink session.
        if (strpos($value, 'math') == false) {
            $component = $session->getPage()->find(
                'xpath',
                $session->getSelectorsHandler()->selectorToXpath('xpath', "//input[@class='wrs_focusElement']")
            ); // Runs the actual query and returns the element.
            if (null === $component) {
                throw new \ElementNotFoundException($this->getSession(), get_string('wirisbehaterroreditornotfound', 'filter_wirs'));
            }
            $component->setValue($value);
        }
        else {
            $script = 'return document.getElementById(\'wrs_content_container[0]\')';
            $container = $session->evaluateScript($script);
            if (empty($container)) {
                throw new \ElementNotFoundException("MathType editor not found");
            }
            $script = 'const container = document.getElementById(\'wrs_content_container[0]\');'.
                'const editor = window.com.wiris.jsEditor.JsEditor.getInstance(container);'.
                'editor.setMathML(\''.$value.'\');';
            $session->executeScript($script);
        }
    }

    /**
     * Press on accept button in MathType Editor
     *
     * @Given I press accept button in MathType Editor
     * @throws ElementNotFoundException If MathType does not exist, it will throw an exception.
     */
    public function i_press_accept_button_in_mathtype_editor() {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '//button[@id=\'wrs_modal_button_accept[0]\']')
        );
        if (empty($component)) {
            throw new \ElementNotFoundException("Accept button in MathType editor not found.");
        }
        $component->click();
    }

    /**
     * Click on an element that contains certain value for an attribute
     *
     * @Given I click on MathType editor title bar
     * @throws ElementNotFoundException If the the editor title bar does not exist, it will throw an exception.
     */
    public function i_click_on_mathtype_editor_title_bar() {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '//div[@class=\'wrs_modal_title\']')
        );
        if (empty($component)) {
            throw new Exception ('MathType editor title bar does not exist');
        }
        $component->click();
    }

    /**
     * Look whether a Wirisformula exists
     *
     * @Then Wirisformula should exist
     */
    public function wirisformula_should_exist() {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '//img[contains(@class, \'Wirisformula\')]')
        );
        if (empty($component)) {
            throw new Exception ('Wirisformula does not exist.');
        }
    }

    /**
     * Look whether a Wirisformula exists
     *
     * @Then Wirisformula should not exist
     */
    public function wirisformula_should_not_exist() {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '//img[contains(@class, \'Wirisformula\')]')
        );
        if (!empty($component)) {
            throw new Exception ('Wirisformula does exist.');
        }
    }

    /**
     * Check if a Wirisformula containing certain value exist
     *
     * @Then a Wirisformula containing :value should exist
     * @param  string $value the formula should contains
     */
    public function a_wirisformula_containing_should_exist($value) {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '//img[contains(@alt, \''.$value.'\')]')
        );
        if (empty($component)) {
            throw new Exception ('Wirisformula with value '.$value.' does not exist.');
        }
    }

    /**
     * Look whether any ChemType formula exist
     *
     * @Then ChemType formula should exist
     */
    public function chemtype_formula_should_exist() {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '//img[contains(@data-mathml,\'chemistry\')]')
        );
        if (empty($component)) {
            throw new Exception ('ChemType formula does not exist.');
        }
    }

    /**
     * Check the size of the formula
     *
     * @Then Wirisformula should has height :height with error of :error
     * @param  int $height height value to be compared with
     * @param  int $error acceptable error of the height value
     * @throws ElementNotFoundException If formula does not exist, it will throw an invalid argument exception.
     */
    public function wirisformula_should_has_height_with_error($height, $error) {
        $session = $this->getSession();
        if ('integer' !== gettype($height) || 'integer' !== gettype($error)) {
            throw new Exception('Integer value expected.');
        }
        $script = 'return document.getElementsByClassName(\'Wirisformula\')[0].height';
        $formula = $session->evaluateScript($script);
        if (empty($formula)) {
            throw new \ElementNotFoundException('Formula not found.');
        }
        $script = 'return document.getElementsByClassName(\'Wirisformula\')[0].height >= '.($height - $error).
        ' && document.getElementsByClassName(\'Wirisformula\')[0].height <='.($height + $error);
        $equals = $this->getSession()->evaluateScript($script);
        if (!$equals) {
            throw new Exception('Image height is not correct.');
        }
    }

    /**
     * Click on Message text field
     *
     * @Given I click on Message text field
     * @throws ElementNotFoundException If the element does not exist, it will throw an exception.
     */
    public function i_click_on_message_text_field() {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '//div[@id="id_messageeditable"]')
        );
        if (empty($component)) {
            throw new Exception ('Message text field does not exist.');
        }
        $component->click();
    }

    /**
     * Place caret in a certain position
     *
     * @Given I place caret at position :position
     */
    public function i_place_caret_at_position($position) {
        $script = 'range = window.parent.document.getSelection().getRangeAt(0);'
            .'node = document.getElementById(\'id_messageeditable\').firstChild;'
            .'window.parent.document.getSelection().removeAllRanges();'
            .'range.setStart(node,'.$position.');'
            .'range.setEnd(node,'.$position.');'
            .'window.parent.document.getSelection().addRange(range);'
            .'window.parent.document.body.focus();';
        $this->getSession()->executeScript($script);
    }

    /**
     * Execute mathjax script
     *
     * @Given I enable saveMode
     */
    public function i_enable_save_mode() {
        $script = 'WirisPlugin.Configuration.set("saveMode", "xml")';
        $this->getSession()->executeScript($script);
    }

    /**
     * Press MathType button in Question text text field
     *
     * @Given I press MathType in Question text text field
     * @throws ElementNotFoundException If MathType does not exist, it will throw an exception.
     */
    public function i_press_mathtype_in_questiontext_text_field() {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '//div[@id="fitem_id_questiontext"]//button[@class="atto_wiris_button_wiris_editor"]')
        );
        if (empty($component)) {
            throw new Exception ('MathType button in Question text text field not found');
        }
        $component->click();
    }

    /**
     * Press MathType button in General feedback text field
     *
     * @Given I press MathType in General feedback text field
     * @throws ElementNotFoundException If MathType does not exist, it will throw an exception.
     */
    public function i_press_mathtype_in_general_feedback_text_field() {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '//div[@id="fitem_id_generalfeedback"]//button[@class="atto_wiris_button_wiris_editor"]')
        );
        if (empty($component)) {
            throw new Exception ('MathType button in General feedback text field not found');
        }
        $component->click();
    }

    /**
     * Press MathType button in Answer1 Feedback text field
     *
     * @Given I press MathType in Answer1 Feedback text field
     * @throws ElementNotFoundException If MathType does not exist, it will throw an exception.
     */
    public function i_press_mathtype_in_answer1_feedback_text_field() {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '//div[@id="fitem_id_feedback_0"]//button[@class="atto_wiris_button_wiris_editor"]')
        );
        if (empty($component)) {
            throw new Exception ('MathType button in Answer1 Feedback text field not found');
        }
        $component->click();
    }

    /**
     * Press HTML button in Question text text field
     *
     * @Given I press HTML in Question text text field
     * @throws ElementNotFoundException If HTML does not exist, it will throw an exception.
     */
    public function i_press_html_in_questiontext_text_field() {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '//div[@id="fitem_id_questiontext"]//button[@class="atto_html_button"]')
        );
        if (empty($component)) {
            throw new Exception ('HTML button in Question text text field not found');
        }
        $component->click();
    }

    /**
     * Press HTML button in General feedback text field
     *
     * @Given I press HTML in General feedback text field
     * @throws ElementNotFoundException If HTML does not exist, it will throw an exception.
     */
    public function i_press_html_in_general_feedback_text_field() {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '//div[@id="fitem_id_generalfeedback"]//button[@class="atto_html_button"]')
        );
        if (empty($component)) {
            throw new Exception ('HTML button in General feedback text field not found');
        }
        $component->click();
    }

    /**
     * Press HTMEL button in Answer1 Feedback text field
     *
     * @Given I press HTML in Answer1 Feedback text field
     * @throws ElementNotFoundException If HTML does not exist, it will throw an exception.
     */
    public function i_press_html_in_answer1_feedback_text_field() {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '//div[@id="fitem_id_feedback_0"]//button[@class="atto_html_button"]')
        );
        if (empty($component)) {
            throw new Exception ('HTML button in Answer1 Feedback text field not found');
        }
        $component->click();
    }

    /**
     * Look whether an element contains certain value for an attribute
     *
     * @Then element :element containing attribute :attribute with value :value should exist
     * @param  string $element element to find
     * @param  string $attribute attribute of the element to find
     * @param  string $value value for the attribute of the element to find
     */
    public function element_containing_attribute_with_value_should_exist($element,$attribute,$value) {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '//'.$element.'[contains(@'.$attribute.', \''.$value.'\')]')
        );
        if (empty($component)) {
            throw new Exception ($element.' with value '.$value.' for attribute '.$attribute.' not found');
        }
    }

    /**
     * Look whether an element contains certain value for an attribute
     *
     * @Then element :element containing attribute :attribute with value :value should not exist
     * @param  string $element element to find
     * @param  string $attribute attribute of the element to find
     * @param  string $value value for the attribute of the element to find
     */
    public function element_containing_attribute_with_value_should_not_exist($element,$attribute,$value) {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '//'.$element.'[contains(@'.$attribute.', \''.$value.'\')]')
        );
        if (!empty($component)) {
            throw new Exception ($element.' with value \''.$value.'\' for attribute \''.$attribute.'\' does exist');
        }
    }

    /**
     * Click on an element that contains certain value for an attribute
     *
     * @Given I click on element :element containing attribute :attribute with value :value
     * @throws ElementNotFoundException If the element does not exist, it will throw an exception.
     */
    public function i_click_on_element_containing_attribute_with_value($element,$attribute,$value) {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '//'.$element.'[contains(@'.$attribute.', \''.$value.'\')]')
        );
        if (empty($component)) {
            throw new Exception ($element.' with value \''.$value.'\' for attribute \''.$attribute.'\' do not exist');
        }
        $component->click();
    }

}
