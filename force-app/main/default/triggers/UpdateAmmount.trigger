trigger UpdateAmmount on Salary__c (before insert) {
 
    IF(Trigger.IsInsert ){
        for(Salary__c  obj : Trigger.new){
           obj.Amount__c = 92;
        }
     
    }
}