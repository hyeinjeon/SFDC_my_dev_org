/*
    <Apex Controller>
        - CRUD
 */
public with sharing class PDFGenerationClass {

    @AuraEnabled
    public static void GenerateCustomPDFAndEmail(Id recordId) {
        //first we need to get the page
        PageReference defaultPage = new PageReference('/apex/PrintStudentList2?recordId='+ recordId); //page location

        Blob pageData = defaultPage.getContentAsPDF();

        //create attachment
        Attachment att = new Attachment(
                ParentId = recordId,
                Body = pageData,
                Name = '학생정보 ' + DateTime.now().formatLong() + '.pdf'
        );
        insert att;

    }
}