/**
 * Created by hayle on 2022-11-02.
 */

public with sharing class SearchStudentController {
    @AuraEnabled
    public static List <Contact> fetchContacts() {
        //Qyery Contacts
        List<Contact> listContact = [
                SELECT Id, Name,
                        Class__r.Grade__c,
                        Class__r.ClassNumber__c
                FROM Contact
        ];

        //return list of contacts
        return listContact;
    }

    @AuraEnabled
    public static List <Contact> searchContacts(String searchKeywordGrade, String searchKeywordClass, String searchKeywordName) {

        // Dynamic Query 사용
        String strQuery = '';
        strQuery += 'SELECT Id, Name, Class__r.Grade__c, Class__r.ClassNumber__c ';
        strQuery += 'FROM Contact ';
        strQuery += 'WHERE Id != Null ';

        if(searchKeywordGrade != '') {
            strQuery += 'AND Class__r.Grade__c = \'' + searchKeywordGrade + '\' ';
        }
        if(searchKeywordClass != '') {
            strQuery += 'AND Class__r.ClassNumber__c = \'' + searchKeywordClass + '\' ';
        }
        if(searchKeywordName != '') {
            strQuery += 'AND Name LIKE \'%' + searchKeywordName + '%\' ';
        }

        List<Contact> listContact;
        listContact = Database.query(strQuery);

        return listContact;

    }

}