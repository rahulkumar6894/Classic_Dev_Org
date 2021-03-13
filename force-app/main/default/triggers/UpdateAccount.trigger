trigger UpdateAccount  on Task (after insert, after update ,after delete,after undelete) {
        
        if(trigger.isinsert || trigger.isundelete  )
        {
           
            Set <id> taskID = new Set <Id>();
            list<Account> acclist = new list<Account> ();
            List <Account> acclist1 = new List <Account>(); 
            List <task>  task1   =  new list<task>();
            
            for(task ts:trigger.new)
            {
                 taskID.add(ts.WhatId);
               
            }
            
            task1    = [select Id,Subject ,priority,ownerId,ActivityDate from task  where WhatId In:taskID];
            System.debug('taskList'+task1);   
            acclist1 = [ SELECT (select Id,Subject ,priority,ownerId,ActivityDate from tasks ) FROM Account where Id In:taskID];
            Date dt =task1[0].ActivityDate ;
            for(Account a:acclist1)
            {    
                for (integer i = 0; i <task1.size() ; i++)
                {
                    if(task1[i].ActivityDate >= dt)
                    {
                        dt = task1[i].ActivityDate ;
                        a.Duedate__c = dt; 
                        a.AssignTo__c =  task1[i].OwnerId;
                        a.Subject__c  =  task1[i].Subject;
                        a.Priority__c = task1[i].priority;
                        acclist.add(a) ; 
                      
                    }
                System.debug('acclist'+acclist);
                
                }  
          }
          update acclist;     
      }
      
      
      
      // trigger for update Task
      if(trigger.isupdate)
      {
            Set <Id> taskID = new Set <Id>();   // for trigger.new
            Set <Id> taskID2 = new Set <Id>(); // for trigger.old
            
            Account acclist = new Account ();   // for update Account for trigger.new
            Account acclistold = new Account ();   // for update Account for trigger.old

            List <Account> acclist1 = new List <Account>(); 
            List <Account> acclist1old = new List <Account>(); // for old

            List <Task>  task1   =  new List<Task>();
            List <Task>  task2   =  new List<Task>(); // for old


            for(task ts:trigger.new)
            {
                 taskID.add(ts.WhatId);
               System.debug(taskID+'++New++'+ts.ID);
            }
            for(task ts:trigger.Old)
            {
                 taskID2.add(ts.WhatId);
                   System.debug(taskID2+'++OLD++'+ts.ID);
               
            }
           for(task ts:trigger.new)
            {
            task1    = [SELECT WhatId ,Id,Subject ,priority,ownerId,ActivityDate FROM task  Where WhatId In:taskID];
            System.debug('taskList'+task1);   
            acclist1 = [ SELECT (SELECT Id,Subject ,priority,ownerId,ActivityDate FROM tasks ) FROM Account Where Id In:taskID];
            Date dt =task1[0].ActivityDate ;
            for(Account a:acclist1)
            {    
                for (integer i = 0; i <task1.size() ; i++)
                {
                    if(task1[i].ActivityDate >= dt)
                    {
                        dt = task1[i].ActivityDate ;
                        a.Duedate__c = dt; 
                        a.AssignTo__c =  task1[i].OwnerId;
                        a.Subject__c  =  task1[i].Subject;
                        a.Priority__c = task1[i].priority;
                        acclist = a ; 
                      
                    }
                
                }  
          }
            System.debug('acclist'+acclist);
            update acclist;
                       
          }
          //----------------------------------------------
           for(task ts:trigger.Old)
          {
             task2      = [SELECT WhatId , Id,Subject ,priority,ownerId,ActivityDate FROM task  Where WhatId In: taskID2];
             acclist1old = [ SELECT (SELECT Id,Subject ,priority,ownerId,ActivityDate FROM tasks ) FROM Account Where Id In:taskID2];
             System.debug('taskList OLd'+task2);
             Date dt =task2[0].ActivityDate ;
            for(Account a:acclist1old )
            {   
             for (integer i = 0; i <task2.size() ; i++)
                {
                    if(task2[i].ActivityDate >= dt)
                    {
                        dt = task2[i].ActivityDate ;
                        a.Duedate__c = dt; 
                        a.AssignTo__c =  task2[i].OwnerId;
                        a.Subject__c  =  task2[i].Subject;
                        a.Priority__c = task2[i].priority;
                        acclistold = a ; 
                      
                    }
                
                }  
          }
            System.debug('acclistold '+acclistold );
            update acclistold ;
                       
          } 
          }
           
            
      
      
      
      
      
      
      
      
      if(trigger.isdelete  )
        {
           
            Set <id> taskID = new Set <Id>();
            Account acclist = new Account ();
            List <Account> acclist1 = new List <Account>(); 
            list <task>  task1   =  new list<task>();
            
            for(task ts:trigger.old)
            {
                 
                 taskID.add(ts.WhatId);
               
            }
            
            task1    = [select Id,Subject ,priority,ownerId,ActivityDate from task  where WhatId In:taskID];
            acclist1 = [ SELECT (select Id,Subject ,priority,ownerId,ActivityDate from tasks ) FROM Account where Id In:taskID];
            Date dt =task1[0].ActivityDate ;
            for(Account a:acclist1)
            {    
                for (integer i = 0; i <task1.size() ; i++)
                {
                    if(task1[i].ActivityDate >= dt)
                    {
                        dt = task1[i].ActivityDate ;
                        System.debug('dt  '+ dt   );
                        a.Duedate__c = dt; 
                        a.AssignTo__c =  task1[i].OwnerId;
                        a.Subject__c  =  task1[i].Subject;
                        a.Priority__c = task1[i].priority;
                        acclist = a ; 
                        System.debug('acclist'+acclist);
                     }
                     
                      
                        
                }  
          } 
           update acclist;    
      }
}