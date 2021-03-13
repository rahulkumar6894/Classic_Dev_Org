trigger UpdateAccount2 on Task (after insert ,after update, after undelete , after delete)
 {
   if(trigger.isinsert || trigger.isundelete) // for Trigger Insert,And Undelete
    {           
        Set<Id> WhatID = new Set<Id>(); // set to collect all Id
        Map < Id, Account> finalAccMap = new Map< Id, Account> ();
        Map < Id, Account> AccMap = new Map< Id, Account> ();
        for(Task t : Trigger.New) 
        {
             WhatID.add(t.whatId);
        }
        for(Account acc: [select Id, AssignTo__c , Subject__c, Priority__c, Duedate__c FROM Account Where Id IN:WhatID ])
        {
         AccMap.put(acc.Id, acc);
        }
      
        for(Task t : Trigger.New) 
        {
             if(t.WhatId <> NULL && t.WhatId.getSobjectType() == Account.getSObjectType())
             {
                       
                system.debug('AccMap.get(t1.WhatId).Duedate__c--'+AccMap.get(t.WhatId).Duedate__c);
                if(t.Activitydate > AccMap.get(t.WhatId).Duedate__c || AccMap.get(t.WhatId).Duedate__c == null)
                {
                    System.debug('t.Activitydate'+t.Activitydate);
                    AccMap.get(t.WhatId).Priority__c= t.priority;
                    AccMap.get(t.WhatId).Subject__c= t.subject;
                    AccMap.get(t.WhatId).AssignTo__c= t.OwnerId;
                    AccMap.get(t.WhatId).Duedate__c = t.Activitydate;
                    finalAccMap.put(t.WhatId, AccMap.get(t.WhatId));
                }          
                     
            }
        }
                              

        update finalAccMap.values();   
    }
    // --- Trigger On Update 
    if(trigger.isupdate)
    { 
            Set<String> taskID = new Set<String>();
            Map < Id, Account> AccMap = new Map< Id, Account> ();
            Map < Id, Account> finalAccMap = new Map< Id, Account> ();
            List <account>  accUpdate=  new list<account>(); 
            for(Task t : Trigger.New)
            {
                if(t.WhatId <> NULL && t.WhatId.getSobjectType() == Account.getSObjectType())
                {
                  taskID.add(t.WhatId);  
                }         
            }
            for(Task t : Trigger.old)
            {
               if(t.WhatId <> NULL && t.WhatId.getSobjectType() == Account.getSObjectType())
                {
                  taskID.add(t.WhatId);  
                }        
            }
            for(Account acc: [select Id, AssignTo__c , Subject__c, Priority__c, Duedate__c FROM Account Where Id IN:taskID ])
            {
                AccMap.put(acc.Id, acc);
            }
            list <account> ac1 = [select Id,Subject__c,priority__c,AssignTo__c,Duedate__c from account where Id IN:taskID ];
            for(account a : ac1)
            {
                    a.Priority__c= Null;
                    a.Subject__c= Null;
                    a.AssignTo__c= Null;
                    a.Duedate__c =Null;
                    accUpdate.add(a);
            }
            update  accUpdate;
            for(Task t: [select Id,Subject ,priority,ownerId,ActivityDate,WhatId from task where WhatId In:taskID])
            {
                    Date mydate = date.parse('01/01/2000');
                    if(mydate <=t.Activitydate)
                    {
                        mydate = t.Activitydate;
                    }
                    AccMap.get(t.WhatId).Priority__c= t.priority;
                    AccMap.get(t.WhatId).Subject__c= t.subject;
                    AccMap.get(t.WhatId).AssignTo__c= t.OwnerId;
                    AccMap.get(t.WhatId).Duedate__c = mydate ;
                    finalAccMap.put(t.WhatId, AccMap.get(t.WhatId));
            }
            update finalAccMap.values();        
      } 
     // -------trigger on Delete
    if(trigger.isdelete)
    {  
            Set<String> WhatID = new Set<String>();
            List <account>  accUpdate=  new list<account>();
            for(Task t : Trigger.old)
            {
                if(t.WhatId <> NULL && t.WhatId.getSobjectType() == Account.getSObjectType())
                 {
                      WhatID.add(t.WhatId);  
                 }         
            }
            Map < Id, Account> finalAccMap = new Map< Id, Account> ();
            Map < Id, Account> AccMap = new Map< Id, Account> ();
            for(Account acc: [select Id, AssignTo__c , Subject__c, Priority__c, Duedate__c FROM Account Where Id IN:WhatID ])
            {
                AccMap.put(acc.Id, acc);
            }
            list <account> ac1 = [select Id,Subject__c,priority__c,AssignTo__c,Duedate__c from account where Id IN:WhatID ];
            for(account a : ac1)
            {
                a.Priority__c= Null;
                a.Subject__c= Null;
                a.AssignTo__c= Null;
                a.Duedate__c =Null;
                accUpdate.add(a);
            }
            update  accUpdate;
            for(task t : [select Id,Subject ,priority,ownerId,ActivityDate,WhatId from task where WhatId IN:WhatID])
            {        
                Date mydate = date.parse('01/01/2000');
                if(mydate <=t.Activitydate)
                {
                    mydate = t.Activitydate;
                }
                AccMap.get(t.WhatId).Priority__c= t.priority;
                AccMap.get(t.WhatId).Subject__c= t.subject;
                AccMap.get(t.WhatId).AssignTo__c= t.OwnerId;
                AccMap.get(t.WhatId).Duedate__c = t.Activitydate;
                finalAccMap.put(t.WhatId, AccMap.get(t.WhatId));
            }  
            update finalAccMap.values();  
      } 
 }