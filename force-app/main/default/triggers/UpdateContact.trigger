/***********************************PURPOSE***************************************
 *     Whenever a new record  of opportunity is created and the amount field 
 *              in the Opportunity object has some value then-
 *        new record against a contact selected should be created with the 
 *  'last gift amount field in contact object' equal to 'opportunity Amount Field'
 *********************************************************************************/
trigger UpdateContact on Opportunity (after insert,after update,after delete,after undelete) 
{
    Map<Id,Opportunity> idVsOpp = new Map<Id,Opportunity>();
    if(trigger.isinsert || trigger.isupdate || trigger.isundelete )
    {      
         for(Opportunity oppObj : trigger.new) 
        {
            
            if(String.isNotEmpty(oppObj.ContactOpp__c))
            {
              idVsOpp.put(oppObj.ContactOpp__c,oppObj );
            }
        }
        List<Contact> contactlist = [Select Id,last_gift_amount__c ,Name from Contact Where id=:idVsOpp .keySet() ];
        for(Contact obj : contactlist )
        {
            obj.last_gift_amount__c = idVsOpp.get(obj.Id).Amount;
        }
        if(contactlist.size() > 0)
        {
            update contactlist;
        } 
    }
    if(trigger.isDelete)
    {
            
        set<Id> delOppId =  new  set<Id>();
        for(Opportunity oppObj : Trigger.old) 
        {
            delOppId.add(oppObj.ContactOpp__c);
        }
        List<Contact> contactlist2 = [Select Id,last_gift_amount__c ,Name from Contact Where id=:delOppId ];
        for(Contact obj : contactlist2 )
        {
           obj.last_gift_amount__c = null;
        }
        if(contactlist2.size() > 0)
        {
            update contactlist2;
        } 
    }
   
}