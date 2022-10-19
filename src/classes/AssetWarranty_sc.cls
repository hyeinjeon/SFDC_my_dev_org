/**
 * Created by hayle on 2022-10-17.
 */

public with sharing class AssetWarranty_sc implements Schedulable {

    public void execute(SchedulableContext sc) {
        AssetWarranty_ba b = new AssetWarranty_ba();
        database.executebatch(b);
    }

}