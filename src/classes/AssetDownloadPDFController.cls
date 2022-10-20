/**
 * Created by hayle on 2022-10-20.
 */

public with sharing class AssetDownloadPDFController {
    public String recordId { get; set; }
    public List<Asset>  listAsset { get; set; }
    public List<ContentVersion>  listCV { get; set; }

    public AssetDownloadPDFController() {
        //url속 파라미터를 가져오는 코드
        recordId = ApexPages.currentPage().GetParameters().get('recordId');

        //Asset 조회쿼리
        listAsset = new List<Asset>([
                SELECT Id, Name, ProductCode, SerialNumber
                FROM Asset
                WHERE Id =: recordId
        ]);

        // Signature 조회쿼리
        listCV = new list<ContentVersion>([
                SELECT Id, Title, VersionData, PathOnClient
                FROM ContentVersion
                WHERE FirstPublishLocationId =: recordId
        ]);

    }
}