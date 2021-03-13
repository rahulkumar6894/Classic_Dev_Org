public class GetObjectName_ctrl {

  
  
    public Id recId {get;set;}  
    public Schema.SObjectType objType {get;set;}  
      
    public void find() {  
  
  
        objType = recId.getSobjectType();  
        System.debug('Object Type is ' + objType);  
  
  
    }  
  
  

}