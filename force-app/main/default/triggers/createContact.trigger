/*  
 * Trigger :- when account is created then realated  Contact is also created.
*/
trigger createContact on Account (after insert) {
    List<Contact> listofContact  = new List<Contact>();	
    for(account acc :trigger.new){
        Contact con  = new Contact();
        Con.FirstName = acc.Name;
        con.LastName  = 'Contact';
        Con.AccountId  = acc.Id; 
        listofContact.add(con);
    }
    if(listofContact.size()>0){
        insert listofContact;
    }
}