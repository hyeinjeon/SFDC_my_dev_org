/**
 * Created by hayle on 2022-10-14.
 */

@IsTest
public with sharing class ContactEmail_ba_test {

    @TestSetup
    public static void testSetup(){
        Contact objContact = new Contact();
        objContact.LastName = 'Hello~';
        objContact.Email = 'hyein.jeon@daeunextier.com';
        objContact.Description = 'Hello This is Test Description for Contact';
        insert objContact;
    }

    @IsTest
    static void doTest(){
        Test.startTest();

        ContactEmail_ba batch1 = new ContactEmail_ba();
        DataBase.executeBatch(batch1);

        Test.stopTest();

    }

}