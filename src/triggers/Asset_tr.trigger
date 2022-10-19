/**
 * Created by hayle on 2022-10-17.
 */

trigger Asset_tr on Asset (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new Asset_tr().run();
}