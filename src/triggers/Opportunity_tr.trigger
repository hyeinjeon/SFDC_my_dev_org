/**
 * Created by hyein on 2022-08-29.
 */

trigger Opportunity_tr on Opportunity (before insert, after insert, before update, after update, before delete, after delete) {
    new Opportunity_tr().run();
}