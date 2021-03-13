trigger count on Contact (after insert,after update) {
 if(trigger.isinsert || trigger.isupdate){
 SET<id> newaccidSET= new SET<Id>();
   
      for(Contact con:trigger.new)
         {
          newaccidSET.add(con.AccountId);
         }
         
         List <Account> acclist =[SELECT id ,No_of_Contact__c FROM Account where Id In:newaccidSET];
         list<Contact>  conlist = [SELECT ID ,AccountID FROM Contact where AccountId In:newaccidSET];
         List <Account> acclist1 = new List <Account>();
         
         for(Account a:acclist)
           {
             a.No_of_Contact__c=conlist .size(); 
             acclist1.add(a);
          
           }
  
      Update acclist1;
  }

 }