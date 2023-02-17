/**
 * @description       : 
 *                      
 * @author            : hayle
 * @group             :
 * @last modified on  : 2023-02-03
 * @last modified by  : hayle
 * Modifications Log
 * Ver     Date             Author               Modification
 * 1.0   2023-02-03   hayle   Initial Version
 */

public with sharing class MyCtrl {

    public Id recordId { get; set; }

    public MyCtrl(ApexPages.StandardSetController ssc) {
        List<Contact> selectedRecords = (List<Contact>)ssc.getSelected();

        recordId = ssc.getSelected().get(0).Id; // 이건 Contact 으로 redirect 하는데... Class 로 하고 싶은데... 우째하지 .....

        System.debug('RelatedListCheckbox:' + selectedRecords);
    }

    // 원래 Class Record Detail page로 redirect 한다.
    public PageReference pageReference() {

        PageReference pageRef = new PageReference('/' + recordId);
        pageRef.setRedirect(true);
        return pageRef; //Returns to the case page

    }

}