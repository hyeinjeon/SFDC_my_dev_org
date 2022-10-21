/**
 * Created by hayle on 2022-10-20.
 */

public with sharing class AssetDownloadPDFController {
    public String recordId { get; set; }
    public List<Asset>  listAsset { get; set; }
    public String imageUrl {get; set;}

    public AssetDownloadPDFController() {
        // url속 파라미터를 가져오는 코드
        recordId = ApexPages.currentPage().GetParameters().get('recordId');

        // Asset 조회쿼리
        listAsset = new List<Asset>([
                SELECT Id, Name, ProductCode, SerialNumber, Account.Name
                FROM Asset
                WHERE Id =: recordId
        ]);

        // Signature 조회쿼리
        ContentVersion[] cvs = [
                SELECT Id
                FROM ContentVersion
                WHERE FirstPublishLocationId =: recordId
                ORDER BY CreatedDate DESC

        ];

        imageUrl = '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=' + cvs[0].Id;

    }
}


