/**
 * Created by hayle on 2023-01-03.
 */

trigger Contact_tr on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new Contact_tr().run();
}