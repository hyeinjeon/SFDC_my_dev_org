/**
 * Created by hayle on 2022-11-02.
 */

({
    getInitData : function(component, event, helper){
        // Controller 이용해서 조회조건으로 필터해서 불러온 Contact을 여기서 데이터 set 해줌
        var action = component.get("c.fetchContacts");
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue();     //storing the response in a temporary variable
                rows.forEach(function(record){
                    record.linkName = '/' + record.Id;
                });
                //looping through each row of the result
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    //as data columns with relationship __r can not be displayed directly in data table, so generating dynamic columns
                    if (row.Class__r) {
                        //here you assign the related data to new variables
                        row.Grade = row.Class__r.Grade__c;
                        row.ClassNumber = row.Class__r.ClassNumber__c;
                    }
                }
                component.set("v.ListContact", rows);
            }
        });
        $A.enqueueAction(action);
    },

    SearchHelper: function(component, event) {
        console.log('Search Helper start');
        var action = component.get("c.searchContacts");

        console.log('searchKeywordGrade: ' + component.get("v.searchKeywordGrade"));
        console.log('searchKeywordClass: ' + component.get("v.searchKeywordClass"));
        console.log('searchKeywordName: ' + component.get("v.searchKeywordName"));

        action.setParams({
            'searchKeywordGrade': component.get("v.searchKeywordGrade"),
            'searchKeywordClass': component.get("v.searchKeywordClass"),
            'searchKeywordName': component.get("v.searchKeywordName"),
        });

        action.setCallback(this, function(response) {
            console.log('setCallback start');
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('state === SUCCESS');
                var storeResponse = response.getReturnValue();
                // if storeResponse size is 0 ,display no record found message on screen.
                if (storeResponse.length == 0) {
                    this.showToast('ERROR', "There is no data.");
                    console.log('storeResponse.length == 0');
                } else {
                    console.log('storeResponse.length != 0');
                }

                for (var i = 0; i < storeResponse.length; i++) {
                    var row = storeResponse[i];
                    //as data columns with relationship __r can not be displayed directly in data table, so generating dynamic columns
                    if (row.Class__r) {
                        //here you assign the related data to new variables
                        row.Grade = row.Class__r.Grade__c;
                        row.ClassNumber = row.Class__r.ClassNumber__c;
                    }
                }
                component.set("v.ListContact", storeResponse);
            } else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + errors[0].message);
                    }
                } else {
                    alert("Unknown error");
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