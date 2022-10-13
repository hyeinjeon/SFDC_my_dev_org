/**
 * Created by hyein on 2022-08-29.
 */

public with sharing class OpportunityLineItem_tr extends TriggerHandler {
    public OpportunityLineItem_tr() {
        System.debug('OpportunityLineItem_tr()');
        listNew = (List<OpportunityLineItem>) Trigger.new;  // new - before insert, before update 및 before undelete 트리거에서만 사용할 수 있습니다.
        listOld = (List<OpportunityLineItem>) Trigger.old;  // old - update 및 delete
        mapNew = (Map<Id, OpportunityLineItem>) Trigger.newMap; // newMap - before update,after insert,after update 및 after undelete
        mapOld = (Map<Id, OpportunityLineItem>) Trigger.oldMap; // oldMap - update 및 delete
    }

    /** TriggerHandler */
    private List<OpportunityLineItem> listNew { get; set; }
    private List<OpportunityLineItem> listOld { get; set; }
    private Map<Id, OpportunityLineItem> mapNew { get; set; }
    private Map<Id, OpportunityLineItem> mapOld { get; set; }

    public override void beforeInsert(){
        System.debug('opp line item - beforeInsert');
        createQLI();
    }

    public override void afterInsert(){
        System.debug('opp line item - afterInsert');
    }

    public override void beforeUpdate(){
        System.debug('opp line item - beforeUpdate');
        updateQLI();
    }

    public override void afterUpdate(){
        System.debug('opp line item - afterUpdate');
    }

    public override void beforeDelete(){
        System.debug('opp line item - beforeDelete');
        deleteQLI();
    }

    public override void afterDelete(){
        System.debug('opp line item - afterDelete');
    }

    /*
    opp line item 이 insert 된 경우,
    최신의 quote가 draft 인지 확인하고 draft 일 경우,
    quote line item 을 insert
    (최신의 quote가 draft 가 아닐 경우, 아무일도 일어나지 않음)
     */
    public void createQLI() {
        // insert 할 quote line item list
        List<QuoteLineItem> listQuoteLineItems = new List<QuoteLineItem>();

        Set<Id> setOptyIds = new Set<Id>();
        for(OpportunityLineItem obj : listNew){
            setOptyIds.add(obj.OpportunityId);
        }

        // insert 할 OLI 에 해당하는 Oppty 의 Quote 들을 최신순으로 가져옴
        List<Quote> listQuotes = new List<Quote>([
                SELECT      Id, OpportunityId, Status
                FROM        Quote
                WHERE       OpportunityId =: setOptyIds
                ORDER BY    CreatedDate DESC
        ]);

        // 최신의 quote 만 가져오기 위해 만든 변수
        String OppId;

        if(!listQuotes.isEmpty()) {
            for(Quote objQuote : listQuotes) {
                // 최신의 quote 만 가져오게 하는 if문
                if(OppId != objQuote.OpportunityId) {
                    OppId = objQuote.OpportunityId;
                    for(OpportunityLineItem objOLI : listNew) {
                        if(objOLI.OpportunityId == objQuote.OpportunityId) {
                            // quote의 상태가 draft 일 경우에만
                            if (objQuote.Status == 'Draft') {
                                QuoteLineItem objQLI = new QuoteLineItem();
                                objQLI.OpportunityLineItemId = objOLI.Id;
                                objQLI.Product2Id = objOLI.Product2Id;
                                objQLI.PricebookEntryId = objOLI.PricebookEntryId;
                                objQLI.Quantity = objOLI.Quantity;
                                objQLI.UnitPrice = objOLI.UnitPrice;
                                objQLI.Description = objOLI.Description;
                                objQLI.QuoteId = objQuote.Id;

                                listQuoteLineItems.add(objQLI);
                            }
                        }
                    }
                }
            }
        }

        if(!listQuoteLineItems.isEmpty()) {
            insert listQuoteLineItems;
        }
    }


    /*
    opp line item 이 update 된 경우,
    최신의 quote가 draft인 경우,
    (opplineitemid) = (opplineitem.id) 가
    같은 것을 찾아서 field 를 update 해준다.
    (최신의 quote가 draft가 아닐 경우, 아무일도 일어나지 않는다)
     */
    public void updateQLI() {
        Set<Id> setOptyIds = new Set<Id>();
        for(OpportunityLineItem obj : listNew){
            setOptyIds.add(obj.OpportunityId);
        }

        List<Quote> listQuotes = new List<Quote>([
                SELECT      Id, OpportunityId, Status, Name
                FROM        Quote
                WHERE       OpportunityId =: setOptyIds
                ORDER BY    CreatedDate DESC
        ]);

        Map<Id, Quote> mapOppToQuote = new Map<Id, Quote>();

        // 최신의 quote 만 가져오기 위해 만든 변수
        String OppId;

        for (Quote objQuote : listQuotes) {
            // 최신의 quote 만 가져오게 하는 if문
            if(OppId != objQuote.OpportunityId) {
                OppId = objQuote.OpportunityId;
                // 최신의 quote 와 oppty id 를 mapping 한다
                mapOppToQuote.put(objQuote.OpportunityId, objQuote);
            }
        }

        // update 할 QLI list
        List<QuoteLineItem> listQuoteLineItems2 = new List<QuoteLineItem>();

        if (!mapOppToQuote.isEmpty()) {
            for (OpportunityLineItem objOLI : listNew) {
                // 최신의 quote 를 target quote 로 지정
                Quote TargetQuote = mapOppToQuote.get(objOLI.OpportunityId) != null ? mapOppToQuote.get(objOLI.OpportunityId) : null;
                // 최신의 quote 에 해당하는 QLI 를 list 에 넣어준다
                listQuoteLineItems2.add([
                        SELECT Id, Product2.Name, Quantity, OpportunityLineItemId, Quote.Status
                        FROM QuoteLineItem
                        WHERE Quote.Id = :TargetQuote.Id
                        AND OpportunityLineItemId = :objOLI.Id
                ]);
            }

            for(QuoteLineItem objQLI : listQuoteLineItems2) {
                for (OpportunityLineItem objOLI : listNew) {
                    // OpportunityLineItemId == OpportunityLineItem.Id 이고,
                    // 최신의 quote 의 상태가 draft 이면
                    if(objQLI.OpportunityLineItemId == objOLI.Id && objQLI.Quote.Status == 'Draft') {
                        objQLI.Quantity = objOLI.Quantity;
                        objQLI.Discount = objOLI.Discount;
                        objQLI.Description = objOLI.Description;
                        objQLI.UnitPrice = objOLI.UnitPrice;
                    }
                }
            }
        }

        if(!listQuoteLineItems2.isEmpty()) {
            update listQuoteLineItems2;
        }


    }


    /*
    opp line item 이 delete 된 경우,
    최신의 quote가 draft 인지 확인하고, draft 일 경우,
    quote line item 을 delete 한다.
    (최신의 quote가 draft 가 아닐 경우, 아무일도 일어나지 않음)
     */
    public void deleteQLI() {
        // 삭제할 Quote Line Item List
        List<QuoteLineItem> listQuoteLineItemsToDelete = new List<QuoteLineItem>();

        Set<Id> setOptyIds = new Set<Id>();
        for(OpportunityLineItem obj : listOld){
            setOptyIds.add(obj.OpportunityId);
        }

        List<Quote> listQuotes = new List<Quote>([
                SELECT      Id, OpportunityId, Status, Name
                FROM        Quote
                WHERE       OpportunityId =: setOptyIds
                ORDER BY    CreatedDate DESC
        ]);

        Map<Id, Quote> mapOppToQuote = new Map<Id, Quote>();

        // 최신의 quote 만 가져오기 위해 만든 변수
        String OppId;

        for (Quote objQuote : listQuotes) {
            // 최신의 quote 만 가져오게 하는 if문
            if(OppId != objQuote.OpportunityId) {
                OppId = objQuote.OpportunityId;
                // 최신의 quote 와 oppty id 를 mapping 한다
                mapOppToQuote.put(objQuote.OpportunityId, objQuote);
            }
        }

        List<QuoteLineItem> listQuoteLineItems2 = new List<QuoteLineItem>();

        if (!mapOppToQuote.isEmpty()) {
            for (OpportunityLineItem objOLI : listOld) {
                // 최신의 quote 를 target quote 로 지정
                Quote TargetQuote = mapOppToQuote.get(objOLI.OpportunityId) != null ? mapOppToQuote.get(objOLI.OpportunityId) : null;
                listQuoteLineItems2.add([
                        SELECT Id, Product2.Name, Quantity, OpportunityLineItemId, Quote.Status
                        FROM QuoteLineItem
                        WHERE Quote.Id = :TargetQuote.Id
                        AND OpportunityLineItemId = :objOLI.Id
                ]);
            }

            for(QuoteLineItem objQLI : listQuoteLineItems2) {
                    // 최신의 quote 의 상태가 draft 이면
                    if(objQLI.Quote.Status == 'Draft') {
                        listQuoteLineItemsToDelete.add(objQLI);
                }
            }
        }

        if(!listQuoteLineItemsToDelete.isEmpty()) {
            delete listQuoteLineItemsToDelete;
        }
    }
}