/**
 * @description       : 
 *                      
 * @author            : hyein.jeon@daeunextier.com
 * @group             :
 * @last modified on  : 2022-12-16
 * @last modified by  : hyein.jeon@daeunextier.com
 * Modifications Log
 * Ver     Date             Author               Modification
 * 1.0   2022-12-16   hyein.jeon@daeunextier.com   Initial Version
 */

({
    getRelatedOppty : function(component, event) {
        var action = component.get("c.getRelatedOppty");
        action.setParams({
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set('v.listOppty', response.getReturnValue());

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