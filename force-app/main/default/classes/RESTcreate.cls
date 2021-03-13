@RestResource(urlMapping='/createItemInfo/*')
   global with sharing class RESTcreate{
  
  @HttpPost   
     global static String createItemInfo(String Name,String itemId , String PathController)
     {
         System.debug('ItemName: '+Name);
         ItemInfo__c objItem = new ItemInfo__c();
         objItem.Name = Name;
         objItem.Id__c= itemId;
         objItem.PathController__c = PathController;
         insert objItem;
         return null;
    }
  }