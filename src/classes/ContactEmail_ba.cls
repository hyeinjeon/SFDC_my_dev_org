/**
 * Created by hayle on 2022-10-12.
 */

public with sharing class ContactEmail_ba implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {

    public Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator([
                SELECT Id, Name, Email
                FROM Contact
                WHERE Name =: 'Hello~'
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Contact> listContact) {
        List<Messaging.SingleEmailMessage> listMails = new List<Messaging.SingleEmailMessage>();
        List<String> listAddress = new List<String>();
        for(Contact obj : listContact) {
            if(obj.Email != null) {
                listAddress.add(obj.Email);
            }
        }

        if(!listAddress.isEmpty()){
            for(Contact obj : listContact) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(listAddress);
                mail.setSubject('Hi!!!! ' + obj.Name + '님.');
                mail.setHtmlBody('<p>This is Batch Class TEST!<p></br><h1>TEST</h1>');
                listMails.add(mail);
            }

            if(!listMails.isEmpty()){
                System.debug('email list : ' + listMails);
                Messaging.sendEmail(listMails);
            }
        }

    }

    public void finish(Database.BatchableContext bc) {
    }

}