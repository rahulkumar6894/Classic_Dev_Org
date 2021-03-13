/***********************************PURPOSE***************************************
*     Whenever a new record  of opportunity is created and the StageName field 
*     in the Opportunity object has value Qualification then a Send Mail to owner.

 *********************************************************************************/


trigger emailtemplate on Opportunity(after insert, after delete,after update,after undelete){
if(trigger.isinsert || trigger.isupdate  || trigger.isundelete)
{


/*
                // WITHOUT EMAIL TEMPLATE 
                 
List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();          
                      
   for(Opportunity opp : trigger.new)
    {
      if(opp.StageName =='Qualification')
        {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                List<String> addresses = new List<String>();
                email.setSubject('Subject for Email!!!');
                String msg = 'Dear ' + opp.Name + ', <br/>';
                msg += 'You are invited for party!!!';
                email.setHTMLBody(msg);
                addresses.add('rahulkumar6894@gmail.com');
                email.setToAddresses(addresses);
                emails.add(email);
            }
           
           }
            Messaging.SendEmailResult [] res = Messaging.sendEmail(emails);
 */
     
     
     
     
   List<Messaging.SingleEmailMessage> listmail= new List<Messaging.SingleEmailMessage>(); 
   
   for(Opportunity opp : trigger.new)
    {
      if(opp.StageName =='Qualification')
        {
            Messaging.SingleEmailMessage SendMail = new Messaging.SingleEmailMessage();
            SendMail .setTargetObjectId(opp.OwnerId);
            SendMail .setTemplateId('00X7F000000HyVa') ;
            SendMail.setSaveAsActivity(false);
            SendMail.setSubject(' Mail From Oppertunity');
            String msg= 'Dear ' + opp.Name + ', <br/>';
            msg+= 'You are invited for party!!!';
            SendMail .setHTMLBody(msg);
            
            listmail.add(SendMail);
        }
    
    }
 Messaging.sendEmail(listmail); 
 

 
  }
}