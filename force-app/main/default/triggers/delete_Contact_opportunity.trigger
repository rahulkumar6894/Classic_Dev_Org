/*  
 * Trigger :- when account is created then realated  Contact is also created.
*/
trigger delete_Contact_opportunity on Account (before delete) {
   set<Id> setofId = new Set<Id>();
    for(Account accobj : trigger.old){
        setofId.add(accobj.id);
    }
    List<Contact> listofContact = [Select Id,AccountId from Contact where AccountId in:setofID];
    delete listofContact;
    List<opportunity> listofopp =[Select Id,AccountId from opportunity where Accountid in:setofId];
    delete listofopp;
        
}