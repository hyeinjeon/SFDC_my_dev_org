/**
 * @description       : 
 *                      
 * @author            : hyein.jeon@daeunextier.com
 * @group             :
 * @last modified on  : 2023-05-04
 * @last modified by  : hyein.jeon@daeunextier.com
 * Modifications Log
 * Ver     Date             Author               Modification
 * 1.0   2023-05-04   hyein.jeon@daeunextier.com   Initial Version
 */

({

    savePDF: function (component) {
        var action = component.get("c.GenerateQCReportPDF");
        action.setParams({"recordId":component.get("v.recordId")});

        action.setCallback(this, function(response) {
            var state = response.getState();

            if(state === "SUCCESS" && component.isValid()) {
                var data = response.getReturnValue();
            } else if(state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        this.showToast('ERROR', errors[0].message);
                    }
                } else {
                    this.showToast("error", "Unknown error");
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    },

    showToast : function(type, message) {
            var evt = $A.get("e.force:showToast");
            evt.setParams({
                key : "info_alt"
                , type : type
                , message : message
            });
            evt.fire();
    }

});