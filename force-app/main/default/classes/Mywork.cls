public class Mywork {
    public String clientID {get;Set;}      //  Get ClientID 
    public String clientSecret {get;Set;}  // Get ClientSecret
    public String codeAuth {get;Set;}      // for codeauth
    public  String RefreshToken {get;set;}  // for refreshToken
    public  String AccessToken {get;set;}  // for refreshToken
    public Set<Id> Keyvalues {get;set; }
    public List<Account> ListofAccount  {get;set;} 
    public Map<Id, List<Contact>> MapAcc {get;set;}
    public string test {get; set;}
    List<Account> acclist= [Select Id ,(SELECT Id, FirstName,LastName,AccountId FROM Contacts)From Account];
    //List<Contact> conlist =  new List<Contact>();
    //List<Contact> clist = [SELECT Id, FirstName,LastName,AccountId FROM Contact WHERE Contact.AccountId IN :acclist];
    //Set<ID> keyValues {get;set;}
    public MyWork()
    {  
     MapAcc= new Map<Id, List<Contact>>();
     keyValues = New Set<ID>(); 

     for(account a : acclist)
     {
        for(contact con : a.Contacts)
        {
            if (MapAcc.containsKey(a.Id))
            { 
              MapAcc.get(a.ID).add(con);
             }else
                 {
                    MapAcc.put(a.Id , new List<Contact>{ con });
                 }
        } 
    } 
    keyValues = MapAcc.keySet(); 
    System.debug('keyValues '+keyValues );
    System.debug('MapAcc'+MapAcc);
    // Box token 
    clientID = 'dyafu9mb6wyyn1epvt3t12znttmrhaxp';
    clientSecret = 'fKr7wVED1zobfmq1CMXhYmXOOkaD9Oip';
    codeAuth = Apexpages.currentPage().getParameters().get('code');
    system.debug('codeAuth '+codeAuth);
    if(codeAuth != null)
    {            
        getTokens();  
    } 
    
   }
  
   public PageReference GetBoxtoken() 
   {
     pageReference pg = new pageReference('https://account.box.com/api/oauth2/authorize?response_type=code&client_id=dyafu9mb6wyyn1epvt3t12znttmrhaxp&redirect_uri=https://rahulkasaundhan-dev-ed--c.ap5.visual.force.com/apex/My_work');
     return pg ;
    } 
    // Calling REST API To Get Token 
    public void getTokens ()
    {
        String tokenURL = 'https://api.box.com/oauth2/token';
        String boxBody= 'grant_type=authorization_code&code='+codeAuth+'&client_id='+clientID+'&client_secret='+clientSecret;
        HTTPRequest request = new HTTPRequest();  //Creates a new instance of the HttpRequest class.
        request.setEndpoint(tokenURL);     // Retrieves the URL for the endpoint of the external server for this request 
        request.setMethod('POST');        // Returns the type of method used by HttpRequest       
        request.setBody(boxBody);         // Sets the contents of the body for this request.
        HTTP hp = new HTTP();            // Create a new http object to send the request object
        HTTPResponse res = hp.send(request);  // A response object is generated as a result of the request 
        system.debug('Status Code'+res.getStatusCode()+' ,Status= '+res.getStatus());
        system.debug('Response == '+res.getBody());
        system.debug('***********StatusCode*** == '+res.getStatusCode());
        if(res.getStatusCode() == 200)
        {
            RootObject C = ( RootObject)System.JSON.deserialize(res.getBody(),RootObject.class);
            RefreshToken = C.refresh_token;
            AccessToken  = C.access_token ; 
            System.debug('RefreshToken'+RefreshToken+'AccessToken'+AccessToken   );
         }
   }
   public void LoadingMethod() 
   {    
        ListofAccount  = [Select Id,Name From Account];
        test = ListofAccount[0].Name;
        System.debug('ListofAccount  '+ListofAccount);
   }
   public class RootObject
   {
        public string access_token { get; set; }
        public List<object> restricted_to { get; set; }
        public string refresh_token { get; set; }
        public string token_type { get; set; }
   }
}