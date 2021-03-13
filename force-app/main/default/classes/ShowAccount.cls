public with sharing class ShowAccount {

   
   // TaskList to retrive value from different Object
    public List<task> lstAccount{get;set;} // List of task for Sobject
    public List<Sobject> listId {get;set;} // List of Id to retrive Task for Sobject
    public String stringVal;   // Attribute Value of different Page  var AsignTo stringVal
    
    // Attribute Value Set
    public void setstringVal(string stringVal )
    {
      this.stringVal =stringVal ;
      List<sObject> listId = Database.query('SELECT Id FROM ' +stringVal);
      if(stringVal =='Contact')
      {
       lstAccount= [SELECT Id,subject,Status,Priority,who.Name,What.Name FROM task where WhoId in: listId ];
      }else{
      lstAccount= [SELECT Id,subject,Status,Priority,who.Name,What.Name FROM task where whatid in: listId ];
      } 
    }
     // Attribute Value Get
    public String getstringVal()
    {
    return stringVal;
    }
    
    
   // Page Reference For Account 
   public PageReference ShowAccount() {
   PageReference pf = new PageReference('/apex/AccountPage');
   pf.setRedirect(true);
   return pf; 
   }
      
    // Page Reference For Conatct
    public PageReference ShowContact() {
    PageReference pf = new PageReference('/apex/Contactpage');
    pf.setRedirect(true);
    return pf;
    }   
   // Page Reference For Employee2
   public PageReference ShowEmployee2() {
   PageReference pf = new PageReference('/apex/Employee2Page');
   pf.setRedirect(true);
   return pf;
   }  
    
    
    
    
   
        

    

}