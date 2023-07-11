/**
 * @description       : 
 *                      
 * @author            : hyein.jeon@daeunextier.com
 * @group             :
 * @last modified on  : 2023-05-26
 * @last modified by  : hyein.jeon@daeunextier.com
 * Modifications Log
 * Ver     Date             Author               Modification
 * 1.0   2023-05-26   hyein.jeon@daeunextier.com   Initial Version
 */

({

    handleOptionsChange : function(component, event, helper) {
        var productValue = component.get("v.productOrPartsValue");
        if (productValue == "product") {
            component.set("v.isProduct", true);
            component.set("v.isParts", false);
        } else {
            component.set("v.isProduct", false);
            component.set("v.isParts", true);
        }
    },

    handleOptionsChange2 : function(component, event, helper) {
        var productValue = component.get("v.productOrPartsValue");
        component.set("v.productOrPartsValue",  productValue);
    },

    fnNext : function(component, event, helper){
        component.set("v.isFirst", false);
        component.set("v.isSecond", true);

        console.log(">>>" + component.get("v.value"));

        if(component.get("v.value") == "partsorder"){
            component.set("v.isPartsorder", true);
            component.set("v.isReplacement", false);
            component.set("v.isReturn", false);
            component.set("v.isRepair", false);
        } else if(component.get("v.value") == "replacement"){
            component.set("v.isPartsorder", false);
            component.set("v.isReplacement", true);
            component.set("v.isReturn", false);
            component.set("v.isRepair", false);
        } else if(component.get("v.value") == "return"){
            component.set("v.isPartsorder", false);
            component.set("v.isReplacement", false);
            component.set("v.isReturn", true);
            component.set("v.isRepair", false);
        } else if(component.get("v.value") == "repair"){
            component.set("v.isPartsorder", false);
            component.set("v.isReplacement", false);
            component.set("v.isReturn", false);
            component.set("v.isRepair", true);
        } else {
            component.set("v.isFirst", true);
            component.set("v.isSecond", false);
            helper.showToast("error", "Select CS Order.");
        }
    },

    fnCancel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },

    fnSave: function (component, event, helper) {
//        helper.savePDF(component);
//        $A.get("e.force:closeQuickAction").fire();
        component.set("v.isSecond", false);
        component.set("v.isThird", true);
    },


});