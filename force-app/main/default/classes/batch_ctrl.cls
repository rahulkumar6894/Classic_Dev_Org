global class batch_ctrl implements Database.Batchable<sObject>{
     

     global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id,LastName FROM Contact';
        return Database.getQueryLocator(query);
    }
   
     global void execute(Database.BatchableContext BC, List<Contact> scope) {
         for(Contact a : scope)
         {
             a.LastName = a.LastName + 'Updated';            
         }
         /*
             for(Account a : scope)
            {
            a.Name = a.Name.remove('Updated');
            }
            update scope;
         
         */
         update scope;
    }   
    
    global void finish(Database.BatchableContext BC) 
    {
    }
}
  /*    Open Execute Anonymous Window
        //String q = 'SELECT Id,Email,Description FROM Speaker__c WHERE Email!= null';
        String q = 'SELECT Id,Email,Description FROM Contact WHERE Id = '0037F00000hvtRY'';
        SendReminderEmail batch = new SendReminderEmail(q, 'hello I am Subject', 'Hello rahul this body');
        Database.executeBatch(batch);
  */