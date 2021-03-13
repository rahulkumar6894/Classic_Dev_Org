global class batchExample implements Database.Batchable<sObject>,schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
         
        String query = 'SELECT Id,Name FROM Employee__c';
        System.debug('hello Account '+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Employee__c> EmpList) {
        
        // process each batch of records
 
         
        for(Employee__c Emp: EmpList)
        {        
            // Update the Account Name
               System.debug('Emp.Name'+Emp.Name); 
               Emp.Name = Emp.Name + 'Navatar Group Noida 201301';
             // Emp.Name=  Emp.Name.removeEnd('NavatarNavatar GroupNavatar Group Noida');
        }
        try {
            // Update the Account Record
            update EmpList;
         
        } catch(Exception e) {
            System.debug(e);
        }
         
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
  }
  //schedule jobs using the Apex scheduler :- You must implement execute when you scheduler Apex 
  global void execute(SchedulableContext sc)
    {
      batchExample b = new batchExample (); //ur batch class
      database.executebatch(b);
    }
}