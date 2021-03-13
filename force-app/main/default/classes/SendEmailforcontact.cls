global class SendEmailforcontact implements Messaging.InboundEmailHandler {

  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        try{
            System.debug('Email '+envelope.fromAddress); // Email Id where we getting reply
            System.debug('Body'+email.plainTextBody); // Reply Email body
            
            List<String> parts = email.plainTextBody.split('id='); // Split Email body for ID
            string process_InstanceWorkitemID = parts[1].substring(0,15); // Store ProcessInstanceWorkitem Id
            
            List<String> body = email.plainTextBody.split('\n');  
            String Status= body[0].Substring(0); // Store Reply Comments
            System.debug('Status'+Status);
            
            String Approvestatus = '';
            // Check conditon to check Status
            if(Status!= '' || Status!= null)
            {  
                  System.debug('Check=Encode===='+EncodingUtil.base64Encode(Blob.valueOf(Status.toLowerCase())));
                  if(Status.toLowerCase().trim() == 'yes' || Status.toLowerCase().trim() == 'approved' ||  Status.toLowerCase().trim() == 'approve')
                  {
                       Approvestatus = 'Approve';
                  }
                  else if(Status.toLowerCase().trim() == 'no' || Status.toLowerCase().trim() == 'reject' || Status.toLowerCase().trim() == 'rejected')
                  {
                       Approvestatus = 'Reject'; 
                  }
                 /* else{
                     Approvestatus = 'Pending';
                    
                 }*/
            }
           
             System.debug('Approvestatus@@@Final'+Approvestatus);
            // Query to get ProcessInstanceId by Using ProcessInstanceWorkitem ID
            ProcessInstanceWorkitem process_InstanceWorkitem= [SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem where id=:process_InstanceWorkitemID];
            String processInstance_Id= process_InstanceWorkitem.ProcessInstanceId;
            System.debug('ProcessInstance_Id'+processInstance_Id);
             
            // Get Contact Id using ProcessInstance Id
            ProcessInstance process_Instance= [SELECT Id, ProcessDefinitionId, TargetObjectId FROM ProcessInstance where  id=:processInstance_Id];
            String conID = process_Instance.TargetObjectId;
            System.debug('conId'+conID);
            
            List<ProcessInstanceWorkitem> workItems = [ SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem  WHERE   ProcessInstance.TargetObjectId = :conID];
            System.debug('workItems'+workItems); 
            List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
            for(ProcessInstanceWorkitem workItem : workItems){
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setWorkitemId(workItem.Id);
                //Valid values are: Approve, Reject, or Removed. 
                //Only system administrators can specify Removed.
                req.setAction(Approvestatus);
                req.setComments('Comment.');
                requests.add(req);
           }
           Approval.ProcessResult[] processResults = Approval.process(requests);
           return result;
        }catch(System.DMLException e){
                System.Debug('Error'+ e.getMessage());         
       }
       return result;
    }
}