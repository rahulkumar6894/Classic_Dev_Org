public class Box_comman{

   
    public String clientID {get;Set;}
    public String clientSecret {get;Set;}
    public String codeAuth {get;Set;}
    public boolean Authorized  {get;Set;}
    public string accessTokens{get;set;}
    public string RefreshToken{get;set;}
    public String FolderID {get;set;}
    public String sBoxBody {get;set;}

   
      public class Child
    {
        public string id { get; set; }
        public string text { get; set; }
        public string relatedId { get; set; }
        //public bool @internal { get; set; }
        //public bool global { get; set; }
        //public bool shared { get; set; }
        public string parentId { get; set; }
        public string name { get; set; }
        //public bool expanded { get; set; }
        public List<object> children { get; set; }
   }
    public class RootObject 
    {
        public string z_id { get; set; }
        public string y_text { get; set; }
        public string x_relatedId { get; set; }
        public boolean w_internal { get; set; }
        public boolean v_isGlobal { get; set; }
        public boolean u_shared { get; set; }
        public string t_parentId { get; set; }
        public string s_name { get; set; }
        public boolean r_expanded { get; set; }
        public List<RootObject> q_children { get; set; }
        //public string p_index { get; set; }
        
       
    }
   
    public Box_comman()
    {
        clientID = '6h4u7u0utkh59uuqtmkgs2larh63s3ct';
        clientSecret = 'rXSdFhhbk0ojE4XxjPneutpAFoNr00Z5';
        codeAuth = Apexpages.currentPage().getParameters().get('code');
        Authorized = false; 
        system.debug('codeAuth '+codeAuth);
        myfunction();
        if(codeAuth != null)
        {            
            getTokens();
        }
    }
  
        
    public PageReference Boxlogin()
    {
        
        pageReference pg = new pageReference('https://account.box.com/api/oauth2/authorize?response_type=code&client_id=6h4u7u0utkh59uuqtmkgs2larh63s3ct&redirect_uri=https://rahulkasaundhan-dev-ed--c.ap5.visual.force.com/apex/Box_comman&state=security_token%3DKnhMJatFipTAnM0nHlZA');
        return pg;
    }
    
    public void getTokens ()
     {
        string tokenURL = 'https://api.box.com/oauth2/token';
        string boxBody= 'grant_type=authorization_code&code='+codeAuth+'&client_id='+clientID+'&client_secret='+clientSecret;
        HTTPRequest request = new HTTPRequest();
        request.setEndpoint(tokenURL);
        request.setMethod('POST');
        request.setBody(boxBody);
        HTTP hp = new HTTP();
        HTTPResponse res = hp.send(request);
        system.debug('Status Code'+res.getStatusCode()+' ,Status= '+res.getStatus());
        system.debug('Response == '+res.getBody());
        system.debug('***********StatusCode*** == '+res.getStatusCode());

        if(res.getStatusCode() == 200)
        {
            string getBody = res.getBody();
            map<string,object> getData = (map<string,object>)JSON.deserializeuntyped(getBody);
            accessTokens = (string)getData.get('access_token');
            RefreshToken = (string)getData.get('refresh_token');
            system.debug('***********accessTokens *** == '+accessTokens );
            system.debug('***********RefreshToken*** == '+RefreshToken);
            Authorized = true;       
        }
     }
     public void BoxHIT()
     {
       String abc = BoxHIT('https://api.box.com/2.0/folders/0/items?limit=50&offset=0');
       System.debug('###0#####'+abc);
     }
      public String BoxHIT(String URL)
     {
        sBoxBody ='';
        HttpRequest req = new HttpRequest();        
        req.setEndpoint(URL);
        req.setMethod('GET');  
        req.setHeader('Authorization','Bearer '+accessTokens);
        req.setHeader('Content-Type', 'application/json; charset=UTF-8');       
        HttpResponse res =  new Http().send(req);
        sBoxBody = res.getBody();
        System.debug('########'+sBoxBody);
        return sBoxBody;
     }
     public void getfolder()
     {
            String data1 = '44094513288';
            string URL = 'https://api.box.com/2.0/folders/'+data1+'/items';
            String sDeatils = BoxHIT(URL);
            System.debug('###sDeatils#####'+sDeatils);

     }
       Set<string> setofIds = new Set<string>();
      public void myfunction()
     {
        List<Account> results = [SELECT Id,Description FROM Account where id ='0017F00000N2HnT'];
        string jsonToUpdate = results[0].Description;
        system.debug('my ft>>>'+jsonToUpdate);
        string FolderId = '475223106' ;
        List<RootObject > folderObj1 = new List<RootObject >();
        //List<string> setofIds = new List<string>();
         setofIds.Add(FolderId);
        String jsonStr;
        jsonStr = jsonToUpdate;
            
           jsonStr = jsonStr.replace('text:', '"y_text":').replace('parentId:', '"t_parentId":').replace('id:', '"z_id":').replace('name:', '"s_name":').replace('expanded:', '"r_expanded":').replace('children:', '"q_children":').replace('global:', '"v_isGlobal":').replace('shared:', '"u_shared":').replace('internal:', '"w_internal":').replace('relatedId:', '"x_relatedId":').replace('leaf:', '"p_index":');
            
            //jsonStr = jsonStr.replace('"text":', '"y_text":').replace('"parentId":', '"t_parentId":').replace('"id":', '"z_id":').replace('"name":', '"s_name":').replace('"expanded":', '"r_expanded":').replace('"children":', '"q_children":').replace('"global":', '"v_isGlobal":').replace('"shared":', '"u_shared":').replace('"internal":', '"w_internal":').replace('"relatedId":', '"x_relatedId":').replace('"leaf:"', '"p_index":');
            
            system.debug('jsonStr before serialization'+jsonStr);
            
            //Deserialize json into wrapper class
            JSONParser parser = JSON.createParser(jsonStr);
            folderObj1 = (List<RootObject>)parser.readValueAs(List<RootObject>.class);
            system.debug('jsonStr folderObj1'+folderObj1);
            List<RootObject> currChild = new List<RootObject>();
            currChild = folderObj1[0].q_children;
            String currIds = folderObj1[0].z_id;
            system.debug('>>>currChild'+currChild.size());
            system.debug('>>>currIds '+currIds);

            List<RootObject > nextChild = new List<RootObject >();
           // for (RootObject myobj : currChild)
            //{
                           folderIdsfunction(currChild,setofIds);
                   
            //}
          
          }
          public boolean yesIds = false;
          public void folderIdsfunction(List<RootObject> subChild,Set<String> IDs)
          {
                //setofIds.Add(currIds);
               // System.debug('>>>setofIds>>'+setofIds); 
               for (RootObject myobj : subChild)
               {
                     
                    
                        if(IDs.contains(myobj.z_id))
                            IDs.Add(myobj.z_id);
                        System.debug('>>>folderIdsfunction>>'+myobj.z_id);  
                        folderIdsfunction(myobj.q_children,IDs);
                        
                        
                  
               }    
          }
          //System.debug('>>ff>setofIds>>'+setofIds); 
}