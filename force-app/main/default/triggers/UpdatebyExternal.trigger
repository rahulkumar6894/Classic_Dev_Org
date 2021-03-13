trigger UpdatebyExternal on Custom_Event__e (after Insert) {
    map<String,String> maptofEvent = new map<String,String>();
    List<Employee__c> sListofEmployee = new List<Employee__c>();
    
    for(Custom_Event__e eventObj:trigger.new){
        maptofEvent.put(eventObj.AccountId__c,eventObj.Update_by_Platform_Event_update__c);
        System.debug('maptofEventUpdatebyExternal>>>>'+maptofEvent);
    }
    
    if(maptofEvent.Size()>0){
        sListofEmployee = [Select Id,Update_by_Platform_Event_update__c from Employee__c where Id in:maptofEvent.keyset()];
    }
    
    if(sListofEmployee.size()>0){
        for(Employee__c empobj :sListofEmployee)
        {
            String EmpId = String.valueOf(empobj.Id).substring(0, 15);
            empobj.Update_by_Platform_Event_update__c = maptofEvent.get(EmpId); 
        }
        try{
            update sListofEmployee;
        }catch(exception e){
            System.debug('><><exception ><><><'+ e.getLineNumber());
            System.debug('><><getMessage><><><'+ e.getMessage());
        }
    }
}