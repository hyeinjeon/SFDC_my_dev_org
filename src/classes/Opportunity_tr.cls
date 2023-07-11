/**
 * @description       :
 *
 * @author            : hyein.jeon@daeunextier.com
 * @group             :
 * @last modified on  : 2022-08-29
 * @last modified by  : hyein.jeon@daeunextier.com
 * Modifications Log
 * Ver     Date             Author                   Modification
 * 1.0   2022-08-29   hyein.jeon@daeunextier.com    Initial Version
 */


public with sharing class Opportunity_tr extends TriggerHandler {
    public Opportunity_tr() {
        system.debug('Opportunity_tr()');
        listNew = (List<Opportunity>) Trigger.new;
        listOld = (List<Opportunity>) Trigger.old;
        mapNew = (Map<Id, Opportunity>) Trigger.newMap;
        mapOld = (Map<Id, Opportunity>) Trigger.oldMap;
    }

    /** TriggerHandler */
    private List<Opportunity> listNew { get; set; }
    private List<Opportunity> listOld { get; set; }
    private Map<Id, Opportunity> mapNew { get; set; }
    private Map<Id, Opportunity> mapOld { get; set; }

    public override void beforeInsert() {
        System.debug('opp - beforeInsert');
    }

    public override void afterInsert() {
        System.debug('opp - afterInsert');
    }

    public override void beforeUpdate() {
        System.debug('opp - beforeUpdate');
        CustomValidation('beforeUpdate');
        createQuoteLineItems();
    }

    public override void afterUpdate() {
        System.debug('opp - afterUpdate');
    }

    public override void beforeDelete() {
        System.debug('opp - beforeDelete');
    }

    public override void afterDelete() {
        System.debug('opp - afterDelete');
    }

    public void CustomValidation(String ActionType){
        if(ActionType == 'beforeUpdate'){
            for(Opportunity obj : listNew){
                if(obj.StageName == 'Negotiation/Review' && mapOld.get(obj.Id).StageName != 'Negotiation/Review' && !obj.HasOpportunityLineItem){
                    obj.addError('Opportunity Product가 없는 경우 Negotiation/Review 단계로 변경하실 수 없습니다.');
                }
            }
        }
    }

    /*  Oppty의 현재 stage와 상관없이 stage 가 negotiaton 으로 update 되고,
        opp line item 이 존재하면, quote 생성.
        ,그리고 oppty line item 을 quote line item 에 넣어줌   */
    public void createQuoteLineItems(){
        Set<Id> setOpportunityIds = new Set<Id>();
        for(Opportunity obj : listNew){
            if(obj.StageName == 'Negotiation/Review' && mapOld.get(obj.Id).StageName != 'Negotiation/Review' && obj.HasOpportunityLineItem){
                setOpportunityIds.add(obj.Id);
            }
        }

        if(!setOpportunityIds.isEmpty()){
            List<OpportunityLineItem> listOpportunityLineItems = new List<OpportunityLineItem>([
                    SELECT  Id, PricebookEntryId, Product2Id, Quantity, UnitPrice, OpportunityId, Description
                    FROM    OpportunityLineItem
                    WHERE   OpportunityId =: setOpportunityIds
            ]);

            List<Quote> listQuotes = new List<Quote>([
                    SELECT      Id, Name, OpportunityId, Status, CreatedDate
                    FROM        Quote
                    WHERE       OpportunityId = :setOpportunityIds
                    ORDER By    CreatedDate DESC
            ]);

            // Opty Id - Quote 매칭
            Map<Id,Quote> mapOptyIdToQuote = new Map<Id,Quote>();
            if(!listQuotes.isEmpty()){
                for(Quote objQuote : listQuotes){
                    if(mapOptyIdToQuote.get(objQuote.OpportunityId) == null){
                        mapOptyIdToQuote.put(objQuote.OpportunityId, objQuote);
                    }
                }
            }

            // Opty Id와 매칭된 Quote가 없다면, Quote를 만들어준다.
            List<Quote> listInsertQuotes = new List<Quote>();
            for(Opportunity obj : listNew){
                if(mapOptyIdToQuote.get(obj.Id) == null){
                    Quote objQuote = new Quote();
                    objQuote.Name = String.valueOf(Datetime.now());
                    objQuote.Status ='Draft';
                    objQuote.OpportunityId = obj.Id;
                    listInsertQuotes.add(objQuote);
                }
            }

            if(!listInsertQuotes.isEmpty()){
                insert listInsertQuotes;

                List<QuoteLineItem> listQuoteLineItems = new List<QuoteLineItem>();
                for(Quote objQuote : listInsertQuotes){
                    for(OpportunityLineItem objOptyLineItem : listOpportunityLineItems){
                        if(objQuote.OpportunityId == objOptyLineItem.OpportunityId){
                            QuoteLineItem objQLI = new QuoteLineItem();
                            objQLI.OpportunityLineItemId = objOptyLineItem.Id;
                            objQLI.Product2Id = objOptyLineItem.Product2Id;
                            objQLI.PricebookEntryId = objOptyLineItem.PricebookEntryId;
                            objQLI.Quantity = objOptyLineItem.Quantity;
                            objQLI.UnitPrice = objOptyLineItem.UnitPrice;
                            objQLI.Description = objOptyLineItem.Description;
                            objQLI.QuoteId = objQuote.Id;

                            listQuoteLineItems.add(objQLI);
                        }
                    }
                }
                if(!listQuoteLineItems.isEmpty()){
                    insert listQuoteLineItems;
                }
            }
        }
    }

}