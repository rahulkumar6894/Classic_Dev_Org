trigger No_of_Contact on Contact (after insert) {
  List<String> accIdlist =new list<string>();
  List<Account> Acclist = new List<Account>();
  if(trigger.isInsert )
  {
     for(Contact conn :trigger.new){
     Map<id,Contact> mymap =trigger.newmap;
     accIdlist.add(mymap.get(conn.id).AccountId);
     
     Map<String,List<Contact>> m = new Map<String, List<Contact>>();
     
      
     for(Contact c: [Select Id,AccountId FROM Contact where AccountID IN :accIdlist])
     {
        if(!m.containsKey(c.AccountID))
        {
          m.put(c.AccountID ,new list<contact>());
        }
        m.get(c.AccountId).add(c);
       
     }
    /*for( Account a : [SELECT id,No_of_Contact__c FROM ACCount where Id in:m.get(a.id)])
      {
      List<Contact> coList = new List<contact>();
      coList = m.get(a.id);
      system.debug(coList );
       System.debug('test'+m.get(a.id));
      // System.debug('test'+m.get(a.id).size());
       //  a.No_of_Contact__c = m.get(a.id).size();  
          Acclist.add(a);
           }
          Update Acclist ;*/
         }

  }
  
}