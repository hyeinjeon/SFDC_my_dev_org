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
        var searchField = component.find('searchField');
        helper.SearchHelper(component, event);
        console.log('Search Controller finish');
    },

});