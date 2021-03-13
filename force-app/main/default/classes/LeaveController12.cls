public with sharing class LeaveController12 {
    public String empcode { get; set; }
    public String name { get; set; }
    public LeaveController12 (){}

    public PageReference GoToPage2() {
        
        PageReference pf = new PageReference('/apex/LeaveForm2?att='+name );
        PageReference pf2 = new PageReference('/apex/LeaveForm2?att2='+empcode);
        
        return pf;
    }


   
}