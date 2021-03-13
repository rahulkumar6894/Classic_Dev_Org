public with sharing class Search {
            public String AccId        {get;set;} // Id form Selected Account 
            public String Range { get; set; } // String value for Range 
            public String clientID     {get;Set;}  // String for ClientId
            public String SearchStr{get;set;}  // String for enter input in search Bar
            public String clientSecret {get;Set;} // String for clientSecret 
            public String codeAuth     {get;Set;}  // Variable for get the code from current Code  
            public boolean Authorized  {get;Set;}  // Variable for Authorized
            public String accessTokens {get;Set;} // AccessTokens String 
            public String RefreshToken {get;Set;} // RefreshTokens String
            public String accessTokens1 {get;Set;} // AccessTokens String from User
            public String RefreshToken2 {get;Set;} // RefreshTokens String from User
            public String fileinfo     {get;Set;} // Variable for Store Informatiom
            public String boxfiledata  {get;set;}  //  String Store for coming information from Box
            public String BoxStr  {get;Set;} // String for input value form vf to  Box Search
            public String afterSearchRecord {get;Set;} // String for  Store particular Box file information
            public String UserInfo {get;set;} // String for Concate The User Information
            public String UserName {get;set;} // String for user Name
            public String UserType {get;set;} // String for Which Type Of User
            public String UserID  {get;set;} // String for UserID
            public String Login_ID {get;set;} // Variavle for User's Login ID
            public  boolean doDML; // for DML Operation 
            public  boolean doDML2; // for DML Operation
            public  id profileId ; // profileId of current USer 
           
            
            // Wrapper class for deserialize json coming form Box
            Public class RootObject
            {
                    public List<Entry> entries { get; set; } // Entries have information file& folder form Box
                    public String created_at;   // Variable for Created date 
                    public String modified_at; // Variable for modified date
                    public String name; // Variable for name   @ user name
                    public String id; // Variable for Id   @    userId
                    public owned owned_by ;  // Variable for Owner  
                    public String type;    //type= user 
                    public String login; // email iD user login   
            }
            // Wrapper class in class for Entries
            public class Entry
            {
                    public string type { get; set; }
                    public string id { get; set; }
                    public string name { get; set; }
                    public String created_at  {get;set;}
            }
           // Wrapper class for owner
            public class owned
           {
                    public String type; //user
                    public String id;   //2126192334
                    public String name; //Rahul
                    public String login;    //rahulkumar6894@gmail.com
           }
           // constructor for send the record in active widgets
           public Search(ApexPages.StandardController controller)
          {
                AccId = apexpages.currentpage().getparameters().get('id'); // Get Current Id Of Selected Account 
                clientID = 'dyafu9mb6wyyn1epvt3t12znttmrhaxp'; // Client ID of BoxApp 
                clientSecret = 'fKr7wVED1zobfmq1CMXhYmXOOkaD9Oip';   // clientSecret ID of BoxApp   
                codeAuth = Apexpages.currentPage().getParameters().get('code'); // Get Current Autho Code
                 //String id1 = 
               // System.debug('Profile ID'+id1);
                //profileId = UserInfo.getUserId();
                Authorized = false;  // first Authorized false
                boxfiledata = '';    // first String Empty    
                afterSearchRecord = '';   // first String Empty
                boxfiledata = '';    // first String Empty    
                afterSearchRecord = '';   // first String Empty
                UserInfo = '';
                UserName = '';
                UserType = '';
                UserID  = '';
                Login_ID = '';
                if(codeAuth != null)   // condition for code Authorized
                {            

                    User obj= [select AccessTokens__c ,RefreshToken__c from user WHERE Id = '0057F0000019lQVQAY' ];
                    if(obj.AccessTokens__c == null) // condtion if AccessTokens from USer Null
                    {
                        getTokens();    // fn call to get token
                        doDML = true;
                    }else                   // condtion if not null
                        {
                            verifyToken(); // fn call to verifyToken is vaild or Not
                            doDML = true;
                        }
                }else     // When Authorized Code Null then  fn call to verifyToken is vaild or Not
                    {
                        verifyToken();
                        doDML = true;
                    }
                     
          }
          // VF page Action Method
          public void PageActionfn()
          {  
            try{
                    if(doDML == true)
                    {
                        User obj= [select AccessTokens__c ,RefreshToken__c from user WHERE Id = '0057F0000019lQVQAY' ];
                        obj.AccessTokens__c = accessTokens ;
                        obj.RefreshToken__c = RefreshToken;
                        System.debug('obj.AccessTokens__c'+obj.AccessTokens__c);
                        System.debug('accessTokens '+accessTokens );
                        System.debug(' obj.RefreshToken__c'+ obj.RefreshToken__c);
                        System.debug('RefreshToken'+RefreshToken);
                        Update obj;
                    }
                   
               }catch(exception ex){
                  system.debug(ex.getMessage()+'  '+ex.getLineNumber());
                }
                   
           }
     
     public void verifyToken()
     {
        try{
              
                User obj2= [select AccessTokens__c ,RefreshToken__c from user WHERE Id = '0057F0000019lQVQAY' ];
                accessTokens1 = obj2.AccessTokens__c ;
                RefreshToken2 = obj2.AccessTokens__c ;
                string URL2 ='https://api.box.com/2.0/folders/0/items?limit=50&offset=0'; // making EndPoint URL variable
                HttpRequest req2 = new HttpRequest();        
                req2.setEndpoint(URL2);
                req2.setMethod('GET');  
                req2.setHeader('Authorization','Bearer '+accessTokens1 ); // set headder Using AccessTokens
                req2.setHeader('Content-Type', 'application/json; charset=UTF-8');  
                Http ht = new Http();                       
                HttpResponse res2 = ht.send(req2);
                String  fileinfo = res2.getBody();
                System.debug('getStatusCode'+res2.getStatusCode());
                if(res2.getStatusCode() == 200)
                 {
                            itemInfo2();
                 }
                if(res2.getStatusCode() == 401)
                {
                       getTokens();
                       if(accessTokens == null)
                        {
                               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Login The Box'));
                        }
                }  
          }catch(exception ex){
                  system.debug(ex.getMessage()+'  '+ex.getLineNumber());
                }
     }
      
      // pageReference function  to Login in Box Account
     public  PageReference  Boxlogin()
     {System.debug('hello');
        try{
                    if(codeAuth != null)   // condition for code Authorized
                    {
                    }else{
                            User obj2= [select AccessTokens__c ,RefreshToken__c from user WHERE Id = '0057F0000019lQVQAY' ];
                            obj2.AccessTokens__c = null;
                            obj2.RefreshToken__c = null;
                            Update obj2;
                            //pageReference pg = new pageReference('https://account.box.com/api/oauth2/authorize?response_type=code&client_id=dxfiq6dxlanu3xlz3ttz8innxqki7g4q&redirect_uri=https://c.ap5.visual.force.com/apex/Search_Act_Att_Box&state=security_token%3DKnhMJatFipTAnM0nHlZA&id=0017F000005jCBx');
                            pageReference pg = new pageReference('https://account.box.com/api/oauth2/authorize?response_type=code&client_id=dyafu9mb6wyyn1epvt3t12znttmrhaxp&redirect_uri=https://rahulkasaundhan-dev-ed--c.ap5.visual.force.com/apex/Search_Act_Att_Box?id='+AccId); // pageReference for Hit to Login The Box According to Account Id
                            return pg;
                         }
                 
           }catch(exception ex){
                  system.debug(ex.getMessage()+'  '+ex.getLineNumber());
                }
       return null; 
     }
     // Method to AccessTokens & RefreshToken from Box  
      public  void getTokens()
     { 
         try{
                string tokenURL = 'https://api.box.com/oauth2/token'; // Uri to Hit End Point 
                string boxBody= 'grant_type=authorization_code&code='+codeAuth+'&client_id='+clientID+'&client_secret='+clientSecret; // variable to Store Box Body and Store RequestBody
                HTTPRequest request = new HTTPRequest();
                request.setEndpoint(tokenURL);
                request.setMethod('POST');
                request.setBody(boxBody);
                HTTP hp = new HTTP();
                HTTPResponse res = hp.send(request);
                //system.debug('Status Code'+res.getStatusCode()+' ,Status= '+res.getStatus());
                //system.debug('Response == '+res.getBody());
                // Condition for if Sta is ok then Json deserialize
                if(res.getStatusCode() == 200)
                {
                        string getBody = res.getBody();
                        map<string,object> getData = (map<string,object>)JSON.deserializeuntyped(getBody); // Map Method for deserializ to get AccessTokens and refresh_token from Json
                        accessTokens = (string)getData.get('access_token');
                        RefreshToken = (string)getData.get('refresh_token');
                        system.debug('accessTokens+Token == '+accessTokens );
                        system.debug('RefreshToken+Token == '+RefreshToken );
                        Authorized = true;
                        itemInfo1();
                          // after comming Tokens then get  Folder & file information from Box     
                }
            }catch(exception ex){
              system.debug(ex.getMessage()+'  '+ex.getLineNumber());
            }
    }
    public void getUser()
    {
        try{      
                String URL4 = 'https://api.box.com/2.0/users/me'; // URL to Hit To Get Current User In BOx
                HttpRequest req4 = new HttpRequest();        
                req4.setEndpoint(URL4);
                req4.setMethod('GET'); 
                req4.setHeader('Authorization','Bearer '+accessTokens);
                req4.setHeader('Content-Type', 'application/json; charset=UTF-8');       
                HttpResponse res3 =  new Http().send(req4);
                fileinfo = res3.getBody();
                RootObject c4 = ( RootObject)System.JSON.deserialize(fileinfo,RootObject.class); // Using Wrapper Class  Method for deserializ to json
                UserName = c4.name; // getting name form Wrapper class Variable
                UserType = c4.Type; // Stroe User Type
                UserID  = c4.id;    // Stroe User Id 
                Login_ID = c4.login; // Store User LOgin ID
                UserInfo  += UserName +UserType +UserID  +Login_ID ; 
            }catch(exception ex){
            system.debug(ex.getMessage()+'  '+ex.getLineNumber());
            }
       }
    //Method to get the Record from Box to Using Current Tokens Getting from Box
    public void itemInfo1()
    {
        try{
                    string URL2 ='https://api.box.com/2.0/folders/0/items?limit=50&offset=0'; // making EndPoint URL variable
                    HttpRequest req2 = new HttpRequest();        
                    req2.setEndpoint(URL2);
                    req2.setMethod('GET');  
                    req2.setHeader('Authorization','Bearer '+accessTokens); // set headder Using AccessTokens
                    req2.setHeader('Content-Type', 'application/json; charset=UTF-8');  
                    Http ht = new Http();                       
                    HttpResponse res2 = ht.send(req2);
                    String  fileinfo = res2.getBody();
                    if(res2.getStatusCode() == 200)
                    {
                            getUser();
                            fileinfo = res2.getBody();
                            RootObject c = ( RootObject)System.JSON.deserialize(fileinfo,RootObject.class); // Using Wrapper Class  Method for deserializ to json
                            for(integer i = 0 ;i<c.entries.Size();i++) // get One by One Id
                            {
                                   String id =c.entries[i].id; // getting id form Wrapper class Variable
                                   String type = c.entries[i].type;         
                                   if( c.entries[i].type =='file') // Box Hit Only for file Type Document
                                   {
                                        String URL21 = 'https://api.box.com/2.0/files/'+id; // Making End Url Using One By one ID
                                        HttpRequest req21 = new HttpRequest();        
                                        req21.setEndpoint(URL21);
                                        req21.setMethod('GET');  
                                        req21.setHeader('Authorization','Bearer '+accessTokens);
                                        req21.setHeader('Content-Type', 'application/json; charset=UTF-8');       
                                        HttpResponse res =  new Http().send(req21);
                                        fileinfo= res.getBody();
                                        RootObject c2 = ( RootObject)System.JSON.deserialize(fileinfo,RootObject.class); // Using Wrapper Class  Method for deserializ to json
                                        String Name = c2.name; // getting name form Wrapper class Variable
                                        String createdDate = c2.created_at; // getting createdDate form Wrapper class Variable
                                        String User =  c2.owned_by.name; // getting owner form Wrapper class Variable
                                        String fileId   = c2.id ;    // // getting id  form Wrapper class Variable
                                        boxfiledata += +fileId +','+createdDate+','+Name +','+user+','; //variable to concate all geting information in one variable
                                   }
                            }
                            boxfiledata = boxfiledata .removeEnd(',');
                }
             
       }catch(exception ex){
              system.debug(ex.getMessage()+'  '+ex.getLineNumber());
       }
    }
    // Method for getting Record from Box Tokens Using From User Field
    public void itemInfo2()
    {
        try{
                    
                    User obj2= [select AccessTokens__c ,RefreshToken__c from user WHERE Id = '0057F0000019lQVQAY' ];
                    accessTokens = obj2.AccessTokens__c ;
                    RefreshToken = obj2.AccessTokens__c ;
                    string URL2 ='https://api.box.com/2.0/folders/0/items?limit=50&offset=0'; // making EndPoint URL variable
                    HttpRequest req2 = new HttpRequest();        
                    req2.setEndpoint(URL2);
                    req2.setMethod('GET');  
                    req2.setHeader('Authorization','Bearer '+accessTokens); // set headder Using AccessTokens
                    req2.setHeader('Content-Type', 'application/json; charset=UTF-8');  
                    Http ht = new Http();                       
                    HttpResponse res2 = ht.send(req2);
                    String  fileinfo = res2.getBody();
                    //System.debug('getStatusCode'+res2.getStatusCode());
                    if(res2.getStatusCode() == 200)
                    {
                            getUser();
                            fileinfo = res2.getBody();
                            RootObject c = ( RootObject)System.JSON.deserialize(fileinfo,RootObject.class); // Using Wrapper Class  Method for deserializ to json
                            for(integer i = 0 ;i<c.entries.Size();i++) // get One by One Id
                            {
                                   String id =c.entries[i].id; // getting id form Wrapper class Variable
                                   String type = c.entries[i].type; // getting Type form Wrapper class Variable         
                                  if( c.entries[i].type =='file') // Box Hit Only for file Type Document
                                   {
                                        String URL21 = 'https://api.box.com/2.0/files/'+id; // Making End Url Using One By one ID
                                        HttpRequest req21 = new HttpRequest();        
                                        req21.setEndpoint(URL21);
                                        req21.setMethod('GET');  
                                        req21.setHeader('Authorization','Bearer '+accessTokens);
                                        req21.setHeader('Content-Type', 'application/json; charset=UTF-8');       
                                        HttpResponse res =  new Http().send(req21);
                                        fileinfo= res.getBody();
                                        RootObject c2 = ( RootObject)System.JSON.deserialize(fileinfo,RootObject.class); // Using Wrapper Class  Method for deserializ to json
                                        String Name = c2.name; // getting name form Wrapper class Variable
                                        String createdDate = c2.created_at; // getting createdDate form Wrapper class Variable
                                        String User =  c2.owned_by.name; // getting owner form Wrapper class Variable
                                        String fileId   = c2.id ;    // // getting id  form Wrapper class Variable
                                        boxfiledata += +fileId +','+createdDate+','+Name +','+user+','; //variable to concate all geting information in one variable
                                   }
                            }
                            boxfiledata = boxfiledata .removeEnd(',');
                    }
        
        }catch(exception ex){
              system.debug(ex.getMessage()+'  '+ex.getLineNumber());
        }
    }
    
    // method for search variable in box 
    public void boxSearch(){
     try{
                afterSearchRecord  = ''; // When we boxSearch() called Intial value  empty when boxsearch again again  call value will become Empty
                String URL3 = 'https://api.box.com/2.0/search?query='+BoxStr+'&file_extensions=pdf';
                HttpRequest req3 = new HttpRequest();        
                req3.setEndpoint(URL3);
                req3.setMethod('GET'); 
                req3.setHeader('Authorization','Bearer '+accessTokens);
                req3.setHeader('Content-Type', 'application/json; charset=UTF-8');       
                HttpResponse res3 =  new Http().send(req3);
                fileinfo = res3.getBody();
                RootObject c3 = ( RootObject)System.JSON.deserialize(fileinfo ,RootObject.class); // Using Wrapper Class  Method for deserializ to json
                for(integer i = 0 ;i<c3.entries.Size();i++)
                {
                        String id =c3.entries[i].id;
                        String user = 'Rahul';         
                        String Name =c3.entries[i].Name;
                        String createdDate =c3.entries[i].created_at;
                        afterSearchRecord += +id +','+createdDate +','+Name +','+user+','; //variable to concate all geting information in one variable
                }
           }catch(exception ex){
            system.debug(ex.getMessage()+'  '+ex.getLineNumber());
            }
       afterSearchRecord = afterSearchRecord .removeEnd(',');  // Remove Last (,) from string 
       
   }
   // Method for UpdateUser
   public pageReference UpdateUser()
   {
        User obj= [select AccessTokens__c ,RefreshToken__c from user WHERE Id = '0057F0000019lQVQAY' ];
        obj.AccessTokens__c = null ;
        obj.RefreshToken__c = null;
        Update obj; //AccessTokens__c ,RefreshToken__c null then Again Box Hit For Another User
        pageReference pg = new pageReference('https://account.box.com/api/oauth2/authorize?response_type=code&client_id=dxfiq6dxlanu3xlz3ttz8innxqki7g4q&redirect_uri=https://c.ap5.visual.force.com/apex/Search_Act_Att_Box?id='+AccId); // pageReference for Hit to Login The Box According to Account Id
        return pg;
  }
}