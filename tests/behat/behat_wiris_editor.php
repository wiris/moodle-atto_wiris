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
    public function castStringToNumber($string)
    {
        return intval($string);
    }


    /**
     * Once the editor has been opened and focused, sets the MathType formula to the specified value.
     *
     * @Given I set mathtype formula to :value
     * @param  string $value value to which we want to set the field
     * @throws ElementNotFoundException If MathType does not exist, it will throw an invalid argument exception.
     */
    public function i_set_mathtype_formula_to($value) {
        $session = $this->getSession(); // Get the mink session.

        $script = 'const container = document.getElementById(\'wrs_content_container[0]\');'.
            'const editor = window.com.wiris.jsEditor.JsEditor.getInstance(container);'.
            'editor.setMathML(\''.$value.'\');';
        $session->executeScript($script);
    }

    /**
     * Check the size of the image
     *
     * @Then :xpath should has height :height with error of :error
     * @param  string $xpath xpath of the image to verify its height
     * @param  int $height height value to be compared with
     * @param  int $error acceptable error of the height value
     * @throws ElementNotFoundException If image does not exist, it will throw an invalid argument exception.
     */
    public function image_has_height($xpath, $height, $error) {
        $session = $this->getSession();

        $script = 'return document.getElementsByClassName(\''.$xpath.'\')[0].height >= '.($height - $error).
        ' && document.getElementsByClassName(\''.$xpath.'\')[0].height <='.($height + $error);
        $equals = $session->evaluateScript($script);

        if ('integer' !== gettype($height) || 'integer' !== gettype($error)) {
            throw new Exception('Integer expected.');
        }
        if (!$equals) {
            throw new Exception('Image height is not correct');
        }
    }

    /**
     * Execute mathjax script
     *
     * @Given I enable saveMode
     */
    public function enable_save_mode() {
        $session = $this->getSession();
        $script = 'WirisPlugin.Configuration.set("saveMode", "xml")';
        $session->executeScript($script);
    }
}
