public with sharing class birthday_ctrl {
       
    public BirthDay__c  birth { get; set; }
    List<BirthDay__c> birthlist;
   
    public  birthday_ctrl () {
        birth = new BirthDay__c  ();
         birthlist = [Select Id,Mobile__c from BirthDay__c];
    }
    public PageReference save() {
        
        try {
            System.debug('birthnnnnnnnnnnn'+ birth);
            insert(birth );
            birth = null;
        	return null;
        } catch(System.DMLException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            
        }
        return null;
        
    }
    
}