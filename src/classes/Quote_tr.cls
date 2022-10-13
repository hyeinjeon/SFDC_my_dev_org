/**
 * Created by hayle on 2022-08-30.
 */

public with sharing class Quote_tr extends TriggerHandler {

    public Quote_tr() {
        system.debug('Quote_tr()');
        listNew = (List<Quote>) Trigger.new;  // new - before insert, before update 및 before undelete 트리거에서만 사용할 수 있습니다.
        listOld = (List<Quote>) Trigger.old;  // old - update 및 delete
        mapNew = (Map<Id, Quote>) Trigger.newMap; // newMap - before update,after insert,after update 및 after undelete
        mapOld = (Map<Id, Quote>) Trigger.oldMap; // oldMap - update 및 delete
    }

    /** TriggerHandler */
    private List<Quote> listNew { get; set; }
    private List<Quote> listOld { get; set; }
    private Map<Id, Quote> mapNew { get; set; }
    private Map<Id, Quote> mapOld { get; set; }

    public override void afterInsert(){
    }


}