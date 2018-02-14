YUI.add("moodle-atto_wiris-button",function(e,t){e.namespace("M.atto_wiris").Button=e.Base.create("button",e.M.editor_atto.EditorPlugin,[],{_lang:"en",initializer:function(t){if(!t.filter_enabled)return;this._lang=t.lang,window._wrs_int_langCode=t.lang,window._wrs_plugin_version=t.version,window.wrs_int_notifyWindowClosed=function(){window._wrs_int_popup=null,window._wrs_temporalImage=null,window._wrs_isNewElement=!0},window.wrs_int_updateFormula=function(e,t){var n=window._wrs_int_currentPlugin.get("host").editor.getDOMNode();wrs_updateFormula(n,window,e,null,t,_wrs_int_currentPlugin._lang),window._wrs_int_currentPlugin.markUpdated(),window._wrs_int_currentPlugin._updateEditorImgHandlers()},window.wrs_int_updateCAS=function(e,t,n,r){var i=window._wrs_int_currentPlugin.get("host").editor.getDOMNode();wrs_updateCAS(i,window,e,t,n,r),window._wrs_int_currentPlugin.markUpdated(),window._wrs_int_currentPlugin._updateCasImgHandlers()},window._wrs_int_conf_file=M.cfg.wwwroot+"/filter/wiris/integration/configurationjs.php",window._wrs_int_conf_path=M.cfg.wwwroot+"/lib/editor/atto/plugins/wiris",window._wrs_int_conf_async=!0,window._wrs_int_popup=window._wrs_int_popup||null,window._wrs_int_coreLoading=window._wrs_int_coreLoading||!1,window._wrs_int_path=window._wrs_int_conf_file.split("/"),window._wrs_int_path.pop(),window._wrs_int_path=window._wrs_int_path.join("/");var n=window._wrs_int_path.indexOf("/")===0||window._wrs_int_path.indexOf("http");window._wrs_int_path=n?window._wrs_int_path:window._wrs_int_conf_path+"/"+window._wrs_int_path,window._wrs_isMoodle24=!0,window._wrs_int_customEditors={chemistry:{name:"Chemistry",toolbar:"chemistry",icon:"chem.gif",enabled:!1,confVariable:"_wrs_conf_chemEnabled",title:"WIRIS EDITOR chemistry"}},window._wrs_int_coreLoading||(window._wrs_int_coreLoading=!0,e.Get.js(window._wrs_int_conf_path+"/core/core.js?v="+t.version,function(e){e}));var r=this.get("host"),i=this;window._wrs_int_currentPlugin=this;var s=typeof window._wrs_int_editors_elements=="undefined";window._wrs_int_editors_elements=s?{}:window._wrs_int_editors_elements,r.on("change",function(){i._unparseContent()}),r._wirisUpdateFromTextArea=r.updateFromTextArea,r.updateFromTextArea=function(){r._wirisUpdateFromTextArea(),i._parseContent()},this._parseContent(),this._addButtons();var o=r.textarea.ancestor("form");o&&o.on("submit",this._submitClean,this)},_submitClean:function(){var e=this.get("host"),t=e.editor.get("innerHTML");(t.indexOf("math\u00bb")>=0||t.indexOf("math>")>=0)&&e.textarea.set("value",wrs_endParse(t,null,this._lang,!0))},_addButtons:function(){if(window._wrs_conf_plugin_loaded){window._wrs_conf_editorEnabled&&this.addButton({title:"wiris_editor_title",buttonName:"wiris_editor",icon:"formula",iconComponent:"atto_wiris",callback:this._editorButton}),window[_wrs_int_customEditors.chemistry.confVariable]&&this.addButton({title:"wiris_chem_editor_title",buttonName:"wiris_chem_editor",icon:"chem",iconComponent:"atto_wiris",callback:this._chemEditorButton}),window._wrs_conf_CASEnabled&&this.addButton({title:"wiris_cas_title",buttonName:"wiris_cas",icon:"cas",iconComponent:"atto_wiris",callback:this._casButton});var t=this.get("host");t.plugins.collapse&&t.plugins.collapse._setVisibility(t.plugins.collapse.buttons.collapse)}else e.later(50,this,this._addButtons)},_editorButton:function(){if(_wrs_int_popup)_wrs_int_popup.focus();else{var e=this.get("host");_wrs_int_currentPlugin=this,_wrs_int_popup=wrs_openEditorWindow(this._lang,e.editor.getDOMNode(),!1)}},_chemEditorButton:function(){if(_wrs_int_popup)_wrs_int_popup.focus();else{var e=this.get("host");_wrs_int_currentPlugin=this,wrs_int_enableCustomEditor("chemistry"),_wrs_int_popup=wrs_openEditorWindow(this._lang,e.editor.getDOMNode(),!1)}},_casButton:function(){if(_wrs_int_popup)_wrs_int_popup.focus();else{var e=this.get("host");_wrs_int_currentPlugin=this,_wrs_int_popup=wrs_openCASWindow(e.editor.getDOMNode(),!1,this._lang)}},_parseContent:function(){if(window._wrs_conf_plugin_loaded){var t=this.get("host"),n=t.editor.get("innerHTML");n=wrs_initParse(n,this._lang),t.editor.set("innerHTML",n),this.markUpdated(),this._updateCasImgHandlers(),this._updateEditorImgHandlers()}else e.later(50,this,this._parseContent)},_unparseContent:function(){if(window._wrs_conf_plugin_loaded){var t=this.get("host"),n=t.textarea.get("value");t.textarea.set("value",this._convertSafeMath(wrs_endParse(n,null,this._lang,!0)))}else e.later(50,this,this._unparseContent)},_handleElementDoubleclick:function(e,t,n){if(t.dataset.mathml){n.stopPropagation(),window._wrs_temporalImage=t,window._wrs_isNewElement=!1;var r=window._wrs_temporalImage.getAttribute("data-custom-editor");typeof r!="undefined"&&r&&window[_wrs_int_customEditors[r].confVariable]&&wrs_int_enableCustomEditor(r),window._wrs_int_editors_elements[e.id]._editorButton()}},_handleCasDoubleClick:function(e){window._wrs_temporalImage=e.currentTarget.getDOMNode(),window._wrs_isNewElement=!1,this._casButton(),e.stopPropagation()},_updateEditorImgHandlers:function(){wrs_addElementEvents(this.get("host").editor.getDOMNode(),this._handleElementDoubleclick),window._wrs_int_editors_elements[this.get("host").editor.getDOMNode().id]=this},_updateCasImgHandlers:function(){this.editor.all("img.Wiriscas").each(function(e){e.detachAll("dblclick"),e.on("dblclick",this._handleCasDoubleClick,this)},this)},_convertSafeMath:function(e){var t="",n="\u00abmath",r="\u00ab/math\u00bb",i=e.indexOf(n),s=0;while(i!=-1){t+=e.substring(s,i),imageMathmlAtrribute=e.indexOf(_wrs_conf_imageMathmlAttribute),s=e.indexOf(r,i),s==-1?s=e.length-1:imageMathmlAtrribute!=-1?s+=e.indexOf("/>",i):s+=r.length;if(!wrs_isMathmlInAttribute(e,i)&&imageMathmlAtrribute==-1){var o=e.substring(i,s);t+=wrs_mathmlDecode(o)}else t+=e.substring(i,s);i=e.indexOf(n,s)}return t+=e.substring(s,e.length),t}})},"@VERSION@",{requires:["moodle-editor_atto-plugin","get"]});
