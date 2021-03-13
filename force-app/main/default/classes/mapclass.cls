public class mapclass
{
  mapclass()
  {
  
    
  
  
  }
  public static void hello(){
     
      List<Account> acclist = [select Id,(select Name From Contacts) From Account];
      Map<ID, Account> mapAccounts= new Map<ID, Account>([select Id,Name,(select Name From Contacts) From Account]);
      //System.debug(mapAccounts.keySet());
      //System.debug(mapAccounts.values());
      
      for(Account acc: mapAccounts.values())
      {
         //System.debug('acc@@@@@@@@@@@@@@@@@@@@'+acc.Contacts);
         for (Contact c : acc.Contacts)
         {
            //System.debug('+++++++'+c.Name);
        }
     }
     for(ID aId: mapAccounts.keySet())
      {
        //System.debug('aId!!!!!!!!!!!!!'+aId);
        
      }
      for (String key : mapAccounts.keySet())
      {
           System.debug('key '+ mapAccounts.get(key).Contacts);
      }
  }

}