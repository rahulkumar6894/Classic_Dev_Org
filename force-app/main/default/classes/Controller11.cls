public with sharing class Controller11 {

    public string MYdateto { get; set; }

    public string MYdate { get; set; }

    public String Approved { get; set; }

    public String Leave { get; set; }

    

    public String inputText4 { get; set; }

    public String inputText3 { get; set; }
    public String inputText1 { get; set; }
    public String inputText2 { get; set; }
    
    public  Controller11(){
    inputText1 = ApexPages.currentPage().getParameters().get('Name');
    inputText2 = ApexPages.currentPage().getParameters().get('EmpCode');
    inputText3 = ApexPages.currentPage().getParameters().get('Department');
    inputText4 = ApexPages.currentPage().getParameters().get('Reason'); 
    Leave      = ApexPages.currentPage().getParameters().get('Leave'); 
    Approved   = ApexPages.currentPage().getParameters().get('Approved'); 
    MYdate     = ApexPages.currentPage().getParameters().get('MYdate');
    MYdateto   = ApexPages.currentPage().getParameters().get('MYdateto');
    System.debug('Mydate&&&&&&'+ApexPages.currentPage().getParameters().get('MYdateto')); 
    }
 // pageReference Method to redirect another page
     public PageReference GoToPage2() {
      PageReference pf = new PageReference('/apex/LeaveFormTwo');  
      pf.getParameters().put('Name', string.valueof(inputText1) );
      pf.getParameters().put('EmpCode',string.valueof(inputText2) );
      pf.getParameters().put('Department',string.valueof(inputText3 ) );
      pf.getParameters().put('Reason',string.valueof(inputText4 ) );
      pf.getParameters().put('Leave',string.valueof(Leave ) );
      pf.getParameters().put('Approved',string.valueof(Approved) );
      pf.getParameters().put('MYdate',String.valueof(MYdate));
      pf.getParameters().put('MYdateto',String.valueof(MYdateto));
      pf.setRedirect(true);
      system.debug('***MYdate****'+MYdate);
      
      return pf ;   
    }


   

   
}