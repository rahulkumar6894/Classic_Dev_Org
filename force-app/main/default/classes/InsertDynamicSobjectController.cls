public class InsertDynamicSobjectController
{
    public String ObjectName {get; set;}
    
    public String RecordName {get; set;}
    
    public InsertDynamicSobjectController()
    {
        ObjectName = '' ;
        RecordName = '' ;
    }
    
    public PageReference Save()
    {
        //use GlobalDecribe to get a list of all available Objects
         // Map gd = Schema.getGlobalDescribe();
          /*
          Map<String, SObjectType> gd = Schema.getGlobalDescribe();
        Set objectKeys = gd.keySet();
        if(gd.contains(Objectname.toLowerCase()))
        {
            try
            {
                //Creating a new sObject
                sObject sObj = Schema.getGlobalDescribe().get(ObjectName).newSObject() ;
                sObj.put('name' , RecordName) ;
                insert sObj ;
                
                PageReference pg = new PageReference('/'+sObj.Id) ;
                return pg ;
            }
            Catch(Exception e)
            {
                ApexPages.addMessages(e) ;
                return null ;
            }
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Object API name is invalid')) ;
            return null ;
        }
        */
        return null ;
    }
}