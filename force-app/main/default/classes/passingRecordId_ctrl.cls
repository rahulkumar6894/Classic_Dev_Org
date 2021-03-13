public with sharing class passingRecordId_ctrl {
    public String myname;

    public PageReference RedirectUrlWithId()
    {
        try{
                /*PageReference requestpage = page.passing_record_id_in_url();
                requestpage.getParameters().put(myname,'RahulKasaudhan');
                requestpage.setRedirect(true);
                return requestpage;
              Pagereference p=new Pagereference('/apex/passing_record_id_in_url?acctId=RAHUL');
   			 p.setredirect(true);
				 return p;
            PageReference result=Page.redirectPage;
            result.getParameters().put('param1', 'value1');
            result.getParameters().put('param2', 'value2');
            result.setRedirect(true);
            
            return result;*/
		 PageReference nextpage = new PageReference('/apex/redirectPage?msg=rahul');
                return nextpage;
        }catch(Exception ex ){
            
            System.debug('Error Line No'+ex.getLineNumber());
            // System.debug('Error getMessage'+ex.getMessage());
            return null;  
        }//apex/YourVisualForcePage?acctId={!RelantionshipName__c}
    }

}