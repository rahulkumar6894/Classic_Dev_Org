public with sharing class Datatable{
    public List<Account> acclist { get; set; }
    public List<String>  accfieldList {get; set;}
    public List<String>  accselectfieldList {get;set;}
    public list<String> Field {get; set;}
    public list<String> optionsnext1 {get;set;}
    public list<String> optionsnext {get;set;}
    public  List <String> nextField {get;set;}
    public Datatable()
    {
        String  sURL = apexpages.currentpage().getparameters().get('sessionid');
        System.debug('Session Id'+sURL);
        accfieldList  = new  List<String>();
        optionsnext = new list<String>();
        optionsnext1 = new list<String>();
        acclist = [Select Id, Name,Phone,Fax from Account];
        System.debug('####'+acclist); // account record for DataTable
        
     
                /*
                    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                    Schema.SObjectType leadSchema = schemaMap.get('Account');
                    Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                    for (String fieldName: fieldMap.keySet())
                    {
                        //System.debug('##Field API Name='+fieldName);  // list of all field API name
                        //System.debug('##Lable Name='+fieldMap.get(fieldName).getDescribe().getLabel());  // list of all field API name
                        accfieldList.add(fieldMap.get(fieldName).getDescribe().getLabel());
                        System.debug('accfieldList'+accfieldList);
                    }
               */
    }  

    public list<selectoption> getFields()
    {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        List<SelectOption> options = new List<SelectOption>();
        Schema.SObjectType systemObjectType = gd.get('ACCOUNT');  
        Schema.DescribeSObjectResult r= systemObjectType.getDescribe();  
        Map<String, Schema.SObjectField> M = r.fields.getMap();  
        for(Schema.SObjectField fieldAPI : M.values())
        {  
            options.add(new SelectOption(fieldAPI.getDescribe().getName() , fieldAPI.getDescribe().getLabel())) ;  
        }  
        System.debug('options'+options);
       
        return options;
    }
     List<SelectOption> optionsagain = new List<SelectOption>();
     /* 
    public list<selectoption> getoptionsnext()
    { 
         
        for(string str : field){
             optionsagain.add(new SelectOption('str','str'));
         }
              return optionsagain;
      
    }
    */
    public void  selectedField(){
             System.debug('optionsnext'+Field.size());
             if (Field.size()>0)
             {
               System.debug('optionsnext'+optionsnext.size());
               if(optionsnext.size() ==0)
               {
                     for(string str : Field )
                     {
                       optionsnext.add(str);
                          System.debug('firstlist' +optionsnext);
                     }
                }
                     
             }else{
                    
                     System.debug('optionsnext'+optionsnext.size());
                      for(Integer i=0; i<optionsnext.size();i++)
                         {
                               System.debug(Field[i]);
                                 System.debug(optionsnext[i]);
                               
                            if( optionsnext[i] !=Field[i] )
                            {
                               optionsnext.add(Field[i]);
                               System.debug('SecoundList' +optionsnext);
                            }
                              
                            } 
                    }
           
                     
             
         System.debug('Field' +Field );
         System.debug('optionsnext1' +optionsnext);
        
        
    }
}