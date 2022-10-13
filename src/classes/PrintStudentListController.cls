
public with sharing class PrintStudentListController {
    public String recordId { get; set; }
    public List<Contact> listContact { get; set; }

    public PrintStudentListController() {
        //url속 파라미터를 가져오는 코드    // 해당 학급의 Id
        recordId = ApexPages.currentPage().GetParameters().get('recordId');
        //Contact 조회쿼리
        listContact = [
                SELECT  LastName, Birthdate
                FROM    Contact
                WHERE   Class__c =: recordId
        ];
    }
}