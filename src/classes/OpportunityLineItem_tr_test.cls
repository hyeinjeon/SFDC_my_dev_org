/**
 * Created by hyein on 2022-08-29.
 */
@IsTest
public with sharing class OpportunityLineItem_tr_test {
    @TestSetup
    public static void testSetup(){
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
        objOLI.TotalPrice = 10101;
        insert objOLI;
    }

    @IsTest
    static void doTest(){
        OpportunityLineItem objOLI = [
                SELECT Id, Quantity
                FROM OpportunityLineItem
                WHERE Quantity =: 21
                        AND TotalPrice =: 10101
                        AND Product2Id =: '01t5i000002ukVzAAI'
                        AND PricebookEntryId =: '01u5i000002vmpBAAQ'
                LIMIT 1
        ];
        Test.startTest();
        objOLI.Quantity = 2121;
        update objOLI;
        Test.stopTest();

    }
}