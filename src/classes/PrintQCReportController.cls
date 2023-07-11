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

public with sharing class PrintQCReportController {

    public String recordId { get; set; }
    public Case listCase { get; set; }
    public String caseOwnerName { get;set; }
    public String caseCreatedDate { get;set; }

    public PrintQCReportController() {
        //url속 파라미터를 가져오는 코드    // 해당 학급의 Id
        recordId = ApexPages.currentPage().GetParameters().get('recordId');
        //Contact 조회쿼리
        listCase = [
                SELECT  Id, Status, CaseNumber, Priority, CreatedDate, Owner.Name, Contact.Name,
                        Description
                FROM    Case
                WHERE   Id =: recordId
        ];

        caseOwnerName = listCase.Owner.Name;
        DateTime d = listCase.CreatedDate;
        caseCreatedDate = DateTime.newInstance(d.year(),d.month(),d.day()).format('yyyy-MM-dd');
    }

}