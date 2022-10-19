/**
 * Created by hyein on 2022-10-11.
 */

public with sharing class AccountUpdateHistory_sc implements Schedulable {
    public void execute(SchedulableContext sc) {
        AccountUpdateHistory_ba b = new AccountUpdateHistory_ba();
        database.executebatch(b);
    }
}