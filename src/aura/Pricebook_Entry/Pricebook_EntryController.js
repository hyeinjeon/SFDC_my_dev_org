/**
 * @description       : Pricebook_EntryController
 *
 * @author            : hyein.jeon@daeunextier.com
 * @group             :
 * @last modified on  : 2022-10-26
 * @last modified by  : hyein.jeon@daeunextier.com
 * Modifications Log
 * Ver     Date             Author                   Modification
 * 1.0   2022-10-26   hyein.jeon@daeunextier.com    Initial Version
 */

({
    //Get Related Docs
    fnInit : function(component, event, helper) {
        helper.getRelatedEntry(component, event);
    },

    fnViewClick : function(component, event, helper) {
        var recordId = event.currentTarget.getAttribute("data-Id");
        var url ="/lightning/r/Product2/" + recordId + "/view";
        window.parent.location = url;
    },

    fnNewClick : function(component, event, helper) {
        helper.addProducts(component, event);
    },

});