/**
 * @description       :
 * @author            : admin@vatech.com.dev
 * @group             :
 * @last modified on  : 2022-05-18
 * @last modified by  : admin@vatech.com.dev
**/
global without sharing class MIG_AccountShare_ba implements Database.Batchable<sObject>, Database.Stateful {

    global String strAccountType;
    global Boolean isPartner;

    global MIG_AccountShare_ba(String strAccountType, Boolean isPartner) {
        this.strAccountType = strAccountType;
        this.isPartner = isPartner;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String strQuery = '';

        strQuery += '   SELECT  Id, IsPartner,';
        strQuery += '           MIG_KEY__c, AssignedOrganization__c, AssignedOrganization__r.IsPartner, ParentId';
        strQuery += '   FROM    Account';
        //strQuery += '   WHERE   MIG_KEY__c != null';
        //strQuery += '   WHERE   AssignedOrganization__c != null';

        if(strAccountType == 'Hospital') {
            strQuery += '   WHERE   RecordType.DeveloperName = \'Hospital\'';

            if(isPartner) {
                strQuery += '   AND   AssignedOrganization__r.IsPartner = true';
            }
        }else {
            strQuery += '   WHERE   (RecordType.DeveloperName = \'Corporation\' OR RecordType.DeveloperName = \'Franchise\')';
        }




        return Database.getQueryLocator(strQuery);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {
        Set<String> setAccountTargetId = new Set<String>();

        for(Account obj : scope) {
            setAccountTargetId.add(obj.Id);

            if(Test.isRunningTest()) {
                if(obj.ParentId <> null) {
                    setAccountTargetId.add(obj.ParentId);
                }
            }
        }

        if(Test.isRunningTest()) {
            List<UserRole> listUserRole = new List<UserRole>();

            listUserRole = [
                    SELECT  Id, PortalType, RollupDescription, PortalAccountId
                    FROM    UserRole WHERE RollupDescription IN:setAccountTargetId
            ];

            System.debug('======================> listUserRole size : '+listUserRole.size());
            System.debug('======================> listUserRole : '+listUserRole);
        }

        /*
        List<AccountShare> listCurAccountShare = new List<AccountShare>();

        listCurAccountShare = [
            SELECT  Id FROM AccountShare
            WHERE   AccountId IN:setAccountTargetId
            AND     RowCause = 'Manual'
        ];

        if(listCurAccountShare <> null && listCurAccountShare.size() > 0) {
            delete listCurAccountShare;
        }
        */

        List<AccountShare> listAccountShare = new List<AccountShare>();
        List<AccountShare> listAccountChildShare = new List<AccountShare>();

        // 병원 Account Share
        if(this.strAccountType == 'Hospital') {
            Set<String> setAccountId = new Set<String>();
            Set<String> setPartnerAccountId = new Set<String>();

            for(Account obj : scope) {
                if(obj.AssignedOrganization__r.IsPartner) {
                    setPartnerAccountId.add(obj.AssignedOrganization__c);
                }else {
                    setAccountId.add(obj.AssignedOrganization__c);
                }
            }

            System.debug('=======================> setAccountId : '+setAccountId);
            System.debug('=======================> setPartnerAccountId : '+setPartnerAccountId);

            if((!setAccountId.isEmpty()) || (!setPartnerAccountId.isEmpty())) {
                String strQuery = ' SELECT  Id, PortalType,';
                strQuery += '               RollupDescription, PortalAccountId';
                strQuery += '       FROM    UserRole';
                strQuery += '       WHERE   ';

                Boolean isAdd = false;

                if(!setAccountId.isEmpty()) {
                    strQuery += '   (RollupDescription IN:setAccountId AND PortalType = \'None\')';
                    isAdd = true;
                }

                if(!setPartnerAccountId.isEmpty()) {
                    if(isAdd) {
                        strQuery += ' OR ';
                    }
                    strQuery += '   (PortalAccountId IN:setPartnerAccountId AND PortalType = \'Partner\')';
                }

                System.debug('=======================> strQuery : '+strQuery);

                Set<String> setUserRoles = new Set<String>();
                Map<String, UserRole> mapUserRole = new Map<String, UserRole>();

                for(UserRole objUserRole : Database.query(strQuery)) {
                    setUserRoles.add(objUserRole.Id);
                    if(objUserRole.PortalType == 'Partner') {
                        mapUserRole.put(objUserRole.PortalAccountId, objUserRole);
                    }else {
                        mapUserRole.put(objUserRole.RollupDescription, objUserRole);
                    }
                }

                //System.debug('=====================================> mapUserRole : '+JSON.serialize(mapUserRole));

                Map<Id, String> mapGroupId = new Map<Id, String>();

                for(Group objGroup : [
                        SELECT  Id, RelatedId
                        FROM    Group
                        WHERE   RelatedId IN:setUserRoles
                        AND     Type = 'Role'
                ]) {
                    mapGroupId.put(objGroup.RelatedId, objGroup.Id);
                }

                for(Account obj : scope) {
                    if(mapUserRole <> null && mapUserRole.get(obj.AssignedOrganization__c) <> null) {

                        System.debug('=====================================> mapUserRole.get(obj.AssignedOrganization__c) : '+JSON.serialize(mapUserRole.get(obj.AssignedOrganization__c)));

                        UserRole objTargetUserRole = mapUserRole.get(obj.AssignedOrganization__c);

                        System.debug('============================> objTargetUserRole : '+objTargetUserRole);

                        if(mapGroupId <> null && mapGroupId.get(objTargetUserRole.Id) <> null) {
                            AccountShare objShare = new AccountShare();

                            objShare.AccountId = obj.Id;
                            objShare.AccountAccessLevel = 'Edit';
                            objShare.OpportunityAccessLevel = 'None';
                            objShare.CaseAccessLevel = 'Edit';
                            objShare.ContactAccessLevel = 'Edit';
                            objShare.RowCause = 'Manual';
                            objShare.UserOrGroupId = mapGroupId.get(objTargetUserRole.Id);

                            listAccountShare.add(objShare);
                        }else {
                            System.debug('============================> mapGroupId null');
                            System.debug('============================> Account Id : '+obj.Id);
                        }
                    }else {
                        System.debug('============================> mapUserRole null');
                        System.debug('============================> Account Id : '+obj.Id);
                    }
                }
            }
        }
        // 법인, 대리점 Account 전체 쉐어
        else {
            /*
            String strAllGroupId = [
                SELECT Id FROM Group WHERE DeveloperName = 'All'
            ].Id;

            for(Account obj : scope) {
                AccountShare objShare = new AccountShare();

                objShare.AccountId = obj.Id;
                objShare.AccountAccessLevel = 'Read';
                objShare.OpportunityAccessLevel = 'none';
                objShare.CaseAccessLevel = 'none';
                objShare.ContactAccessLevel = 'none';
                objShare.RowCause = 'Manual';
                objShare.UserOrGroupId = strAllGroupId;

                listAccountShare.add(objShare);
            }
            */

            Set<String> setAccountId = new Set<String>();
            Set<String> setPartnerAccountId = new Set<String>();

            for(Account obj : scope) {
                if(obj.IsPartner) {
                    setPartnerAccountId.add(obj.Id);
                }else {
                    setAccountId.add(obj.Id);
                }
            }

            System.debug('=======================> setAccountId : '+setAccountId);
            System.debug('=======================> setPartnerAccountId : '+setPartnerAccountId);

            if((!setAccountId.isEmpty()) || (!setPartnerAccountId.isEmpty())) {
                Map<String, List<Account>> mapChildAccount = new Map<String, List<Account>>();

                for(Account objChildAccount : [
                        SELECT ParentId, Id, IsPartner FROM Account WHERE (ParentId In:setAccountId OR ParentId In:setPartnerAccountId)
                ]) {
                    List<Account> listBefore = new List<Account>();

                    if(mapChildAccount <> null && mapChildAccount.get(objChildAccount.ParentId) <> null) {
                        listBefore = mapChildAccount.get(objChildAccount.ParentId);
                    }

                    listBefore.add(objChildAccount);

                    mapChildAccount.put(objChildAccount.ParentId, listBefore);

                    if(objChildAccount.IsPartner) {
                        setPartnerAccountId.add(objChildAccount.Id);
                    }else {
                        setAccountId.add(objChildAccount.Id);
                    }
                }

                String strQuery = ' SELECT  Id, PortalType,';
                strQuery += '               RollupDescription, PortalAccountId';
                strQuery += '       FROM    UserRole';
                strQuery += '       WHERE   ';

                Boolean isAdd = false;

                if(!setAccountId.isEmpty()) {
                    strQuery += '   (RollupDescription IN:setAccountId)';
                    isAdd = true;
                }

                if(!setPartnerAccountId.isEmpty()) {
                    if(isAdd) {
                        strQuery += ' OR ';
                    }
                    strQuery += '   (PortalAccountId IN:setPartnerAccountId)';
                }

                System.debug('=======================> strQuery : '+strQuery);

                Set<String> setUserRoles = new Set<String>();
                Map<String, UserRole> mapUserRole = new Map<String, UserRole>();

                for(UserRole objUserRole : Database.query(strQuery)) {
                    setUserRoles.add(objUserRole.Id);
                    if(objUserRole.PortalType == 'Partner') {
                        mapUserRole.put(objUserRole.PortalAccountId, objUserRole);
                    }else {
                        mapUserRole.put(objUserRole.RollupDescription, objUserRole);
                    }
                }

                Map<Id, String> mapGroupId = new Map<Id, String>();

                for(Group objGroup : [
                        SELECT  Id, RelatedId
                        FROM    Group
                        WHERE   RelatedId IN:setUserRoles
                        AND     Type = 'Role'
                ]) {
                    mapGroupId.put(objGroup.RelatedId, objGroup.Id);
                }

                for(Account obj : scope) {
                    if(mapUserRole <> null && mapUserRole.get(obj.Id) <> null) {

                        UserRole objTargetUserRole = mapUserRole.get(obj.Id);

                        if(mapGroupId <> null && mapGroupId.get(objTargetUserRole.Id) <> null) {
                            AccountShare objShare = new AccountShare();

                            objShare.AccountId = obj.Id;
                            objShare.AccountAccessLevel = 'Edit';
                            objShare.OpportunityAccessLevel = 'None';
                            objShare.CaseAccessLevel = 'Edit';
                            objShare.ContactAccessLevel = 'Edit';
                            objShare.RowCause = 'Manual';
                            objShare.UserOrGroupId = mapGroupId.get(objTargetUserRole.Id);

                            listAccountShare.add(objShare);
                        }
                    }

                    if(mapChildAccount <> null && mapChildAccount.get(obj.Id) <> null) {
                        System.debug('===========================> mapChildAccount.get(obj.Id) : '+mapChildAccount.get(obj.Id));

                        for(Account objChild : mapChildAccount.get(obj.Id)) {

                            System.debug('===========================> objChild.Id : '+objChild.Id);

                            UserRole objTargetChildUserRole = mapUserRole.get(objChild.Id);

                            System.debug('===========================> objTargetChildUserRole : '+objTargetChildUserRole);

                            if(objTargetChildUserRole <> null && mapGroupId <> null && mapGroupId.get(objTargetChildUserRole.Id) <> null) {
                                System.debug('===========================> mapGroupId.get(objTargetChildUserRole.Id) : '+mapGroupId.get(objTargetChildUserRole.Id));
                                AccountShare objShareChild = new AccountShare();

                                objShareChild.AccountId = obj.Id;
                                objShareChild.AccountAccessLevel = 'Read';
                                objShareChild.OpportunityAccessLevel = 'None';
                                objShareChild.CaseAccessLevel = 'None';
                                objShareChild.ContactAccessLevel = 'None';
                                objShareChild.RowCause = 'Manual';
                                objShareChild.UserOrGroupId = mapGroupId.get(objTargetChildUserRole.Id);

                                listAccountChildShare.add(objShareChild);
                            }
                        }
                    }
                }
            }
        }

        if(listAccountShare <> null && listAccountShare.size() > 0) {
            System.debug('===========================> listAccountShare Start');
            Database.SaveResult[] lsr = Database.insert(listAccountShare, false);

            // Create counter
            Integer i = 0;

            // Process the save results
            for (Database.SaveResult sr : lsr) {
                if (sr.isSuccess()) {
                    System.debug('Success');
                } else {
                    // Get the first save result error
                    Database.Error err = sr.getErrors()[0];

                    // Check if the error is related to a trivial access level
                    // Access levels equal or more permissive than the object's default
                    // access level are not allowed.
                    // These sharing records are not required and thus an insert exception is
                    // acceptable.
                    if (!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION && err.getMessage().contains('AccessLevel'))) {
                        // Throw an error when the error is not related to trivial access level.
                        System.debug('Unable to grant sharing access due to following exception: '+ err.getMessage());
                    }
                }
                i++;
            }

            System.debug('===========================> listAccountShare End');
        }

        if(listAccountChildShare <> null && listAccountChildShare.size() > 0) {
            System.debug('===========================> listAccountChildShare Start');
            Database.SaveResult[] lsr = Database.insert(listAccountChildShare, false);

            // Create counter
            Integer i = 0;

            // Process the save results
            for (Database.SaveResult sr : lsr) {
                if (sr.isSuccess()) {
                    System.debug('Success');
                } else {
                    // Get the first save result error
                    Database.Error err = sr.getErrors()[0];

                    // Check if the error is related to a trivial access level
                    // Access levels equal or more permissive than the object's default
                    // access level are not allowed.
                    // These sharing records are not required and thus an insert exception is
                    // acceptable.
                    if (!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION && err.getMessage().contains('AccessLevel'))) {
                        // Throw an error when the error is not related to trivial access level.
                        System.debug('Unable to grant sharing access due to following exception: '+ err.getMessage());
                    }
                }
                i++;
            }
            System.debug('===========================> listAccountChildShare End');
        }
    }

    global void finish(Database.BatchableContext BC) {
    }
}