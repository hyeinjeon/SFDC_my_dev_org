
public with sharing class yc_tr extends TriggerHandler {
    public yc_tr() {
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

    public void updateQuoteLineWhenOptyLineUpdate(String str) {

        /* 여기서부터 김예찬님 코드 */
        /* 예찬님: quote line item 을 모두 삭제하고 추가하는 것보다
        *         해당 quote line item을 찾아서 update 해주는 것이 좋다
        *         안그러면 이전 history를 알기 어렵기 때문 */

        /* set은 list와 달리 순서보장 안되고, 중복 없앰 */
        Set<Id> setOptyIds = new Set<Id>();

        // Oppty Id 와 Quote를 Map으로 묶음
        Map<Id, Quote> mapOptyIdToQuote = new Map<Id, Quote>();

        // Opp line item의 oppty id 가 null이 아니면 set에 oppty id 넣어줌.
        for (OpportunityLineItem obj : listNew) {
            if (obj.OpportunityId != null) {
                setOptyIds.add(obj.OpportunityId);
            }
        }

        // oppty id set이 있으면
        if (setOptyIds.size() > 0) {
            // quote 중 같은 oppty id 를 가진 quote 를 select
            List<Quote> listQuotes = new List<Quote>([
                    SELECT Id, OpportunityId
                    FROM Quote
                    WHERE OpportunityId = :setOptyIds
            ]);
            // 만약 quote 가 있으면
            if (listQuotes.size() > 0) {
                for (Quote obj : listQuotes) {
                    // oppty id 와 quote를 묶어줌
                    mapOptyIdToQuote.put(obj.OpportunityId, obj);
                }
            }
        }

        // oppty id와 quote를 묶어준게 있으면,
        if (mapOptyIdToQuote.size() > 0) {
            List<Quote> listQuotes = new List<Quote>();

            for (OpportunityLineItem obj : listNew) {
                Quote TargetQuote = mapOptyIdToQuote.get(obj.OpportunityId) != null ? mapOptyIdToQuote.get(obj.OpportunityId) : null;

                if (TargetQuote != null) {
                    // Quote 후처리함
                    listQuotes.add(TargetQuote);
                }
            }

            if (listQuotes.size() > 0) {
                update listQuotes;
            }
        }
    }

}