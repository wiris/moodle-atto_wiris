<?php

function xmldb_atto_wiris_uninstall() {
    // Remove 'wiris' from the toolbar editor_atto config variable.
    $toolbar = get_config('editor_atto', 'toolbar');
    if (strpos($toolbar, 'wiris') !== FALSE) {
        $groups = explode("\n", $toolbar);
        $newgroups = array();
        foreach ($groups as $group) {
            if (strpos($group, 'wiris') !== FALSE) {
                $parts = explode('=', $group);
                $items = explode(',', $parts[1]);
                $newitems = array();
                foreach ($items as $item) {
                    if (trim($item) != 'wiris') {
                        $newitems[] = $item;
                    }
                }
                if (!empty($newitems)) {
                    $parts[1] = implode(',', $newitems);
                    $newgroups[] = implode('=', $parts);
                }
            }
            else {
                $newgroups[] = $group;
            }
        }
        $toolbar = implode("\n", $newgroups);
        set_config('toolbar', $toolbar, 'editor_atto');
    }
}