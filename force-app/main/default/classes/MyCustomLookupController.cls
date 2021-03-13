public with sharing class MyCustomLookupController {


      public Contact contact {get;set;}
      public Id selectedAccId{get;set;} 
      public Id selectedAccId2{get;set;} 
      public  integer count {get;set;}
      public List<Contact> conlist {get;set;}      
      public List<Contact> conlist2 {get;set;} 
  public MyCustomLookupController(ApexPages.StandardSetController controller)
  {
          
    contact = new Contact();
  }
  public Void readAcoountId()
  {
       selectedAccId = contact.AccountId;
       System.debug('selectedAccId2 ^^^^@@@@'+selectedAccId2 );
       count = 0;
        conlist=[select name,phone,Contact.AccountId from Contact where Accountid=: selectedAccId];
        for(Contact c :[select  name,phone,Contact.AccountId from Contact where Accountid=: selectedAccId] )
        {
            Count++;
            System.debug('Count'+Count);
        }
      
  }
      public List<SelectOption> getAccountNames() 
      {
        List<SelectOption> accOptions= new List<SelectOption>();
        system.debug(selectedAccId);
        accOptions.add( new SelectOption('','--Select--'));
        for(Account acc : [select  Id,name from Account ] ) 
        {
            accOptions.add(new SelectOption(acc.Id,acc.name));
        }
        return accOptions;
    }

    public PageReference showContacts()
    {
        count = 0;
        conlist=[select name,phone,Contact.AccountId from Contact where Accountid=: selectedAccId];
        for(Contact c :[select  name,phone,Contact.AccountId from Contact where Accountid=: selectedAccId] )
        {
            Count++;
            System.debug('Count'+Count);
        }
        return null;   
        
    }
    public iD contactobj{get;set;}
    
    public List<SelectOption> getcontactNames()
     {
        List<SelectOption> contactoptions = new List<selectOption>();
        contactoptions.add( new SelectOption('','--Select--'));
        for(Contact c : [Select Id,Name From Contact])
        {
            contactoptions.add(new SelectOption(c.Id,c.Name ));
        }
        return contactoptions ;
    }
    public PageReference ContactDetails() 
    {
        System.debug('Hello'+contactobj);
        return null;
    }
    public void Uploadfile() 
    {
        System.debug('Hello'+contactobj);
    }
 
}