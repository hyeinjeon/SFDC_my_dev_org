/**
 * Created by hyein on 2022-10-18.
 */

public with sharing class SignatureController {
    @AuraEnabled
    public static DataWrapper saveSignature(String signatureBody, String recordId){
        String strStatus = 'SUCCESS';
        String strMessage = '';

        DataWrapper objDataWrapper = new DataWrapper();
        try {
            Date d = date.today();
            ContentVersion objContentVersion = new ContentVersion();
            objContentVersion.Title = UserInfo.getLastName() + '_' + d.year() + d.month() + d.day();
            objContentVersion.VersionData = EncodingUtil.base64Decode(signatureBody);
            objContentVersion.PathOnClient = UserInfo.getLastName() + '_' + d.year() + d.month() + d.day() + '.jpg';
            objContentVersion.FirstPublishLocationId = recordId;
            objContentVersion.OwnerId = UserInfo.getUserId();
            objContentVersion.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            insert objContentVersion;

        } catch (Exception e) {
            strStatus = 'ERROR';
            strMessage = e.getMessage() + ' Line : '+e.getLineNumber();
        }

        objDataWrapper.strStatus = strStatus;
        objDataWrapper.strMessage = strMessage;

        return objDataWrapper;
    }

    public class DataWrapper {
        @AuraEnabled
        public String strStatus {get;set;}
        @AuraEnabled
        public String strMessage {get;set;}
    }
}