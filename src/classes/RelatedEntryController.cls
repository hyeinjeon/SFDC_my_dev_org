/**
 * @description       : RelatedEntryController
 *
 * @author            : hyein.jeon@daeunextier.com
 * @group             :
 * @last modified on  : 2022-10-26
 * @last modified by  : hyein.jeon@daeunextier.com
 * Modifications Log
 * Ver     Date             Author                   Modification
 * 1.0   2022-10-26   hyein.jeon@daeunextier.com    Initial Version
 */

public class RelatedEntryController {
    @AuraEnabled
    public static List<PricebookEntry> getRelatedEntries(Id recordId){

        List<PricebookEntry> peList = new List<PricebookEntry>();

        List<Pricebook2> pbList = [
                SELECT Id
                FROM Pricebook2
                WHERE Id = :recordId
        ];

        Set<Id> pbIds = new Set<Id>();
        for (Pricebook2 pb : pbList) {
            pbIds.add(pb.Id);
        }

        peList = [
                SELECT Id, Name, ProductCode, UnitPrice, CreatedDate, Product2.Id
                FROM PricebookEntry
                WHERE Pricebook2Id IN :pbIds
        ];

        return peList;
    }


}