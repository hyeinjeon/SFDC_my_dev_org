/**
 * Created by hyein on 2022-10-18.
     <Controller>
         - JavaScript 구현 및 Component의 Event 처리
*/

({
    fnInit : function(component, event, helper) {
        helper.init(component, event, helper);
    },

    fnErase : function(component, event, helper){
        helper.erase(component, event, helper);
    },

    fnSave : function(component, event, helper){
        console.log('fnSave before doSave');
        helper.doSave(component, event, helper);
        console.log('fnSave after doSave');
        // 저장 후 창닫기
        $A.get("e.force:closeQuickAction").fire();
        // 새로고침
        $A.get("e.force:refreshView").fire();
    },

    fnCancel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },

});