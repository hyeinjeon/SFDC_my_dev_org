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

    fnInit : function(component, event, helper){
        component.set("v.vfPageUrl" , "/apex/CaseQCReport?recordId=" + component.get("v.recordId"));
    },

    fnCancel : function(component, event, helper){
        //취소(창닫기)
        $A.get("e.force:closeQuickAction").fire();
    },

    fnSave: function (component, event, helper) {
        helper.savePDF(component);
        // 저장 후 창닫기
        $A.get("e.force:closeQuickAction").fire();
        // 새로고침
        $A.get("e.force:refreshView").fire();
    }

});