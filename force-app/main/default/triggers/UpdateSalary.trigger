trigger UpdateSalary on Contact (after insert, after update ,after delete,after undelete) {

   if(trigger.isinsert || trigger.isupdate|| trigger.isUndelete){
    
      SET<id> newaccidSET= new SET<Id>();
   
      for(Contact con:trigger.new)
          {
          newaccidSET.add(con.AccountId);
         }
         List <Account> acclist1 = new List <Account>();
         List <Account> acclist =[SELECT id, Min_Salary_of_Contacts__c,Total_Contacts__c,Max_Salary_of_Contacts__c,Salary_Sum_of_Contacts__c,(Select salary__c FROM ContactS order by salary__c DESC) FROM Account where Id In:newaccidSET];

         Decimal min=0;
         Decimal max=0;
         Decimal sum=0;
         Decimal Avg=0;
         
         for(Account a:acclist)
           {
               a.Total_Contacts__c=a.Contacts.size(); 
          for(Contact c:a.Contacts)
          {
                 min = c.salary__c;
                sum+=c.salary__c;
                if(max <c.salary__c)
                 {
                     max=c.salary__c;
                
                 }
                avg =sum/a.Contacts.size(); 

          }
          a.Avg_Salary_of_Contacts__c=avg;
          a.Salary_Sum_of_Contacts__c=sum;
          a.Min_Salary_of_Contacts__c=min;
          a.Max_Salary_of_Contacts__c=max;
          acclist1.add(a);
    }
    
 Update acclist1;
 
 }
if(trigger.isdelete)
        {
       
    SET<id> newaccidSET= new SET<Id>();
   
      for(Contact con:trigger.old)
          {
          newaccidSET.add(con.AccountId);
         }
         List <Account> acclist1 = new List <Account>();
         List <Account> acclist =[SELECT id, Min_Salary_of_Contacts__c,Total_Contacts__c,Max_Salary_of_Contacts__c,Salary_Sum_of_Contacts__c,(Select salary__c FROM ContactS order by salary__c DESC) FROM Account where Id In:newaccidSET];

         Decimal min=0;
         Decimal max=0;
         Decimal sum=0;
         Decimal Avg=0;
         
         for(Account a:acclist)
           {
               a.Total_Contacts__c=a.Contacts.size(); 
          for(Contact c:a.Contacts)
          {
                 min = c.salary__c;
                sum+=c.salary__c;
                if(max <c.salary__c)
                 {
                     max=c.salary__c;
                
                 }
                avg =sum/a.Contacts.size(); 

          }
          a.Avg_Salary_of_Contacts__c=avg;
          a.Salary_Sum_of_Contacts__c=sum;
          a.Min_Salary_of_Contacts__c=min;
          a.Max_Salary_of_Contacts__c=max;
          acclist1.add(a);
    }
    
        Update acclist1;
        
        }      
}