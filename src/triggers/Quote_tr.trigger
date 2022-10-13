/**
 * Created by hayle on 2022-08-30.
 */

trigger Quote_tr on Quote (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new Quote_tr().run();
}