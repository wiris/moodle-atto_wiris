YUI.add("moodle-atto_wiris-button",function(t,i){t.namespace("M.atto_wiris").Button=t.Base.create("button",t.M.editor_atto.EditorPlugin,[],{initializer:function(i){var e;i.filter_enabled&&(t.Get.js(M.cfg.wwwroot+"/lib/editor/atto/plugins/wiris/core.js?v="+i.version,function(t){t||(AttoIntegration=function(t){WirisPlugin.IntegrationModel.call(this,t),this.config=t.config},AttoIntegration.prototype=Object.create(WirisPlugin.IntegrationModel&&WirisPlugin.IntegrationModel.prototype),AttoIntegration.prototype.getPath=function(){return M.cfg.wwwroot+"/lib/editor/atto/plugins/wiris"},AttoIntegration.prototype.getLanguage=function(){return this.config.lang},AttoIntegration.prototype.doubleClickHandler=function(t,i){t.classList.contains("Wirisformula")&&(i.stopPropagation(),WirisPlugin.IntegrationModel.prototype.doubleClickHandler.call(this,t,i))},AttoIntegration.prototype.updateFormula=function(t){var i;WirisPlugin.IntegrationModel.prototype.updateFormula.call(this,t),t=(i=this.editorObject.get("host")).textarea.get("value"),t=this.convertSafeMathml(WirisPlugin.Parser.endParse(t,null,this.config.lang,!0)),i.textarea.set("value",t),this.editorObject.markUpdated()},AttoIntegration.prototype.callbackFunction=function(){WirisPlugin.IntegrationModel.prototype.callbackFunction.call(this),this.parseContent();var t=this.editorObject.get("host").textarea.ancestor("form");t&&t.on("submit",this.submit,this)},AttoIntegration.prototype.parseContent=function(){var t=this.editorObject.get("host"),i=t.editor.get("innerHTML"),i=WirisPlugin.Parser.initParse(i,this.config.lang);t.editor.set("innerHTML",i),this.editorObject.markUpdated()},AttoIntegration.prototype.unParseContent=function(){var t=this.editorObject.get("host"),i=t.textarea.get("value"),i=this.convertSafeMathml(WirisPlugin.Parser.endParse(i,null,this.config.lang,!0));t.textarea.set("value",i)},AttoIntegration.prototype.submit=function(){var t=this.editorObject.get("host"),i=t.editor.get("innerHTML");(0<=i.indexOf("math»")||0<=i.indexOf("math>"))&&t.textarea.set("value",WirisPlugin.Parser.endParse(i,null,this.config.lang,!0))},AttoIntegration.prototype.convertSafeMathml=function(t){for(var i,e="",n="«math",r="«/math»",o=t.indexOf(n),a=0;-1!=o;)e+=t.substring(a,o),imageMathmlAttribute=t.indexOf(WirisPlugin.Configuration.get("imageMathmlAttribute")),-1==(a=t.indexOf(r,o))?a=t.length-1:-1!=imageMathmlAttribute?a+=t.indexOf("/>",o):a+=r.length,WirisPlugin.MathML.isMathmlInAttribute(t,o)||-1!=imageMathmlAttribute?e+=t.substring(o,a):(i=t.substring(o,a),e+=WirisPlugin.MathML.safeXmlDecode(i)),o=t.indexOf(n,a);return e+=t.substring(a,t.length)},(t={}).configurationService=M.cfg.wwwroot+"/filter/wiris/integration/configurationjs.php",t.editorObject=this,t.target=this.get("host").editor.getDOMNode(),t.scriptName="",t.config=i,(t=new AttoIntegration(t)).init(),t.listeners.fire("onTargetReady",{}),WirisPlugin.currentInstance=t)}.bind(this)),this._addButtons(i),(e=this.get("host")).on("atto:selectionchanged",function(t){"undefined"==typeof t.event&&(t=e.editor.get("innerHTML"),t=WirisPlugin.Parser.initParse(t,WirisPlugin.currentInstance.config.lang),e.editor.set("innerHTML",t))}),e._wirisUpdateFromTextArea=e.updateFromTextArea,e.updateFromTextArea=function(){e._wirisUpdateFromTextArea();var t=e.editor.get("innerHTML"),t=WirisPlugin.Parser.initParse(t,WirisPlugin.currentInstance.config.lang);e.editor.set("innerHTML",t)},e._wirisupdateOriginal=e.updateOriginal,e.updateOriginal=function(){var t;e._wirisupdateOriginal(),t=e.textarea.get("value"),t=WirisPlugin.Parser.endParse(t),t=_convertSafeMathML(t),e.textarea.set("value",t)},_convertSafeMathML=function(t){for(var i,e="",n="«math",r="«/math»",o=t.indexOf(n),a=0;-1!=o;)e+=t.substring(a,o),imageMathmlAttribute=t.indexOf(WirisPlugin.Configuration.get("imageMathmlAttribute")),-1==(a=t.indexOf(r,o))?a=t.length-1:-1!=imageMathmlAttribute?a+=t.indexOf("/>",o):a+=r.length,WirisPlugin.MathML.isMathmlInAttribute(t,o)||-1!=imageMathmlAttribute?e+=t.substring(o,a):(i=t.substring(o,a),e+=WirisPlugin.MathML.safeXmlDecode(i)),o=t.indexOf(n,a);return e+=t.substring(a,t.length)})},_addButtons:function(t){parseInt(t.editor_is_active)&&this.addButton({title:"wiris_editor_title",buttonName:"wiris_editor",icon:"formula",iconComponent:"atto_wiris",callback:this._editorButton}),parseInt(t.chemistry_is_active)&&this.addButton({title:"wiris_chem_editor_title",buttonName:"wiris_chem_editor",icon:"chem",iconComponent:"atto_wiris",callback:this._chemButton});t=this.get("host");t.plugins.collapse&&t.plugins.collapse._setVisibility(t.plugins.collapse.buttons.collapse)},_editorButton:function(){WirisPlugin.currentInstance.editorObject=this,WirisPlugin.currentInstance.setTarget(this.get("host").editor.getDOMNode()),WirisPlugin.currentInstance.core.getCustomEditors().disable(),WirisPlugin.currentInstance.openNewFormulaEditor()},_chemButton:function(){WirisPlugin.currentInstance.editorObject=this,WirisPlugin.currentInstance.setTarget(this.get("host").editor.getDOMNode()),WirisPlugin.currentInstance.getCore().getCustomEditors().enable("chemistry"),WirisPlugin.currentInstance.openNewFormulaEditor()}})},"@VERSION@",{requires:["moodle-editor_atto-plugin","get"]});