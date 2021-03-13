public with sharing class PicklistControllerl {

    public PageReference getrecords() {
        return null;
    }


    


    public list<Sobject> selectedobj { get; set; }

     public String Obj{get;set;}
     public String objectName{get;set;}
 
     
    public List<SelectOption>getName()  {
    
                    List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();  
                     List<SelectOption> options  = new List<SelectOption>();
             for(Schema.SObjectType f : gd)
                    {
                        options.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getName()));
                         }
                  return options;
                        }
         

  public List<Sobject> records() {

     if(objectName!=null || objectName !='')
     {
         selectedObj=new List<Sobject>();
         Schema.sobjectType sobj=Schema.getGlobalDescribe().get(objectName);
         selectedObj=Database.query('Select name from '+ sobj);
     }

     return null;
    }

public PageReference Edit() {
Schema.DescribeSObjectResult result = Schema.getGlobalDescribe().get(objectName).getDescribe();
PageReference pageRef = New PageReference('/' + result.getKeyPrefix() + '/e');
pageRef.setRedirect(true);

return pageRef;

}
            
  }