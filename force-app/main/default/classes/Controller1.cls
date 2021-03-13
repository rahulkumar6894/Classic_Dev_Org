public class Controller1{

    public Controller1(ApexPages.StandardController controller) {

    }
    public String inputText2 { get; set; }
    public String inputText1 {get;set;}
    public Controller1(){
    }
    public pageReference GoToPage2(){
       Leave__c leave = new Leave__c ();
       leave.Name = ApexPages.currentPage().getParameters().get('Leave__c.Name');  
       leave.Emp_Code__c= ApexPages.currentPage().getParameters().get('Leave__c.EmpCode');
       insert leave ; 
       PageReference pf = new PageReference('/apex/pagetwo?att='+leave.id);  
       return pf ;     
        
        
    }
}