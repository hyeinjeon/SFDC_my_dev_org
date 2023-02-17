/**
 * @description       : 
 *                      
 * @author            : hayle
 * @group             :
 * @last modified on  : 2023-01-03
 * @last modified by  : hayle
 * Modifications Log
 * Ver     Date             Author               Modification
 * 1.0   2023-01-03   hayle   Initial Version
 */

public with sharing class Contact_tr extends TriggerHandler {

    public Static Integer firstcall = 0;
    public Contact_tr() {
        system.debug('Contact_tr() : ' + firstcall);
        firstcall++;

        listNew = (List<Contact>) Trigger.new;  // new - before insert, before update 및 before undelete 트리거에서만 사용할 수 있습니다.
        listOld = (List<Contact>) Trigger.old;  // old - update 및 delete
        mapNew = (Map<Id, Contact>) Trigger.newMap; // newMap - before update,after insert,after update 및 after undelete
        mapOld = (Map<Id, Contact>) Trigger.oldMap; // oldMap - update 및 delete
    }

    /** TriggerHandler */
    private List<Contact> listNew { get; set; }
    private List<Contact> listOld { get; set; }
    private Map<Id, Contact> mapNew { get; set; }
    private Map<Id, Contact> mapOld { get; set; }
    public override void beforeUpdate() {
        system.debug('Contact - beforeUpdate()');
//        updateContact();
    }
    public override void beforeInsert() {
        system.debug('Contact - beforeInsert()');
        updateContact();
    }
    public override void afterUpdate() {
        system.debug('Contact - afterUpdate()');
        updateContact();
    }
    public void updateContact() {
        system.debug('updateContact()');

        List<Lead> listLead = new List<Lead>([
                SELECT Id, Name, Description, Phone
                FROM Lead
                WHERE Name =: 'trigger test hyein'
        ]);

        if(!listLead.isEmpty()) {
            for (Lead lead : listLead) {
                lead.Description = 'update! test hyein 111';
                lead.Phone = '010-1212-1111';
            }
        }

        update listLead;

    }


}