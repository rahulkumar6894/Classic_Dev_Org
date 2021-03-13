public class PicklistController {

    public String options { get; set; }
     public string obj{get; set;}
     public String objectName{get;set;}
     public List<String> objFields {get;set;}
     public List<Sobject> selectedObj{get;set;}
    
  public List<SelectOption> getName()
  {
    List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();  
    List<SelectOption> options = new List<SelectOption>();
    for(Schema.SObjectType f : gd)
    {
       options.add(new SelectOption(f.getDescribe().getLabel(),f.getDescribe().getLabel()));
    }
    return options;
   }
    
    public List<Sobject> getrecords()
 {
     if(objectName!=null||objectName!='')
     {
         selectedObj=new List<Sobject>();
         Schema.sobjectType sobj=Schema.getGlobalDescribe().get(objectName);
         selectedObj=Database.query('Select Name from '+sobj);
     }
     return null;

 }


}