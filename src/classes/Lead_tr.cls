/**
 * Created by hayle on 2022-08-31.
 */

public with sharing class Lead_tr extends TriggerHandler {

    public Static Integer firstcall = 0;

    public Lead_tr() {
        system.debug('Lead_tr() : ' + firstcall);
        firstcall++;

        listNew = (List<Lead>) Trigger.new;  // new - before insert, before update 및 before undelete 트리거에서만 사용할 수 있습니다.
        listOld = (List<Lead>) Trigger.old;  // old - update 및 delete
        mapNew = (Map<Id, Lead>) Trigger.newMap; // newMap - before update,after insert,after update 및 after undelete
        mapOld = (Map<Id, Lead>) Trigger.oldMap; // oldMap - update 및 delete
    }

    /** TriggerHandler */
    private List<Lead> listNew { get; set; }
    private List<Lead> listOld { get; set; }
    private Map<Id, Lead> mapNew { get; set; }
    private Map<Id, Lead> mapOld { get; set; }
    public override void beforeInsert(){
        system.debug('Lead - beforeInsert()');
        changePhone('beforeInsert');
    }

    public override void beforeUpdate(){
        system.debug('Lead - beforeUpdate()');
        changePhone('beforeUpdate');
    }

    public override void afterUpdate(){
        system.debug('Lead - afterUpdate()');
    }

    public void changePhone(String str) {
        system.debug('changePhone()');
        String phone;
        String regex = '[a-zA-Z]{1,}|\\-|\\(|\\)';
        String numPhone;

        for(Lead lead : listNew) {
            phone = lead.Phone;

            if(phone != null)
            numPhone = phone.replaceAll(regex, '');

            lead.Phone = numPhone;

        }
    }
}