
public with sharing class MoveStudentClassController {
    @AuraEnabled
    public static List<Map<String, String>> getInitData() {

        // 학급을 학년과 반 순서대로 가져온다.
        List<Class__c> listClass = [
                SELECT Name
                FROM Class__c
                ORDER BY Grade__c, ClassNumber__c
        ];

        List<Map<String, String>> listReturn = new List<Map<String, String>>();
        if (!listClass.isEmpty()) {
            Map<String, String> mapValues = new Map<String, String>();

            for (Class__c obj : listClass) {
                if (!mapValues.isEmpty()) mapValues = new Map<String, String>();
                mapValues.put('label', obj.Name); // 1학년 1반
                mapValues.put('value', obj.Name); // 1학년 1반
                listReturn.add(mapValues);  // 리스트의 map으로 변경해야함
            }
        }

        return listReturn;
    }

    @AuraEnabled
    public static Boolean changeClass(String className, String recordId) {
        System.debug('className : ' + className);
        // 학급을 바꿔줄 Contact를 가져온다.
        List<Contact> listContact = [
                SELECT Class__r.Grade__c
                FROM Contact
                WHERE Id = :recordId
                LIMIT 1
        ];

        // 선택된 학급을 가져온다.
        List<Class__c> listClass = [
                SELECT Id, Grade__c
                FROM Class__c
                WHERE Name = :className
                LIMIT 1
        ];

        // '선택된 학급의 학년'과 '선택된 Contact의 학년'이 같은지 비교한다.
        if (listClass[0].Grade__c != listContact[0].Class__r.Grade__c) { // 학년이 같지 않다면, false
            return false;
        } else {    // 학년이 같다면, update 후, true 반환
            listContact[0].Class__c = listClass[0].Id;
            update listContact;
        }

        return true;
    }
}