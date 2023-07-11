/**
 * @description       : 
 *                      
 * @author            : hyein.jeon@daeunextier.com
 * @group             :
 * @last modified on  : 2023-06-01
 * @last modified by  : hyein.jeon@daeunextier.com
 * Modifications Log
 * Ver     Date             Author               Modification
 * 1.0   2023-06-01   hyein.jeon@daeunextier.com   Initial Version
 */

public with sharing class CaseCSOrderController {

    @AuraEnabled
    public static void getPartsOrderList(Id recordId) {

        List<Case> listCase = new List<Case>([
                SELECT      Id, AssetId
                FROM        Case
                WHERE       Id =: recordId
                LIMIT       1
        ]);

        List<Asset> listAsset = new List<Asset>([
                SELECT      Id
                FROM        Asset
                WHERE       Id =: listCase[0].Id
                LIMIT       1
        ]);

    }

}