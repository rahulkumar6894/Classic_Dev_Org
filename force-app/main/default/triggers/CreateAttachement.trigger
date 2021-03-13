trigger  CreateAttachement on Employee2__c (after Insert) {

      List<Id> listOfAccId = new List<Id>();
      for(Employee2__c obj : Trigger.new)
      {
            if(obj.Account__c!= null)
            {
                    listOfAccId.add(obj.Account__c); 
            }
       }
    if(listOfAccId.size() > 0)
    {
       Map<Id,Account> accs= new Map<Id,Account>([Select Id, Name from Account where Id in: listOfAccId ]);
       for(Employee2__c emp: Trigger.new)
        {
               if(emp.Account__c!= null)
                {
                        if(accs.containsKey(emp.Account__c))
                        {
                            String accountName = accs.get(emp.Account__c).Name;
                            System.debug('accountName'+accountName);
                            String Namec= emp.Name;
                            
                            String encodedContentsString = 'EmployeeName:--'+Namec+'</br>'+'Related Account:--'+accountName;
                            String pdfContent = '';
                            pdfContent = '<html><head><meta http-equiv=content-type content=text/html;charset=iso-8859-9></meta></head><body>';
                            pdfContent = pdfContent + '<P>' +'EmployeeName:--'+Namec+'<br/>'+'Related Account:--'+accountName+'</P>';
                            pdfContent = pdfContent + '</BODY></HTML>';
                            Attachment attachment = new Attachment();
                            attachment.body = Blob.toPDF(pdfContent);
                            //attachment.Body = Blob.valueOf(encodedContentsString);
                            //attachment.Name = String.valueOf('creteRecord.txt');
                            attachment.Name = 'creteRecord.pdf';
                            attachment.ParentId = emp.Id; 
                            System.debug('attachment'+attachment);
                            insert attachment;
                        }
                }
       }
    }

}
/*for(Employee2__c emp:trigger.new)
    {
        String Namec= Emp.Name;
        String Accountc =Emp.Account__r.Name;
        System.debug('sdaxabsxjoi'+Accountc);
        System.debug('@@@@@@@@@@@@'+Emp.Account__c);
        String encodedContentsString = 'EmployeeName:--'+Namec+'</br>'+'Related Account:--'+Accountc;
      Attachment attachment = new Attachment();
        attachment.Body = Blob.valueOf(encodedContentsString);
        attachment.Name = String.valueOf('creteRecord.txt');
        attachment.ParentId = Emp.Id; 
        insert attachment;
      
    }
     */