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
        var canvas = component.find('canvas').getElement();
        var isCanvasEmpty = helper.isCanvasEmpty(canvas);
        if (isCanvasEmpty){
            alert('Please enter signature!');
        } else {
            alert('Thank you!');
            helper.doSave(component, event, helper);
        }

        // 아래 코드 쓰면 setcallback() 함수 안돌아감.
        // setcallback은 백단코드라서 큐에 담긴 프론트코드 먼저 일괄처리돼서 안돌아감.
        // 저장 후 창닫기
        // $A.get("e.force:closeQuickAction").fire();
        // 새로고침
        // $A.get("e.force:refreshView").fire();
    },

    fnCancel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },

});