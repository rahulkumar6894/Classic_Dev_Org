global class sendEmail_ctrl{
        
    webservice static void  sendmail(Id ConId,String ConEmail)
    {
      try{
            System.debug('ConId'+ConId);
            System.debug('ConEmail'+ConEmail);
            
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            System.debug('baseUrl'+baseUrl);
            
            ProcessDefinition process_Definition = [SELECT Id, Name FROM ProcessDefinition where Name='Approval Process for Contact'];
            String process_DefinitionId = process_Definition.Id;
            System.debug('process_DefinitionId'+process_DefinitionId);
            
            ProcessInstance process_Instance  =[ SELECT Id, ProcessDefinitionId, TargetObjectId FROM ProcessInstance where ProcessDefinitionId =:process_DefinitionId  AND TargetObjectId =:ConId];
            String process_InstanceId  = process_Instance.Id;
            System.debug('Process_Instanceid '+process_Instance);
            
            ProcessInstanceWorkitem process_InstanceWorkitem = [SELECT Id, ProcessInstanceId, ActorId, OriginalActorId FROM ProcessInstanceWorkitem where ProcessInstanceId =:process_InstanceId  ];
            String process_InstanceWorkitemId = process_InstanceWorkitem .ID;
            System.debug('process_InstanceWorkitemId '+process_InstanceWorkitemId );
            
            String final_process_InstanceWorkitemId = process_InstanceWorkitemId.substring(0,15);
            System.debug('final_process_InstanceWorkitemId '+final_process_InstanceWorkitemId );
            
            String url = +baseUrl+'/p/process/ProcessInstanceWorkitemWizardStageManager?id='+final_process_InstanceWorkitemId;
            System.debug('FinalURl'+url);
            
            EmailTemplate templateId = [SELECT Id,Subject,body, Name FROM EmailTemplate where name ='Approval Template'];
            
            String[] toAddresses = new String[] {ConEmail};   // Array of String to send Mail.
            
            String plainBody = templateId.Body;
           //below replaces the MYURL with dynamic MYURL
            plainBody = plainBody .replace('MYURL',url);
            String Subject = templateId.Subject;
        
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setTemplateID(templateId.Id); 
            mail.setReplyTo('send_email@q-1mah4zhg2te1mwkeqyos31v2erf57bamr7o8lkqgl475zxtvdm.7f-skpeuae.ap5.apex.salesforce.com'); // My Email Service Link to reply mail.
            mail.setTargetObjectId(ConId);
            mail.setPlainTextBody(plainBody);
            mail.setSubject(Subject);
           
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            for (Attachment a : [select Name, Body, BodyLength from Attachment where ParentId = :ConId])
            {
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(a.Name);
                efa.setBody(a.Body);
                fileAttachments.add(efa);
            }
            mail.setFileAttachments(fileAttachments);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
         }catch(System.DMLException e){
                    System.Debug('Error'+ e.getMessage());         
                }
    }
    

        
  
    
}