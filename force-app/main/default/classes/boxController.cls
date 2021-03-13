public class boxController {

    public String clientID {get;Set;}
    public String clientSecret {get;Set;}
    public String codeAuth {get;Set;}
    public boolean Authorized  {get;Set;}
    public List<string> boxDataList {get;Set;}
    public string accessTokens{get;set;}
    public string RefreshToken{get;set;}
    public String folderInfo {get;set;}
    public String FolderID {get;set;}
    public String FolderName {get;set;}
    public String PathCollection {get;set;}
    public String root {get;set;}
    public String child { get; set; }
    public String val ;
    public String data1{ get; set; }
    public String childofchild{ get; set; }
    public String fn{get;set;}
    public class Entry
    {
    public string type { get; set; }
    public string id { get; set; }
    public string name { get; set; }
    }
    Public class RootObject
    {
    // public int total_count { get; set; }
        public List<Entry> entries { get; set; }
    }

    public boxController ()
    {
        clientID = 'dxfiq6dxlanu3xlz3ttz8innxqki7g4q';
        clientSecret = 'kgkW4FzOzQDMrs0TjYvlFcDnnYZMk3Xh';
        codeAuth = Apexpages.currentPage().getParameters().get('code');
        Authorized = false; 
        system.debug('codeAuth '+codeAuth);
        boxDataList= new List<string>();       
        if(codeAuth != null)
        {            
            getTokens();
        }
         root = '';
        child = '';
       
    }
    
    public PageReference Boxlogin()
    {
        
        pageReference pg = new pageReference('https://account.box.com/api/oauth2/authorize?response_type=code&client_id=dxfiq6dxlanu3xlz3ttz8innxqki7g4q&redirect_uri=https://rahulkasaundhan-dev-ed--c.ap5.visual.force.com/apex/BoxHitPage&state=security_token%3DKnhMJatFipTAnM0nHlZA');
        return pg;
    }
    public void InsertfolderInfo() 
    {
      
        contact con = new Contact();
        con.LastName= '';
        con.AccessToken__c= accessTokens;
        con.RefreshToken__c= RefreshToken;
        insert con; 
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
    public void GetfolderInfo() {
       child  = '';
       //string URL = 'https://api.box.com/2.0/folders/0';
       // string URL = 'https://api.box.com/2.0/folders/33751692452/items';
       
        string URL ='https://api.box.com/2.0/folders/0/items?limit=50&offset=0';
        HttpRequest req = new HttpRequest();        
        req.setEndpoint(URL);
        req.setMethod('GET');  
        req.setHeader('Authorization','Bearer '+accessTokens);
        //req.setHeader('Authorization','Bearer anOrEykPQNGm2rCvlsqO0QrlFdCo4Nhr');
        req.setHeader('Content-Type', 'application/json; charset=UTF-8');       
        HttpResponse res =  new Http().send(req);
        folderInfo = res.getBody();
        System.debug('@@@@@@@@@@@folderInfo '+folderInfo );
        RootObject c = ( RootObject)System.JSON.deserialize(folderInfo,RootObject.class);
        Integer len = c.entries.size();
        root = 'rahul';
         
        for(integer i=0;i<len;i++)
        {
        System.debug( '++++++++++++'+c.entries[i].name);
        System.debug( '++++++++++++'+c.entries[i].id);
        String val = c.entries[i].name;
        FolderID = c.entries[i].id;
        FolderName = c.entries[i].name;
         System.debug('FolderName '+FolderName );
         fn = 'ram';
      
         // child  =  child  + '{"text":"<label onclick=\'getchild('+FolderID+');\'>'+val+'</label>"},';
           //child  =  child  + '{"text":"<label onclick=\'getchild('+FolderID+');\'>'+val+'</label>",children:[{"text":"'+fn+'"}]},';
           child  =  child  + '{"text":"<label onclick=\'getchild('+FolderID+');\'>'+val+'</label>",children:[{childofchild}]},';
          System.debug('child  '+child  );
            
         //root = root + '{id:"'+c.entries[i].id+'", text:"<span style=font-weight:bold>'+ c.entries[i].name+'</span>",expanded:false,children:[]},' ;
            
               
         //child = child + root;
         //child = child + ']}]'; 
         //.debug('root '+root );
         //System.debug('child '+child );
         }
     
      } 

      
      public void getChildf()
      {
         childofchild ='';
       
        //String URL = 'https://api.box.com/2.0/folders/+data1+/items';
        string URL = 'https://api.box.com/2.0/folders/'+data1+'/items';
        HttpRequest req = new HttpRequest();        
        req.setEndpoint(URL);
        req.setMethod('GET');  
        req.setHeader('Authorization','Bearer '+accessTokens);
        req.setHeader('Content-Type', 'application/json; charset=UTF-8');       
        HttpResponse res =  new Http().send(req);
        folderInfo = res.getBody();
        System.debug('########'+folderInfo);
        RootObject c = ( RootObject)System.JSON.deserialize(folderInfo,RootObject.class);
        System.debug('########'+c);
        Integer len = c.entries.size();
        root = 'rahul';
         
        for(integer i=0;i<len;i++)
        {
        System.debug( '++++++++++++'+c.entries[i].name);
        System.debug( '++++++++++++'+c.entries[i].id);
        String namechild = c.entries[i].name;
        childofchild =  childofchild + '{"text":"<label>'+namechild+'</label>"},';
       
       
          System.debug('ChildName' +childofchild ); 
        }
      }

  }