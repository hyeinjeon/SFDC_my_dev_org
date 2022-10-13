({
    fnInit : function(component, event, helper) {
        console.log('classes', component.get("v.classes"));
        helper.getInitData(component);

        component.set('v.columns', [
            {label: 'Class Name', fieldName: 'className', type: 'text'}
        ]);
    },

    handleChange: function (component, event, helper) {
        var result = confirm('학급을 정말 이동하시겠습니까?');
        if(result) {
            helper.changeClass(component, event);
        }
    },

    handleKeyUp : function (cmp, event, helper) {
        alert('handleKeyUp:' + event.which);
        if (event.which == 13){
            alert('handleKeyUp: enter button');
        }
    },

    handleInput : function (cmp, event, helper) {
        var entersearch = cmp.get("{!v.classes}");
        var messageempty = (entersearch ===""?" empty":"") ;
        alert('handle Input: ' + entersearch + messageempty );
    },

    fnCancel : function(component, event, helper) {
        //취소 (창닫기)
        $A.get("e.force:closeQuickAction").fire();
    }

});
