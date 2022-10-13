({
    getInitData : function(component) {
            // apexController.함수명 으로 데이터 가져옴
            var action = component.get("c.getInitData");

            action.setParams({
                // component에서 name이 classes인 aura:attribute 값을 가져와서 apexController로 넘겨줌
                classes : component.get("v.classes")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    var returnValue = response.getReturnValue();
                    console.log(returnValue);
                    // 이거는 Controller를 통해 Component로 넘겨주려고 셋팅
                    component.set("v.classes", returnValue);
                } else if(state === "ERROR") {
                    var errors = response.getError();
                    if(errors) {
                        //에러가 났을경우는 주로 ShowToast 함수를 이용하여 토스트 메시지를 띄움
                        if(errors[0] && errors[0].message) this.showToast("error", errors[0].message);
                    } else {
                        this.showToast("error", "Unknown error");
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
    },

    changeClass : function(component, event) {
             // apexController.함수명 으로 데이터 가져옴
             var action = component.get("c.changeClass");

             // action.setParams() - 서버 측 컨트롤러에 전달할 데이터를 설정한다.
             action.setParams({
                // component에서 name이 classes인 aura:attribute 값을 가져와서 apexController로 넘겨줌
                className : component.get("v.selectedClass"),
                recordId : component.get("v.recordId")
             });
             // action.setCallback(this, function(response) {...});
             // 서버측 작업이 반환된 후 호출되는 콜백 작업을 설정한다.
             action.setCallback(this, function(response) {
                // response.getState() : 서버에서 반환된 작업의 상태를 가져온다.
                var state = response.getState();
                 if(state === "SUCCESS") {
                     // response.getReturnValue() - Apex 작업의 반환 값을 가져온다.
                     // apexController의 changeClass의 return 값 (true/false)
                     var returnValue = response.getReturnValue();

                     if(!returnValue){  // false
                         this.showToast("Error", "타 학년으로 이동 불가");
                     } else {   // true
                         this.showToast("Success", "반 이동 성공");
                     }
                 } else if(state === "ERROR") {
                      // getError() - 서버측 작업에 대해서만 오류 개체의 배열을 반환한다.
                      var errors = response.getError();
                      console.log(errors);
                       if(errors) {
                           //에러가 났을경우는 주로 ShowToast 함수를 이용하여 토스트 메시지를 띄움
                           if(errors[0] && errors[0].message) this.showToast("error", errors[0].message);
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