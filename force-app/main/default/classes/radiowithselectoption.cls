public with sharing class radiowithselectoption {

   


   public list<SelectOption> deallist{ get; set; }
   public String accountid { get; set; }
   public String orderType {get;set;}
   public String  editordertype {get;set;}
   public radiowithselectoption()
   {             
                  deallist = new list<SelectOption>();  
                  deallist.add(new selectoption('','-None-'));
                  
                  for(Employee__c emp :[SELECT Id,Name FROM Employee__c ORDER BY Name asc limit 5])
                  {
                    deallist.add(new selectoption(emp.Id,emp.Name));
                    deallist.sort();
                  }
   }
   
   
    public void getaccount() 
    {
        System.debug('accountid'+accountid);
        
        for(firnSetting__c frmsetting:[SELECT Id, DealId__c, folder_order_type__c FROM firnSetting__c where DealId__c =:accountid limit 1])
        {
           orderType = frmsetting.folder_order_type__c ;
        }
        System.debug('orderType '+orderType );
    } 
    public void updatefirmsetting() 
    {
       System.debug('accountid'+accountid);
       System.debug('editordertype '+editordertype);
    }

   
}