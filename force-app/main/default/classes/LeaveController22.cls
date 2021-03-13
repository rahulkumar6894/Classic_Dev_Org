public with sharing class LeaveController22 {

    public String empcode { get; set; }

    public String name { get; set; }
    public LeaveController22 (){
    name = apexpages.currentpage().getparameters().get('att');
    //empcode = apexpages.currentpage().getparameters().get('att');
    }
}