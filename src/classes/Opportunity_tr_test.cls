/**
 * Created by hayle on 2022-08-29.
 */

@IsTest
public with sharing class Opportunity_tr_test {

    // the testing framework executes the test setup method first, before any test method in the class.
    @TestSetup
    static void testSetup() {
        Opportunity objOppty = new Opportunity();
        objOppty.Name = 'Test_Oppty_Hyein';
        objOppty.Description = 'Hello This is Test Description';
        objOppty.StageName = 'Prospecting';
        objOppty.CloseDate = Date.today();
        insert objOppty;

        OpportunityLineItem objOLI = new OpportunityLineItem();
        objOLI.PricebookEntryId = '01u5i000002vmpBAAQ';
        objOLI.Quantity = 21;
        objOLI.Product2Id = '01t5i000002ukVzAAI';
        objOLI.OpportunityId = objOppty.Id;
        objOLI.TotalPrice = 1000;
        insert objOLI;
    }

    @IsTest
    static void doTest() {
        Opportunity objOppty = [
                SELECT Id, StageName
                FROM Opportunity
                WHERE Name = 'Test_Oppty_Hyein'
                LIMIT 1
        ];
        Test.startTest();
        objOppty.StageName = 'Negotiation/Review';
        update objOppty;
        Test.stopTest();
    }

}