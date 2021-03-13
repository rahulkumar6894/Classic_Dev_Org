public class Controller2{
    public leave__c objL{get;set;}
    public Controller2(ApexPages.StandardController controller) {

    }

    public String inputText2 {get;set;}
    public Controller2(){
        objL = new leave__c();
        string objId= apexpages.currentpage().getparameters().get('att');
        system.debug('******objId***'+objId);
        objL=[Select id, name from Leave__c where id=:objId];
        system.debug('******objL***'+objL);
    }
}