/**
 * Created by hayle on 2022-09-02.
 */

@IsTest
public with sharing class Lead_tr_test {

    @TestSetup
    static void testSetup(){
        Lead objLead = new Lead();
        objLead.LastName ='전혜인';
        objLead.Company ='혜인넥스티어';
        insert objLead;
    }

    @IsTest
    static void doTest(){
        Lead objLead = [
                SELECT Id,LastName, Phone
                FROM Lead
                WHERE LastName = '전혜인'
                LIMIT 1
        ];
        Test.startTest();
        objLead.Phone='0101111-2222';
        update objLead;
        Test.stopTest();
    }
}