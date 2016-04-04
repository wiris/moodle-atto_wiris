<?php

/**
 * Initialise the js strings required for this module.
 */
function atto_wiris_strings_for_js() {
    global $PAGE;
    $PAGE->requires->strings_for_js(
      array(
        'wiris_editor_title',
        'wiris_cas_title',
        'wiris_chem_editor_title',
      ),
      'atto_wiris');
}

/**
 * Set parameters to be passed to the js plugin constructor.
 */
function atto_wiris_params_for_js() {
    return array('lang' => current_language());
}