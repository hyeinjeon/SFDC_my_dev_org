/**
 * @description       : 
 *                      
 * @author            : hyein.jeon@daeunextier.com
 * @group             :
 * @last modified on  : 2023-05-23
 * @last modified by  : hyein.jeon@daeunextier.com
 * Modifications Log
 * Ver     Date             Author               Modification
 * 1.0   2023-05-23   hyein.jeon@daeunextier.com   Initial Version
 */

({
    getRelatedEntry : function(component, event) {
        var action = component.get("c.getRelatedEntries");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set('v.cdList', response.getReturnValue());

                if(response.getReturnValue().length == 0) {
                    component.set('v.IsEmpty', true);
                } else {
                    component.set('v.IsEmpty', false);
                }
            }else if(state === "INCOMPLETE") {
                console.log("INCOMPLETE");
            }else if(state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

});