global with sharing class RESTdelete{

  global static String deleteRecard(String itemid)
     {
         System.debug('ItemName: '+itemid);
         ItemInfo__c deleteItem =  [SELECT Id FROM ItemInfo__c WHERE Id = :itemid];
         delete deleteItem;
         return null;
      }
      }