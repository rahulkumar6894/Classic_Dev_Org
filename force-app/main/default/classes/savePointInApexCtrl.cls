public with sharing class savePointInApexCtrl {

    public PageReference savePoint() {
        Savepoint sp = Database.setSavepoint();

    try{
         Account acc;
           acc = new Account(Name='Save Point2');
        insert acc;
        System.debug('hghhggh'+acc.Id);
       Contact Con =  new Contact(AccountId=acc.Id);
        insert COn;
                System.debug('hghhggh'+Con.Id);

    }catch(exception e){
    Database.rollback(sp);

       system.debug('Error in savePoint'+e.getLineNumber());
               system.debug('Error in savePoint'+e.getMessage());

    }
        return null;
    }

}