/**
 * Created by hayle on 2022-10-17.
 */

public with sharing class Asset_tr extends TriggerHandler {

    public Asset_tr() {
        system.debug('Asset_tr()');
        listNew = (List<Asset>) Trigger.new;
        listOld = (List<Asset>) Trigger.old;
        mapNew = (Map<Id, Asset>) Trigger.newMap;
        mapOld = (Map<Id, Asset>) Trigger.oldMap;
    }

    /** TriggerHandler */
    private List<Asset> listNew { get; set; }
    private List<Asset> listOld { get; set; }
    private Map<Id, Asset> mapNew { get; set; }
    private Map<Id, Asset> mapOld { get; set; }

    public override void beforeUpdate() {
        CustomValidation('beforeUpdate');
    }

    public void CustomValidation(String ActionType) {
        if (ActionType == 'beforeUpdate') {
            for (Asset objAssetNew : listNew) {
                Date WarrantyDay = mapOld.get(objAssetNew.Id).WarrantyDate__c;
                if(objAssetNew.CaseForWarranty__c
                        && objAssetNew.WarrantyDate__c != null
                        && objAssetNew.WarrantyDate__c != WarrantyDay) {
                    objAssetNew.addError('Asset에 해당하는 Case가 있는경우 Warranty Date 바꿀수 없음!');
                }
            }
        }
    }
}
