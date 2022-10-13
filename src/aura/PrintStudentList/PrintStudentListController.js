/*
    <Controller>
        - JavaScript 구현 및 Component의 Event 처리
*/

({
    fnInit : function(component, event, helper){
        component.set("v.vfPageUrl" , "/apex/PrintStudentList2?recordId=" + component.get("v.recordId"));
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