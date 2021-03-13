public with sharing class Facebook_Integration_ctrl {
    public List<Account> conList  {get;set;}
    
    public Facebook_Integration_ctrl(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String fb_url ='https://graph.facebook.com/oauth/access_token';
        String client_id ='160189931775517';
        String client_secret ='c9d8e4eeff9de24b54da31fb0d96f068';
        String endpoint = fb_url+'?client_id='+client_id+'&client_secret='+client_secret+'&grant_type=client_credentials';
        request.setEndpoint(endpoint );
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        system.debug('Status Code'+response .getStatusCode()+' ,Status= '+response.getStatus());
        system.debug('Response == '+response .getBody());
        tokenObject  wrapper = (tokenObject) JSON.deserializeStrict(response.getBody(), tokenObject.class);
        system.debug('access_token == '+wrapper.access_token);
        String access_token = wrapper.access_token;
        HttpRequest request2 = new HttpRequest();
        String fb_url2 ='https://graph.facebook.com/';
        String endpoint2 = fb_url2+client_id+'accounts'+'access_token='+access_token;
        request.setEndpoint(endpoint2 );
        request.setMethod('GET');       
        HttpResponse response2 = http.send(request);

         system.debug('Status Code2'+response2 .getStatusCode()+' ,Status=2 '+response2.getStatus());
        system.debug('Response ==2 '+response2 .getBody());

    }
    
    public void save() 
    {
        /*String accesstoken ='EAADW7vnyeOABAPJ4AQWWmJpFtOZCpjW07eVN7oSrtHpyqajweBfbKAPnrw60p9QCmcs2sv9Ph5N8ntWAf4CvLUBuXPD6BV5FRyZCSynZBF7oNzMQgdyP7QCOupuZASvJnXUtGAr6MmBgbaZAOso9A9Ut9SOJRcUQZDG';
String redirect_uri ='https://rahulkasaundhan-dev-ed--c.ap5.visual.force.com/apex/Facebook_Integration';
string tokenURL = 'https://graph.facebook.com/v2.6/device/login';

String payLoad = 'access_token='+accesstoken+'&scope=public_profile&redirect_uri='+redirect_uri;

Http h = new Http();
HttpRequest req = new HttpRequest();
req.setEndpoint(tokenURL);
req.setMethod('POST');
req.setBody(payLoad);
HttpResponse res = h.send(req);*/
        
    }
    public class tokenObject
    {
        public string access_token { get; set; }
        public string token_type { get; set; }
    }
    
}