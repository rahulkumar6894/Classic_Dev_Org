@RestResource(urlMapping='/ItemInfo/*')
   global with sharing class RESTCaseController {
                                                                /*@HttpGet
                                                                global static List<ItemInfo__c> getItemInfo() 
                                                                {
                                                                    //Returns the RestRequest object for our Apex REST method.  
                                                                    RestRequest request = RestContext.request;  
                                                                    //Returns the RestResponse for our Apex REST method.  
                                                                    RestResponse response = RestContext.response;  
                                                                    //query the Box Folder  
                                                                    List<ItemInfo__c> lstItemInfo = new List<ItemInfo__c>();
                                                                    try{
                                                                            lstItemInfo = [SELECT Id, Name FROM ItemInfo__c];  
                                                                            system.debug('######## ' +lstItemInfo);
                                                                       }catch(Exception e){
                                                                    system.debug('@@@@@ Error ' + e.getMessage());
                                                                    }
                                                                    return lstItemInfo ;  
                                                                  }*/
       // Get recard for Iteminfo to particular ID 
       @HttpGet
       global static List<ItemInfo__c> getItemInfo() 
       {
            //Returns the RestRequest object for our Apex REST method.  
            RestRequest request = RestContext.request;  
            //Returns the RestResponse for our Apex REST method.  
            RestResponse response = RestContext.response;  
            //query the Box Folder  
            List<ItemInfo__c> lstItemInfo = new List<ItemInfo__c>();
            try{
            
                    RestRequest req = RestContext.request;
                    String itemId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
                    lstItemInfo = [SELECT Id, Name,Id__c,PathController__c FROM ItemInfo__c where Id = : itemId];  
                    //lstItemInfo = [SELECT Id, Name,Id__c,PathController__c FROM ItemInfo__c];  
                    system.debug('######## ' +lstItemInfo);
               }catch(Exception e)
                {
                    system.debug('@@@@@ Error ' + e.getMessage());
                }
            return lstItemInfo ;  
      }
      
      @HttpPost   
         global static String createItemInfo(String Name,String itemId , String PathController)
         {
                 System.debug('ItemName: '+Name);
                 ItemInfo__c objItem = new ItemInfo__c();
                 objItem.Name = Name;
                 objItem.Id__c= itemId;
                 objItem.PathController__c = PathController;
                 insert objItem;
                 return objItem.id;
        }
    
    @HttpDelete
    global static String deleteRecard()
     {
           RestRequest request = RestContext.request;
           String iditem= request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
           ItemInfo__c deleteItem =  [SELECT Id FROM ItemInfo__c WHERE Id = :iditem];
           delete deleteItem;
           return iditem+ 'Item Deleted';
     }
}