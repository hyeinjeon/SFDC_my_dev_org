/**
 * @description       : 
 *                      
 * @author            : hyein.jeon@daeunextier.com
 * @group             :
 * @last modified on  : 2023-05-23
 * @last modified by  : hyein.jeon@daeunextier.com
 * Modifications Log
 * Ver     Date             Author               Modification
 * 1.0   2023-05-23   hyein.jeon@daeunextier.com   Initial Version
 */

public with sharing class CaseCSPlanItemListController {

    @AuraEnabled
    public static List<Product2> getRelatedEntries(Id recordId) {

        Case caseRecord = [
                SELECT Id, AssetId, Asset.Serial_Number__c
                FROM Case
                WHERE Id = :recordId
                LIMIT 1
        ];

        List<Product2> relatedProducts = new List<Product2>([
                SELECT Id, Name, ProductCode, Description
                FROM Product2
                WHERE Id IN (
                        SELECT Product__c
                        FROM ProductItem__c
                        WHERE Id = :caseRecord.Asset.Serial_Number__c
                )
        ]);

        return relatedProducts;

    }

}