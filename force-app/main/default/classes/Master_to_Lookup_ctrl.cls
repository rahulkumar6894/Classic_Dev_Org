public with sharing class Master_to_Lookup_ctrl {

  public Pipeline__c objSourcePipeline{get;set;} 
  public Account Acc {get;set;} 
  public Master_to_Lookup_ctrl(){
        
        objSourcePipeline = new Pipeline__c();
        Acc = new Account();
    }
  public PageReference executeQuery() {
       //SObject so = Schema.getGlobalDescribe().get('Pipeline__c').newSObject();
       boolean isfieldOrg =   Schema.getGlobalDescribe().get('Pipeline__c').getDescribe().fields.getMap().containsKey('Company2__c');
      System.debug('isfieldOrg><><>'+isfieldOrg);
      if(isfieldOrg){
          Insert  Acc;
          objSourcePipeline.Company2__c = Acc.id;
           objSourcePipeline.Company__c = Acc.id;
          insert objSourcePipeline; 
      }
      
      objSourcePipeline = new Pipeline__c();
        Acc = new Account();
      return null;
    }
}