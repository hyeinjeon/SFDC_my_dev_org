/**
 * Created by hayle on 2022-11-02.
 */

({
    fnInit : function(component, event, helper){
        component.set('v.ListColumns', [
            {label: '학생정보', fieldName: 'linkName', type: 'url',
                typeAttributes: {label: { fieldName: 'Id' }, target: '_blank'}},
            {label: '학년', fieldName: 'Grade', type: 'text'},
            {label: '반', fieldName: 'ClassNumber', type: 'text'},
            {label: '이름', fieldName: 'Name', type: 'text'},
        ]);

        helper.getInitData(component, event, helper);
    },

    Search : function(component, event, helper){
        console.log('Search Controller start');

        console.log('1-searchKeywordGrade: ' + component.get("v.searchKeywordGrade"));
        console.log('1-searchKeywordClass: ' + component.get("v.searchKeywordClass"));
        console.log('1-searchKeywordName: ' + component.get("v.searchKeywordName"));

        // Controller에서 Search Keyword null인지 아닌지 구분해주기.
        // 3개다 null 일 경우만 toast 메세지 띄워주고, 3중에 하나라도 적혀있으면 검색해주기
        if(component.get("v.searchKeywordGrade") == "" &&
           component.get("v.searchKeywordClass") == "" &&
           component.get("v.searchKeywordName")  == "" ) {
               console.log('No SearchKeyWord - all');
               helper.showToast('ERROR', "Please Enter Keywords.");
        } else {
            helper.SearchHelper(component, event);
        }

        console.log('Search Controller finish');
    },


});