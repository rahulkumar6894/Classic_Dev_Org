public class ObjectController {

   Public List<Opportunity> optyList {get;set;}
   Public List<contact> conList{get;set;}
   Public List<account> accList{get;set;}
   Public String searchStr{ get; set; }

  
     public String objectName{get;set;}
     public List<Sobject> selectedObj {get;set;}
     
     public List<SelectOption> getName()
     {
       List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();  
       List<SelectOption> options = new List<SelectOption>();
     
       for(Schema.SObjectType f : gd)
       {
       options.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getName()));
       }
       System.debug('+++++++++++++'+options);
       return options;
    }

public List<Sobject> getrecords() {

     if(objectName!=null && objectName !='')
     {
         selectedObj=new List<Sobject>();
         Schema.sobjectType sobj=Schema.getGlobalDescribe().get(objectName);
         selectedObj=Database.query('Select name,ID,CreatedByID,LastModifiedByID from '+ sobj);
     }

     return null;
    }
    
     public PageReference getNew() {
        Schema.DescribeSObjectResult  result = Schema.getGlobalDescribe().get(ObjectName).getDescribe();
        PageReference pageRef = New PageReference('/' + result.getKeyPrefix() + '/e');
        pageRef.setRedirect(true);
        return pageRef;
    }

  public void SeachMethod()
  {
        /*optyList = New List<Opportunity>();
        conList = New List<contact>();
        accList = New List<account>();
        if(searchStr.length() > 1)
        {
            String searchStr1 = '*'+searchStr+'*';
            String searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING  Account (Id,Name,type),Contact(name,email),Opportunity(name,StageName)';
            List<List <sObject>> searchList = search.query(searchQuery);
            accList = ((List<Account>)searchList[0]);
            conList  = ((List<contact>)searchList[1]);
            optyList = ((List<Opportunity>)searchList[2]);
            if(accList.size() == 0 && conList.size() == 0 && optyList.size() == 0)
            {
                apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Sory, no results returned with matching string..'));
                return;
            }
        }
            else{
            apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Please enter at least two characters..'));
        return;
        }*/
        
    }

}