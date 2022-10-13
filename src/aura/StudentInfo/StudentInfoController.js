({
    fnInit : function(component, event, helper) {
        //recordId 로그를 찍어 확인해보기
        //helper로 이동 시키기
        console.log('recordId', component.get("v.recordId"));
        helper.getInitData(component);  // 정보 가져오기.. helper로 넘기기
    }
});