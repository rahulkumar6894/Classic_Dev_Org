public class try_and_catch  {
    public void show(){
        
        try{
          
              Account a=new Account();
               a.Name='';
              insert a;
        }catch(Exception e){
            System.debug('Your Error:-'+e.getMessage());
            System.debug('Your Error LineNumber:-'+e.getLineNumber());
            System.debug('Your Cause:-'+e.getCause());
            System.debug('Your getTypeName:-'+e.getTypeName());
          
            
        }finally {System.debug('Hello! i am finaly');}


}
}