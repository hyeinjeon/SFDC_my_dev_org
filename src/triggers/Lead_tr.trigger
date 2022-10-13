/**
 * Created by hayle on 2022-08-31.
 */

trigger Lead_tr on Lead (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new Lead_tr().run();
}