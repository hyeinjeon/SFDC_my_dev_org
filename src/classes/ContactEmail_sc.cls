/**
 * Created by hayle on 2022-10-12.
 */

public with sharing class ContactEmail_sc implements Schedulable{
    public void execute(SchedulableContext sc) {
        ContactEmail_ba ba = new ContactEmail_ba();
        Database.executeBatch(ba);
    }
}