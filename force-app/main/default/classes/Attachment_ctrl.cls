public with sharing class Attachment_ctrl {

    transient  public Blob resume {get;set;}  // Attribute to get file 
    public String contentType {get; set;}  // Attachment Type
    public String fileName {get; set;}  // Attachment Name
    public Id RecordId {get; set;}   // Get Id form Url
    public Id selectedId {get; set;}  // Record Id to get and and upload attachment
    public Boolean readValue {get;set;}
    public List<Attachment> attachsList {get; set;}  // Attachment Record List
    public Id DeletedId {get; set;}  // id for delete Attachment
    public String  resultStatus {get;set;} // get Status for DeleteAfile method
    public List<Attachment> delList{get; set;}  // Attachment Record List
      
    // constructer
    public Attachment_ctrl() 
    {
          attachsList  = new List<Attachment>();
          delList= new List<Attachment>();
          RecordId = apexpages.currentpage().getparameters().get('id');
        
    }
    // Method to get all Account Record and create pickList 
    public List<SelectOption> getAccountNames() 
    {
        List<SelectOption> accOptions= new List<SelectOption>();
        accOptions.add( new SelectOption('','--Select--'));
        for(Account emp: [select  Id,name from Account order by createdDate] ) 
        {
            accOptions.add(new SelectOption(emp.Id,emp.name));
        }
        return accOptions;
    }
    // method call to showAttchments
    public void showContacts()
    {
      
      ShowAttachments();
      readValue = true; 
    }
    // Method to get Attachments list Select Contact
    public void ShowAttachments()
    {
           System.debug('selectedId__ShowAttachments'+selectedId);
          
           attachsList = [select Id, Name from Attachment where ParentId= :selectedId ];
          /* List<Employee__c > Emplistforatt =[SELECT Id,(SELECT Id, Name FROM Attachments) FROM Employee__c  Where Id= :selectedId ];
        for(Employee__c emp: Emplistforatt  ) 
        {
                attachsList = emp.Attachments;
         
        }*/
      
    }
    // Method for upload file in attchement
    public void Uploadfile()
    {
        System.debug('resume'+resume);
        System.debug('selectedId '+selectedId );
        System.debug('fileName '+fileName );
        System.debug('contentType'+contentType);
        if(resume!=null)
        {
            System.debug('1');
            Attachment attach=new Attachment();
            attach.Body=resume;
            attach.Name=fileName ;
            attach.ContentType=contentType;
            attach.ParentID=selectedId ;
            try 
            {
                    System.debug('2');
                    insert(attach);
                    ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.CONFIRM,'Your Attachment Succesfuly Upload. ' );
                    ApexPages.addmessage(msg);
            } catch(System.DMLException e) {

                    System.debug('ERROR:' + e.getTypeName() + ': ' + e.getMessage() );                  }
        }else{
                ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'No Record Found' );
                ApexPages.addmessage(msg);
                system.debug('error');
        }
        //PageReference p = new PageReference ('https://rahulkasaundhan-dev-ed.my.salesforce.com/'+RecordId);
        //PageReference congratsPage = Page.Congratulations;
        //congratsPage.setRedirect(true);
        //congratsPage.getParameters().put('id',controller.getId());
        //PageReference p = new PageReference(ApexPages.currentPage().getUrl());
        // Employee__c enp =new Employee__c();
        // PageReference p = new ApexPages.StandardController(enp).view();
        // p .setRedirect(true);
        // return p ;  
    }
    public PageReference DeleteAfile()
    {
          
            System.debug('DeletedId '+DeletedId );
            delList = [select Id, Name from Attachment where Id= :DeletedId ]; 
            delete delList ;
            resultStatus = 'Done';
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'Done' );
            ApexPages.addmessage(msg);
            return null;
     } 

   
 
}