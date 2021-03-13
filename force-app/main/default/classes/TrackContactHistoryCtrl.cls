public with sharing class TrackContactHistoryCtrl {
    String sContactId;
    public map<String,ContactHistory> mapofTrackfiled {get;set;}
    public Boolean isNoData {get;set;}
    public TrackContactHistoryCtrl(ApexPages.StandardController controller) 
    {
        try{
            sContactId =ApexPages.currentPage().getParameters().get('conId');
            mapofTrackfiled = new  map<String,ContactHistory>();
            isNoData =false;
            List<ContactHistory> trackHistory = [SELECT Id,CreatedDate, Field, OldValue, NewValue FROM ContactHistory Where ContactId =:sContactId] ;
            if(trackHistory.size()>0)
            {
                for(ContactHistory filedObj :trackHistory )
                {
                    if(mapofTrackfiled.containsKey(filedObj.Field))
                    {
                        if(mapofTrackfiled.get(filedObj.Field).CreatedDate <= filedObj.CreatedDate)
                        {
                            mapofTrackfiled.put(filedObj.Field,filedObj);
                        }
                    }else{
                        mapofTrackfiled.put(filedObj.Field,filedObj);
                    }
                    
                }
            }else{
                
                isNoData =true;
            }
        }catch(Exception e) {
            System.debug('Exception in constructer ' +e.getLineNumber());
        }
    }
     /*
        String type='Account';
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet())
        {
        
        System.debug('##Field API Name='+fieldName);// list of all field API name
        
        
        
        fieldMap.get(fieldName).getDescribe().getLabel();//It provides to get the object fields label.
        }
	*/
}