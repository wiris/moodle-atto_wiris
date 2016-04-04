<?php
/**
 * Enable WIRIS plugin buttons on installation.
 */
function xmldb_atto_wiris_install() {
    $toolbar = get_config('editor_atto', 'toolbar');
    if (strpos($toolbar, 'wiris') === false && $toolbar && $toolbar != '') {
        $groups = explode("\n", $toolbar);
        // Try to put wiris in math group
        $found = false;
        foreach ($groups as $i => $group) {
            $parts = explode('=', $group);
            if (trim($parts[0]) == 'math') {
                $groups[$i] = 'math = ' . trim($parts[1]) . ', wiris';
                $found = true;
            }
        }
        // Otherwise create a math group in the second position starting from 
        // the end.
        if (!$found) {
            do {
                $last = array_pop($groups);
            } while(empty($last) && !empty($groups));
            $groups[] = 'math = wiris';
            $groups[] = $last;
        }
        // Update config variable.
        $toolbar = implode("\n", $groups);
        set_config('toolbar', $toolbar, 'editor_atto');
    }
}