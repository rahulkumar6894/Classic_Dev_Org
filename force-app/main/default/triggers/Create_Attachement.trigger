trigger Create_Attachement on Attachment (before insert) 
{
    List<Employee2__c> emp = [select id,Summery__c from Employee2__c where id =: Trigger.New[0].ParentId];
    
    if(emp.size()>0)
    {
        emp[0].Summery__c = 'trigger';
        update emp;
    } 
    
}