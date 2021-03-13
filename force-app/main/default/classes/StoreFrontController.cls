public class StoreFrontController {
    List<DisplayMerchandise> products;
       public List<DisplayMerchandise> getProducts() {
              if(products == null) {
                  products = new List<DisplayMerchandise>();
                          for(Merchandise__c item : [SELECT Id, Name,Condition__c,Price__c FROM Merchandise__c])
                          {
                                    products.add(new DisplayMerchandise(item));
                                      }
                                           }
                                    return products;
       }

            
    public class DisplayMerchandise{
        private Merchandise__c merchandise;
        public DisplayMerchandise(Merchandise__c item) { this.merchandise=item;}
        public string Name{
            get{ return merchandise.Name;}
        }
            public Decimal Price{
            get{ return merchandise.Price__c;}
            }
                public string Condition{
            get{ return merchandise.Condition__c;}
        }
            
            
        
        
    }
}