global  class Birthdaydetails_ctrl Implements Schedulable {
    public Birthdaydetails_ctrl(){
        //Showdetails();
    }
    global void execute(SchedulableContext sc)
    {
        Showdetails();
    }
    public PageReference Showdetails() {
       date myDate = Date.today()+1;
       // date myDate = Date.today();
        Integer currentMonth = myDate.Month();
        String scurrentMonth = String.valueOf(currentMonth);
        
        List<BirthDay__c> listofbirth = [SELECT Id, Name, format(BirthDate__c), BirthEmail__c, BirthAddress__c, Mobile__c, BirthMsg__c, Month__c, Current_City__c, Hometown__c, Meet_loaction__c, State__c FROM BirthDay__c where Month__c =: scurrentMonth ];
        System.debug('listofbirth<><><'+listofbirth);
        
        if(listofbirth.size()>0 )
        {
            string Emailbody1 ='Hello  Rahul ;<br/><br/>Tomorrow friends Birthday List:<br/><br/>'; 
            String Emailbody2 = '<table cellspacing ="0" cellpadding = "5" style="width:100%" border="0"><tr><td style="border:#000 1px solid;border-right:none;"><b>Birth Name</b></td><td style="border:#000 1px solid; border-right:none;"><b>Mobile Number</b></td><td style="border:#000 1px solid; border-right:none;"><b>Birth Date</b></td><td style="border:#000 1px solid;"><b>Email</b></td></tr>';           
            String Emailbody3 ='';
            String lastfinalbody ='';
            for(BirthDay__c Bobj: listofbirth)
            {
                String birthDay =  String.valueOf(Bobj.BirthDate__c.day());
                String currentDay = String.valueOf(myDate.day());
                if(Bobj.BirthDate__c !=null && currentDay == birthDay ){
                    Emailbody3 = Emailbody3+'<tr><td style="border:#000 1px solid; border-top:none; border-right:none;">'+Bobj.Name+'</td><td style="border:#000 1px solid; border-top:none; border-right:none;"><a>'+Bobj.Mobile__c+'</a></td><td style="border:#000 1px solid; border-top:none; border-right:none;">'+Bobj.BirthDate__c+'</td><td style="border:#000 1px solid; border-top:none;">'+Bobj.BirthEmail__c+'';
                }
            } 
            lastfinalbody = Emailbody1+Emailbody2+Emailbody3+'</table>';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
				String[] toAddresses = new String[] {'rahulkumar6894@gmail.com'}; 
				String[] ccAddresses = new String[] {'rahulkumar6894@gmail.com'};
				mail.setToAddresses(toAddresses);
				mail.setCcAddresses(ccAddresses);
				mail.setReplyTo('rahulkumar6894@gmail.com');
				mail.setSubject('Tomorrow friends Birthday List');
				mail.setHtmlBody(lastfinalbody);
            if(String.isNotBlank(Emailbody3))
            {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            // Send the email you have created.
            
        }
        
        return null;
    }
    
}