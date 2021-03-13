trigger Description_Update_on_Account_after_Insert_Contact On Contact (before insert)    
{  
    List<Account> accList = new List<Account>();  
    set<id> accountIdList = new Set<id>();  
    for(contact con : Trigger.new)  
    {  
        accountIdList.add(con.accountid);  
    }  
        Map<Id,account> mapVar = new Map<Id,account>([SELECT id,name
                                                  FROM account WHERE Id IN : accountIdList]);

  for(contact cont : Trigger.new)
{
    contact con = new contact();
    {
        Account acct = new Account();
        acct.id = mapVar.get(cont.accountid).id;
         acct.Description = mapVar.get(cont.accountid).Name + '-' +con.lastname;
        accList.add(acct);
    }
    }
    update accList;
}