/**
 * Created by hyein on 2022-10-18.
 */

public with sharing class SignatureController {
    @AuraEnabled
    public static DataWrapper saveSignature(String signatureBody, String recordId){
        String strStatus = 'SUCCESS';
        String strMessage = '';

        DataWrapper objDataWrapper = new DataWrapper();

        Asset objAsset = [
                SELECT  Id, File_Number__c
                FROM    Asset
                WHERE   Id =: recordId
        ];

        Integer num = 1;

        if (objAsset.File_Number__c == null) {
            objAsset.File_Number__c = String.valueOf(num);
            update objAsset;
        } else {
            num = integer.valueof(objAsset.File_Number__c);
        }

        try {
            Date d = date.today();
            ContentVersion objContentVersion = new ContentVersion();
            objContentVersion.Title = UserInfo.getLastName() + '_' + d.year() + d.month() + d.day() + '_' + num;
            objContentVersion.VersionData = EncodingUtil.base64Decode(signatureBody);
            objContentVersion.PathOnClient = UserInfo.getLastName() + '_' + d.year() + d.month() + d.day() + '.jpg';
            objContentVersion.FirstPublishLocationId = recordId;
            objContentVersion.OwnerId = UserInfo.getUserId();
            objContentVersion.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            insert objContentVersion;

            num += 1;
            objAsset.File_Number__c = String.valueOf(num);
            update objAsset;

        } catch (Exception e) {
            strStatus = 'ERROR';
            strMessage = e.getMessage() + ' Line : '+e.getLineNumber();
        }

        objDataWrapper.strStatus = strStatus;
        objDataWrapper.strMessage = strMessage;
        System.debug('objDataWrapper' + objDataWrapper);

        return objDataWrapper;
    }

    public class DataWrapper {
        @AuraEnabled
        public String strStatus {get;set;}
        @AuraEnabled
        public String strMessage {get;set;}
    }
}