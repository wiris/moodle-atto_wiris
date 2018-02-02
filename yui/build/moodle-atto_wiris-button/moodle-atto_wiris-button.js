YUI.add('moodle-atto_wiris-button', function (Y, NAME) {

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
//

/*
 * @package    atto_atto_wiris
 * @copyright  2011, Maths for More S.L. http://www.wiris.com
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

/**
 * @module moodle-atto_atto_wiris-button
 */

/**
 * Atto text editor WIRIS plugin.
 *
 * @namespace M.atto_wiris
 * @class button
 * @extends M.editor_atto.EditorPlugin
 */


Y.namespace('M.atto_wiris').Button = Y.Base.create('button', Y.M.editor_atto.EditorPlugin, [], {
    /**
     * The current language en by default.
     * **/
    _lang: 'en',

    /**
     * Initialization function.
     *
     * @param string lang
     *   The language ISO code.
     **/
    initializer: function(config) {

        // Filter not enabled at course level so no continue.
        if (!config.filter_enabled) {
            return;
        }
        this._lang = config.lang;
        window._wrs_int_langCode = config.lang;
        // Add global-scope callback functions and properties.

        // Popup closed callback.
        window.wrs_int_notifyWindowClosed = function() {
            window._wrs_int_popup = null;
            window._wrs_temporalImage = null;
            window._wrs_isNewElement = true;
        };

        // Editor popup OK callback.
        window.wrs_int_updateFormula = function(mathml, editMode) {
            var editable = window._wrs_int_currentPlugin.get('host').editor.getDOMNode();
            wrs_updateFormula(editable, window, mathml, null, editMode,  _wrs_int_currentPlugin._lang);
            window._wrs_int_currentPlugin.markUpdated();
            window._wrs_int_currentPlugin._updateEditorImgHandlers();
        };

        // CAS popup OK callback.
        window.wrs_int_updateCAS = function(appletCode, image, width, height) {
            var editable = window._wrs_int_currentPlugin.get('host').editor.getDOMNode();
            wrs_updateCAS(editable, window, appletCode, image, width, height);
            window._wrs_int_currentPlugin.markUpdated();
            window._wrs_int_currentPlugin._updateCasImgHandlers();
        };

        // Configuration location.
        window._wrs_int_conf_file = M.cfg.wwwroot + '/filter/wiris/integration/configurationjs.php';
        window._wrs_int_conf_path = M.cfg.wwwroot + '/lib/editor/atto/plugins/wiris';
        window._wrs_int_conf_async = true;
        window._wrs_int_popup = window._wrs_int_popup || null;
        window._wrs_int_coreLoading = window._wrs_int_coreLoading || false;

        // Custom integration folder.
        window._wrs_int_path = window._wrs_int_conf_file.split("/");
        window._wrs_int_path.pop();
        window._wrs_int_path = window._wrs_int_path.join("/");

        // Here we choose the correct integration path.
        // We need to know if the integration path is an absolute path
        // or an absolute URL.
        var wrs_int_path_cond = window._wrs_int_path.indexOf("/") === 0 || window._wrs_int_path.indexOf("http");

        // Here we construct the final integration path.
        window._wrs_int_path = wrs_int_path_cond ? window._wrs_int_path : window._wrs_int_conf_path + "/" + window._wrs_int_path;

        // Moodle.
        window._wrs_isMoodle24 = true;

        // Custom editors.
        window._wrs_int_customEditors = {
            chemistry : {
                name: 'Chemistry',
                toolbar : 'chemistry',
                icon : 'chem.gif',
                enabled : false,
                confVariable : '_wrs_conf_chemEnabled',
                title: 'WIRIS EDITOR chemistry'}};

        // Load WIRIS plugin core javascript file only once.
        if (!window._wrs_int_coreLoading) {
            window._wrs_int_coreLoading = true;
            Y.Get.js(window._wrs_int_conf_path + '/core/core.js', function(err) {
                if (err) {
                }
            });
        }

        // Add parse/unparse events.
        var host = this.get('host');
        var wirisplugin = this;
        window._wrs_int_currentPlugin = this;
        // check if elements of editor exists and return elements
        var wrs_editors_elements_cond = typeof window._wrs_int_editors_elements == "undefined";
        window._wrs_int_editors_elements = wrs_editors_elements_cond ? {} : window._wrs_int_editors_elements;
        // Update textarea value on change.
        host.on('change', function() {
            wirisplugin._unparseContent();
        });
        // Override updateFromTextArea to update the content editable element.
        host._wirisUpdateFromTextArea = host.updateFromTextArea;
        host.updateFromTextArea = function() {
            host._wirisUpdateFromTextArea();
            wirisplugin._parseContent();
        };

        // Parse the content for the first time.
        this._parseContent();

        // Add WIRIS buttons to the toolbar.
        this._addButtons();

        // Adding submit event.
        var form = host.textarea.ancestor('form');

        if (form) {
            form.on('submit', this._submitClean, this);
        }

    },

    /**
     * This method convert the content of the textarea (MathML) into
     * the default saveMode (saveXml or MathML) after the content is updated on the database.
     */
    _submitClean: function() {
        var host = this.get('host');
        // We get the HTML content (with the imnages) instead of the raw html content
        // and convert images into data-mathml attribute.
        var html = host.editor.get('innerHTML');
        // Check if exist mathml tag for parse
        if(html.indexOf('math»') >= 0 || html.indexOf('math>') >= 0){
            host.textarea.set('value', wrs_endParse(html, null, this._lang, true));
        }
    },
    /**
     * Add buttons depending on configuration.
     */
    _addButtons: function() {
        if (window._wrs_conf_plugin_loaded) {
            if (window._wrs_conf_editorEnabled) {
                this.addButton({
                    title: 'wiris_editor_title',
                    buttonName: 'wiris_editor',
                    icon: 'formula',
                    iconComponent: 'atto_wiris',
                    callback: this._editorButton
                });
            }
            if (window[_wrs_int_customEditors.chemistry.confVariable]) {
                this.addButton({
                    title: 'wiris_chem_editor_title',
                    buttonName: 'wiris_chem_editor',
                    icon:'chem',
                    iconComponent: 'atto_wiris',
                    callback: this._chemEditorButton
                });
            }
            if (window._wrs_conf_CASEnabled) {
                this.addButton({
                    title: 'wiris_cas_title',
                    buttonName: 'wiris_cas',
                    icon: 'cas',
                    iconComponent: 'atto_wiris',
                    callback: this._casButton
                });
            }
            // We add the buton after the collapse plugin initially hide other
            // buttons. So we recall it here.
            var host = this.get('host');
            if (host.plugins.collapse) {
                host.plugins.collapse._setVisibility(host.plugins.collapse.buttons.collapse);
            }

        }
        else {
            Y.later(50, this, this._addButtons);
        }
    },
    /**
     * WIRIS editor button callback.
     **/
    _editorButton: function() {
        if (_wrs_int_popup) {
            _wrs_int_popup.focus();
        }
        else {
            var host = this.get('host');
            _wrs_int_currentPlugin = this;
            _wrs_int_popup = wrs_openEditorWindow(this._lang, host.editor.getDOMNode(), false);
        }
    },

    _chemEditorButton: function() {
        if (_wrs_int_popup) {
            _wrs_int_popup.focus();
        }
        else {
            var host = this.get('host');
            _wrs_int_currentPlugin = this;
            wrs_int_enableCustomEditor('chemistry');
            _wrs_int_popup = wrs_openEditorWindow(this._lang, host.editor.getDOMNode(), false);
        }
    },
    /**
     * WIRIS cas button callback.
     **/
    _casButton: function() {
        if (_wrs_int_popup) {
            _wrs_int_popup.focus();
        }
        else {
            var host = this.get('host');
            _wrs_int_currentPlugin = this;
            _wrs_int_popup = wrs_openCASWindow(host.editor.getDOMNode(), false, this._lang);
        }
    },
    /**
     * Converts all MathML from the editor html to img elements.
     * **/
    _parseContent: function() {
        if (window._wrs_conf_plugin_loaded) {
            var host = this.get('host');
            var html = host.editor.get('innerHTML');
            html = wrs_initParse(html, this._lang);
            host.editor.set('innerHTML', html);
            this.markUpdated();
            this._updateCasImgHandlers();
            this._updateEditorImgHandlers();
        }
        else {
            Y.later(50, this, this._parseContent);
        }
    },
    /**
     * Converts all img elements from the textarea I/O element to MathML.
     * */
    _unparseContent: function() {
        if (window._wrs_conf_plugin_loaded) {
            var host = this.get('host');
            var html = host.textarea.get('value');
            host.textarea.set('value', this._convertSafeMath(wrs_endParse(html, null, this._lang, true)));
        }
        else {
            Y.later(50, this, this._unparseContent);
        }
    },
    /**
     * Doubleclick event for Wiris images on editable div.
     */
    _handleElementDoubleclick: function(target, element, event){
        if (element.dataset.mathml) {
            event.stopPropagation();
            window._wrs_temporalImage = element;
            window._wrs_isNewElement = false;
            var customEditor = window._wrs_temporalImage.getAttribute('data-custom-editor');
            if (typeof(customEditor) != 'undefined' && customEditor){
                if (window[_wrs_int_customEditors[customEditor].confVariable]) {
                    wrs_int_enableCustomEditor(customEditor);
                }
            }

            window._wrs_int_editors_elements[target.id]._editorButton();
        }
    },
    /**
     * Doubleclick in img.Wiriscas handler
     * */
    _handleCasDoubleClick: function(e) {
        window._wrs_temporalImage = e.currentTarget.getDOMNode();
        window._wrs_isNewElement = false;
        this._casButton();
        e.stopPropagation();
    },
    /**
     * Reset event handlers for formula images.
     * **/
    _updateEditorImgHandlers: function() {
        // Add doubleclick event to editable div.
        wrs_addElementEvents(this.get('host').editor.getDOMNode(),this._handleElementDoubleclick);
        window._wrs_int_editors_elements[this.get("host").editor.getDOMNode().id] = this;
    },
    /**
     * Reset event handlers for cas images.
     * **/
    _updateCasImgHandlers: function() {
        this.editor.all('img.Wiriscas').each(function(img){
            img.detachAll('dblclick');
            img.on('dblclick', this._handleCasDoubleClick, this);
        }, this);
    },
    /**
     * This method only decode safe-mathml tags into normal mathml
     **/
    _convertSafeMath: function(content) {
        var output = '';
        var mathTagBegin = '«math';
        var mathTagEnd = '«/math»';
        var start = content.indexOf(mathTagBegin);
        var end = 0;

        while (start != -1) {
            output += content.substring(end, start);
            // Avoid WIRIS images to be parsed.
            imageMathmlAtrribute = content.indexOf(_wrs_conf_imageMathmlAttribute);
            end = content.indexOf(mathTagEnd, start);

            if (end == -1) {
                end = content.length - 1;
            } else if (imageMathmlAtrribute != -1) {
                // First close tag of img attribute
                // If a mathmlAttribute exists should be inside a img tag.
                end += content.indexOf("/>", start);
            }
            else {
                end += mathTagEnd.length;
            }

            if (!wrs_isMathmlInAttribute(content, start) && imageMathmlAtrribute == -1){
                var mathml = content.substring(start, end);
                output += wrs_mathmlDecode(mathml);
            }
            else {
                output += content.substring(start, end);
            }

            start = content.indexOf(mathTagBegin, end);
        }

        output += content.substring(end, content.length);
        return output;
    }
});


}, '@VERSION@', {"requires": ["moodle-editor_atto-plugin", "get"]});
