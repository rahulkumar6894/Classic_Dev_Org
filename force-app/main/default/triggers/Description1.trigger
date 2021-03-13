trigger Description1 on  Contact  (after insert,after Update,after undelete,after delete) {
  
if(trigger.isInsert || trigger.isupdate || trigger.isundelete )
   {
  
      set<id> accountIdList = new Set<id>();  
      for(contact con : Trigger.new)  
       {  
          accountIdList.add(con.accountid);  
       }  
       List<Account>  acclist =[SELECT id,(Select Firstname,LastName FROM ContactS ) FROM Account where Id In:accountIdList];
       List<Account> newAcclist = new List<Account>();
     
       for(Account a : acclist){
       String acc = '';
         for(contact c: a.contacts){
         
       
           acc += c.Firstname + c.LastName + ',' ;
       
        }
        acc= acc.removeEnd(',');

        a.Description = acc;
        newAcclist.add(a);
       }
       update newAcclist ;
       
   }
 
 if(trigger.isDelete )
   {
  
      set<id> accountIdList = new Set<id>();  
      for(contact con : Trigger.old)  
       {  
          accountIdList.add(con.accountid);  
       }  
       List<Account>  acclist =[SELECT id,(Select Firstname,LastName FROM ContactS ) FROM Account where Id In:accountIdList];
       List<Account> newAcclist = new List<Account>();
     
       for(Account a : acclist){
       String acc = '';
         for(contact c: a.contacts){
       
           acc +=  c.Firstname + c.LastName + ',';
       
        }
       acc =acc.removeEnd(',');

        a.Description = acc;
        newAcclist.add(a);
       }
       update newAcclist ;
       
   }
 
 
}