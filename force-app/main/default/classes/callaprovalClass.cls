global class callaprovalClass{
        
        webservice static void  submitAndProcessApprovalRequest(Id localId)
         {
            
            try{
                    System.debug('localId'+localId);
                    // Create an approval request for the Contact
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval');
                    req1.setObjectId(localId);
                    // Submit the approval request for the Contact
                    Approval.ProcessResult result = Approval.process(req1);
               }catch(System.DMLException e){
                    System.Debug('Error'+ e.getMessage());         
                }
       }
        
}