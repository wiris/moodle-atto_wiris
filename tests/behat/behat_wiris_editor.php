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
     * @Given I set mathtype formula to :value
     * @param  string $value value to which we want to set the field
     * @throws ElementNotFoundException If MathType does not exist, it will throw an invalid argument exception.
     */
    public function i_set_mathtype_formula_to($value) {
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
                throw new \ElementNotFoundException("Mathtype editor not found");
            }
            $script = 'const container = document.getElementById(\'wrs_content_container[0]\');'.
                'const editor = window.com.wiris.jsEditor.JsEditor.getInstance(container);'.
                'editor.setMathML(\''.$value.'\');';
            $session->executeScript($script);
        }
    }

    /**
     * Press on accept button in Mathtype Editor
     *
     * @Given I press accept button in Mathtype Editor
     * @throws ElementNotFoundException If MathType does not exist, it will throw an exception.
     */
    public function i_click_accept_button_in_mathtype_editor() {
        $session = $this->getSession();
        $component = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', "//button[@id='wrs_modal_button_accept[0]']")
        );
        if (empty($component)) {
            throw new \ElementNotFoundException("Accept button in Mathtype editor not found");
        }
        $component->click();
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
            throw new \ElementNotFoundException('Formula not found');
        }
        $script = 'return document.getElementsByClassName(\'Wirisformula\')[0].height >= '.($height - $error).
        ' && document.getElementsByClassName(\'Wirisformula\')[0].height <='.($height + $error);
        $equals = $this->getSession()->evaluateScript($script);
        if (!$equals) {
            throw new Exception('Image height is not correct');
        }
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
            throw new Exception ($element.' with value \''.$value.'\' for attribute \''.$attribute.'\' do exist');
        }
    }
}
