/***********************************PURPOSE***************************************
*     Whenever a new record  of opportunity is created or Updated and the StageName field 
*     in the Opportunity object has value Qualification then a Send Mail to owner.

*********************************************************************************/


trigger UpdateStage on Opportunity (after insert,after update) {
    
    if(trigger.isinsert)
    {
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

    if(trigger.isupdate)
    {

        List<Messaging.SingleEmailMessage> listmail= new List<Messaging.SingleEmailMessage>(); 

        for(Opportunity opp : trigger.new)
        {  
        if(opp.StageName != Trigger.oldMap.get(opp.Id).StageName ){
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
        }
        Messaging.sendEmail(listmail); 
    }
}