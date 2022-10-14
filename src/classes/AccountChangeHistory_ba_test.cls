/**
 * Created by hayle on 2022-10-14.
 */

@IsTest
public with sharing class AccountChangeHistory_ba_test {

    @TestSetup
    public static void testSetup(){
        Account objAccount = new Account();
        objAccount.Name = 'Test_Account_Hyein';
        objAccount.Description = 'Hello This is Test Description for Account';
        insert objAccount;


    }

    @IsTest
    static void doTest(){
        Test.startTest();

        AccountChangeHistory_ba batch1 = new AccountChangeHistory_ba();
        DataBase.executeBatch(batch1);

        Test.stopTest();

    }

}