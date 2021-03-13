public class MyController {

    public PageReference save() {
        return null;
    }

    list<Merchandise__c> products;
    public list<Merchandise__c> getProducts(){
        if(products==Null){ 
        products=[Select id,Name,Price__c ,Condition__c from Merchandise__c];
        }
            
        return  products;
        
    }

}