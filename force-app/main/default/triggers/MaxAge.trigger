trigger MaxAge on Contact (after insert,after delete,after Update) {
    List<string> accIdlist = new List<string>();
    List<Account> updateAccList = new  List<Account>();
    if(trigger.isInsert )
    {
        for(Contact conn :trigger.new)
        {
            accIdlist.add(conn.accountId);
        }
    }
    if(Trigger.isDelete || Trigger.IsUpdate )
    {
        for(Contact conn :trigger.old)
        {
            accIdlist.add(conn.accountId);
        } 
        System.debug('<><><>'+accIdlist);
    }       
    
    for( Account acc : [select id,(Select Id,age__c from contacts order by age__c DESC) from Account where id IN:accIdlist])
    {
        Account Updateacc  = new Account();
        Updateacc.Id = acc.id;
        Updateacc.maxAgeOfCon__c = acc.Contacts[0].age__c;
        Updateacc.No_of_Contact__c= acc.Contacts.size();
        updateAccList.add(Updateacc);
        System.debug('Account><><><><'+Updateacc);

    }
  if(updateAccList.size()>0){
      update updateAccList;
      }
}