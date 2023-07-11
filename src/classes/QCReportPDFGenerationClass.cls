/**
 * @description       : 
 *                      
 * @author            : hyein.jeon@daeunextier.com
 * @group             :
 * @last modified on  : 2023-05-04
 * @last modified by  : hyein.jeon@daeunextier.com
 * Modifications Log
 * Ver     Date             Author               Modification
 * 1.0   2023-05-04   hyein.jeon@daeunextier.com   Initial Version
 */

public with sharing class QCReportPDFGenerationClass {

    @AuraEnabled
    public static void GenerateQCReportPDF(Id recordId) {
        //first we need to get the page
        PageReference defaultPage = new PageReference('/apex/CaseQCReport?recordId='+ recordId); //page location

        Blob pageData = defaultPage.getContentAsPDF();

        //create attachment
        Attachment att = new Attachment(
                ParentId = recordId,
                Body = pageData,
                Name = 'QCReport ' + Datetime.now().formatLong() + '.pdf'
        );
        insert att;

    }

}