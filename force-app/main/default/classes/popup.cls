public  class popup {

    public PageReference closePopup() {
        return null;
    }


    public String displayPopUp { get; set; }

    public PageReference showPopup() {
        return null;
    }


        public String Name { get; set; }
        public List <String> AccountList  {get;set;}
        
        public popup()
        {
                String objectName = 'Account';
                // List<Schema.SObjectType>  schemaMap = Schema.getGlobalDescribe();
                //Map<String, Schema.SObjectField> fieldMap = schemaMap.get(objectName).getDescribe().fields.getMap();
               // System.debug('++++++++++++'+fieldMap);
                List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();  
                 List<SelectOption> options = new List<SelectOption>();
                  for(Schema.SObjectType f : gd)
                       {
                       options.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getName()));
                       }
                       System.debug('+++++++++++++'+options);
         }
}