/**
 * @description       : 
 *                      
 * @author            : hyein.jeon@daeunextier.com
 * @group             :
 * @last modified on  : 2022-12-16
 * @last modified by  : hyein.jeon@daeunextier.com
 * Modifications Log
 * Ver     Date             Author               Modification
 * 1.0   2022-12-16   hyein.jeon@daeunextier.com   Initial Version
 */

public with sharing class ForecastController {

    @AuraEnabled
    public static List<Opportunity> getRelatedOppty(){

        List<Opportunity> listOppty = new List<Opportunity>([
                SELECT Id, CloseDate, StageName, Amount //SUM(Amount) s, 이게 왜 안될까... 우케하는겨..
                FROM Opportunity
                WHERE StageName = 'Closed Won'
        ]);

        return listOppty;
    }


}