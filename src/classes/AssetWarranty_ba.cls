/**
 * @description       : Asset의 Warranty Date의 30일 전에 보증기간 관련 Case를 생성
 *
 * @author            : hyein.jeon@daeunextier.com
 * @group             :
 * @last modified on  : 2022-10-17
 * @last modified by  : hyein.jeon@daeunextier.com
 * Modifications Log
 * Ver     Date             Author                   Modification
 * 1.0   2022-10-17   hyein.jeon@daeunextier.com    Initial Version
 */

public with sharing class AssetWarranty_ba implements Database.Batchable<sObject>, Database.Stateful {

    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = '';
        query += 'SELECT    Id, WarrantyDate__c, Name, CaseForWarranty__c ';
        query += 'FROM      Asset';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Asset> listAsset) {
        List<Case> listCase = new List<Case>();

        for(Asset objAsset : listAsset) {
            Date today = Date.today();
            Date warrantyDate = objAsset.WarrantyDate__c != null ? objAsset.WarrantyDate__c : null;

            if(objAsset.WarrantyDate__c != null) {
                Integer dayDiff = today.daysBetween(warrantyDate);
                if (dayDiff <= 30 && dayDiff >= 0 && !objAsset.CaseForWarranty__c) {
                    Case objCase = new Case();
                    objCase.Status = 'New';
                    objCase.Origin = 'Email';
                    objCase.Subject = '5-보증기간 알림 for ' + objAsset.Name;
                    objCase.Description = '보증기간이 30일 남았습니다.' + ' / dayDiff : ' + dayDiff;
                    objAsset.CaseForWarranty__c = true;
                    listCase.add(objCase);
                }
            }
        }

        if(!listAsset.isEmpty()) {
            update listAsset;
        }

        try {
            if(!listCase.isEmpty()) {
                insert listCase;
            }
        } catch(Exception e) {
            System.debug(e);
        }
    }

    public void finish(Database.BatchableContext BC) {

    }
}