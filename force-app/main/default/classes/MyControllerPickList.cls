public class MyControllerPickList {
    List<Schema.SObjectType> gd {get;set;}
    public String Obj{get;set;}
    List<SelectOption> options {get;set;}
    public List<SelectOption> getName()
   {
    gd = Schema.getGlobalDescribe().Values();  
     options = new List<SelectOption>();
    for(Schema.SObjectType f : gd)
    {
       options.add(new SelectOption(f.getDescribe().getLabel(),f.getDescribe().getLabel()));
    }
    return options;
   }


}