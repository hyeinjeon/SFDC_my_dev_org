/**
 * Created by hyein on 2022-08-29.
 */

trigger OpportunityLineItem_tr on OpportunityLineItem (before insert, after insert, before update, after update, before delete, after delete) {
    new OpportunityLineItem_tr().run();
}