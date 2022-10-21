/**
 * Created by hyein on 2022-10-20.

    <Apex Controller>
        - CRUD
 */

public with sharing class AssetDownloadPDF {

    @AuraEnabled
    public static void GenerateCustomPDFAndEmail(Id recordId) {
        //first we need to get the page
        PageReference defaultPage = new PageReference('/apex/AssetDownloadPDF?recordId='+ recordId); //page location

        Blob pageData = defaultPage.getContentAsPDF();

        Date d = date.today();
        //create attachment
        Attachment att = new Attachment(
                ParentId = recordId,
                Body = pageData,
                Name = 'Report_' + d.year() + d.month() + d.day() + '.pdf'
        );
        insert att;


    }

}