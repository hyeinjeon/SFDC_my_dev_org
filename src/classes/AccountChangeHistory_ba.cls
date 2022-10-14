/**
 * Created by hayle on 2022-10-07.
 */

public with sharing class AccountChangeHistory_ba implements Database.Batchable<sObject>, Database.Stateful {
    /*
    Database.Stateful =
    The only time you need Database.
    Stateful is when the execute method modifies a class variable in a way meant to be used across multiple execute methods or in the finish method.
     */

    /*
        Start 메소드는 범위(처리할 데이터 목록)를 식별하고 apex 작업 시작 시 자동으로 호출됩니다.
        이 메서드는 작업을 수행해야 하는 레코드 또는 개체를 수집합니다.
     */
    public Database.QueryLocator start(Database.BatchableContext BC){
        // collect the batches of records or objects to be passed to execute

        String query = '';
        query += 'SELECT    Id, Name, LastModifiedDate, CreatedDate ';
        query += 'FROM      Account ';

        return Database.getQueryLocator(query);
    }

    /*
        Execute 메서드는 범위가 지정된 레코드의 하위 집합을 처리하고
        시작 메서드에서 가져온 레코드에 대해 수행하려는 작업을 수행합니다.
     */
    public void execute(Database.BatchableContext BC, List<Account> accList){

        List<ChangeHistory__c> listCH = new List<ChangeHistory__c>();

        for(Account acc : accList) {
            Date today = Date.today();
            Date modifyDate = acc.LastModifiedDate.date();
            Integer dayDiff = modifyDate.daysBetween(today);
            System.debug('dayDiff = ' + dayDiff);
            if(dayDiff <= 1) {
                System.debug('acc name: ' + acc.Name);
                ChangeHistory__c objCH = new ChangeHistory__c();
                objCH.Name = 'Changed Account -> ' + acc.Name + '! and it is 1AM~';
                objCH.Account__c = acc.Id;
                listCH.add(objCH);
            }
        }

        try {
            if(listCH.size() > 0) {
                insert listCH;
            }

        } catch(Exception e) {
            System.debug(e);
        }


    }

    /*
        Finish 메소드는 모든 배치가 처리된 후 실행됩니다.
        이 방법은 확인 이메일 알림 보내기와 같은 포스트 작업이나 마무리 작업에 사용됩니다.
     */
    public void finish(Database.BatchableContext BC){
        // execute any post-processing operations like sending email

    }
}