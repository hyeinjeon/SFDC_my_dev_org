/**
 * Created by hayle on 2022-11-02.
 */

public with sharing class SearchStudentController {
    @AuraEnabled
    public static List <Contact> fetchContacts() {
        //Qyery Contacts
        List<Contact> listContact = [
                SELECT  Id, Name,
                        Class__r.Grade__c,
                        Class__r.ClassNumber__c
                FROM    Contact
        ];

        //return list of contacts
        return listContact;
    }

    @AuraEnabled
    public static List <Contact> searchContacts(String searchKeywordGrade, String searchKeywordClass, String searchKeywordName) {

        System.debug('searchGrade: '+ searchKeywordGrade);
        System.debug('searchClass: '+ searchKeywordClass);
        System.debug('searchName: '+ searchKeywordName);

        String searchGrade = searchKeywordGrade;
        String searchClass = searchKeywordClass;
        String searchName =  '%' + searchKeywordName + '%';

        //Qyery Contacts
        List<Contact> listContact = [
                SELECT  Id, Name,
                        Class__r.Grade__c,
                        Class__r.ClassNumber__c
                FROM    Contact
                WHERE   Name LIKE: searchName
                AND     Class__r.Grade__c =: searchGrade
                AND     Class__r.ClassNumber__c =: searchClass
        ];

        System.debug('listContact: '+ listContact);

        //return list of contacts
        return listContact;
    }

}