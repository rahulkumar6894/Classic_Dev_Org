public with sharing class BoxAuthController2
{

   
    public String refreshToken { get; set; } // store refreshToken from box

    public String AccessToken { get; set; }  // store AccessToken from box

    public String ViewAPI_Key { get; set; }  // store refreshToken from box

    public String client_secret { get; set; }  // store ViewAPI_Key from box

    public String clientid { get; set; }     // store clientid from box
    
    public String Authcode{get;set;}       // store Authcodefrom box
    
    public String securitycode;
    
    public String endPointURL{get;set;}
    
    public String selectedFolder { get; set; } // Seleced folder Id
    
    public String Response {get;set;} //response from Box.com
    
    public Id UserId; 
  
     //list to dispaly file list in UI  
    public List<entry> fileList{get;set;}
    
    public String FileViewUrl{get;set;} // Select fileId to get url
    
    //variables for file upload
    public blob uploadContent{get;set;}

    public String uploadFilename { get; set; }

    public String folderName  { get; set; } //Folder Name to create in box
    
 
    Public class RootObject
    {
           public List<Entry> entries { get; set; }
           public itemCollections item_collection{get;set;}
           public cls_expiring_embed_link expiring_embed_link;
           
    }
   
    public class itemCollections
    {
         public List<entry> entries{get;set;}
    }
    class entries
    {
        public String type { get; set; }
        public String id { get; set; }
        public String name{ get; set; }
    }
   
    public class entry
    {
        public String type{get;set;}
        public String id{get;set;}
        public String name{get;set;}
        public entry(String type,String id,String name){
            this.type=type;
            this.id=id;
            this.name=name;
        }   
    }
    class cls_expiring_embed_link 
    {
        public String url;  
    }
    
     //map to store file id and file name present in box
    public Map<String,String>folderIdToNameMap=new Map<String,String>();
    
    // constructer 
    public BoxAuthController2()
    {
    
            UserId = userInfo.getUserId();
            Authcode = ApexPages.currentPage().getparameters().get('code');
            securitycode = ApexPages.currentPage().getparameters().get('state');
            AccessToken = Box_details__c.getValues(UserId).Access_Token__c; // get Access token from Custom Setting
            RefreshToken =  Box_details__c.getValues(UserId ).Refresh_Token__c;
            clientid = Box_details__c.getValues(UserId ).client_id__c;   
            client_secret = Box_details__c.getValues(UserId ).client_secret__c;   
            endPointURL='https://app.box.com/api/oauth2/token?';
            FileViewUrl='';
           System.debug('FileViewUrl'+FileViewUrl);
      
    }
    
    //Method to find Access Token using AuthCode
    public Pagereference FindAccessToken()
    {
        Response='';
        if(Authcode!=null && Authcode!='' && securitycode=='RahulK')
        {
           
            string tokenURL = 'https://api.box.com/oauth2/token';
            string boxBody= 'grant_type=authorization_code&code='+Authcode+'&client_id='+clientid +'&client_secret='+client_secret ;
            HTTPRequest request = new HTTPRequest();
            request.setEndpoint(tokenURL);
            request.setMethod('POST');
            request.setBody(boxBody);
            HTTP hp = new HTTP();
            HTTPResponse res = hp.send(request);
            Response=res.getBody();
            Integer statusCode=res.getStatusCode();
            JSONParser parser = JSON.createParser(Response);
             while (parser.nextToken() != null)
              {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                    String fieldName = parser.getText();
                    parser.nextToken();
                    if(fieldName == 'access_token') {
                        AccessToken= parser.getText();
                           System.debug('RefreshToken____fieldName '+RefreshToken);
                    }if(fieldName == 'refresh_token') {
                        RefreshToken= parser.getText();
                         System.debug('AccessToken____v'+AccessToken);
                    }
                }
             }
       }
       
       //always remeber that don't perform DML before callout 
         updateBoxCustomobject(); // methot call to Update Access token and refresh token in custom Setting
        
     return null;
    }
    //Method to get get Authorization code after validating user on Box server
    public Pagereference AutorizeBox()
    {
        String endpointUrl1='https://app.box.com/api/oauth2/authorize?response_type=code&client_id='+clientid+'&state=RahulK';
        pageReference pag=new pageReference(endpointUrl1);
        pag.setRedirect(true);
        return pag;
    }
    
    // 
    public PageReference SearchFolders()
    {  
       FindAllAvailableBoxFolders();
          return Null;
    }
    
    //methot to Update Access token and refresh token in custom Setting
    public void updateBoxCustomobject(){
        try{
             
            List<Box_details__c > bx=[SELECT id,Name,Access_Token__c,Refresh_Token__c FROM Box_details__c where id ='a0B7F00000HYfp2'];
            bx[0].Refresh_Token__c = RefreshToken;
            bx[0].Access_Token__c= AccessToken;
            update bx[0];
        }catch(exception e){
            system.debug('*********Exception while updating custom setting:'+e.getmessage());
        }
    }
    
    // method to get all folder from box
    public void FindAllAvailableBoxFolders()
    {
         System.debug('AccessToken'+AccessToken);
         String AccessToken2 = Box_details__c.getValues(UserId).Access_Token__c; // get Access token from Custom Setting
         System.debug('AccessToken2'+AccessToken2);
        Response='';
        string URL ='https://api.box.com/2.0/folders/0/items?limit=50&offset=0';
        HttpRequest req = new HttpRequest();        
        req.setEndpoint(URL);
        req.setMethod('GET');  
        req.setHeader('Authorization','Bearer '+AccessToken2);
        req.setHeader('Content-Type', 'application/json; charset=UTF-8');       
        HttpResponse res =  new Http().send(req);
        Response =res.getBody();
        System.debug('**Folder Response:'+Response);
        //parse JSON response
        integer responseStatusCode=res.getStatusCode();
          System.debug('getStatusCode'+responseStatusCode);
        if(responseStatusCode==200)
        {
             //apex class structure to deserialize Folder response JSON
             RootObject c = (RootObject)System.JSON.deserialize(Response,RootObject.class);
             Integer len = c.entries.size();
             for(integer i=0;i<len;i++)
             {
                 if(c.entries[i].type =='folder')
                 {
                     String FolderID = c.entries[i].id;
                     String FolderName = c.entries[i].name;
                     folderIdToNameMap.put(FolderID,FolderName );
                }
                
             }
        }else
             {
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please AutorizeBox'));
             }
        
    }
    public List<selectoption> getAllFoldersList()
    {
            List<selectoption> options=new List<selectoption>();
            options.add(new selectoption('','--None--'));
            if(folderIdToNameMap.size()>0){
                for(String ss:folderIdToNameMap.keyset()){
                    options.add(new selectoption(ss,folderIdToNameMap.get(ss)));
                }
        }
       return options;
    }
    public PageReference FindFilesFromFolder()
    {
         system.debug('******selectedFolder :'+selectedFolder );
        
         fileList=new List<entry>();
         FileViewUrl='';
         if(selectedFolder!=null && selectedFolder!='')
         {
            String endpointURLForFiles = 'https://api.box.com/2.0/folders/'+selectedFolder;
            system.debug('*******endpointURLForFiles '+endpointURLForFiles );
            HttpRequest req = new HttpRequest();        
            req.setEndpoint(endpointURLForFiles );
            req.setMethod('GET');  
            req.setHeader('Authorization','Bearer '+AccessToken);
            req.setHeader('Content-Type', 'application/json; charset=UTF-8');       
            HttpResponse res =  new Http().send(req);
            Response =res.getBody();
            System.debug('**fileResponse:'+Response);
            //integer responseStatusCode=res.getStatusCode();
            //parse file response json
             RootObject c = (RootObject)System.JSON.deserialize(Response,RootObject.class);
              if(c.item_collection!=null)
              {
                    if(c.item_collection.entries.size()>0)
                    {
                        for(entry en: c.item_collection.entries)
                        {
                            if(en.type.equalsignorecase('file'))
                            {
                                fileList.add(en);
                            }
                        }
                    }
                }
        }else{
        
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select folder.'));
        }
        return null;
    } 
   
    
    public String selectedFileId { get; set; } // Select file id for view
    
    //  Method for Select file  for view
    public PageReference ViewFile()
    {
        System.debug('selectedFileId'+selectedFileId );
        String fileDownloadUrl='';
        FileViewUrl='';
        if(selectedFileId!=null && selectedFileId!='')
        {
            String endpointURLForFiles = 'https://api.box.com/2.0/files/'+selectedFileId+'?fields=expiring_embed_link';
            system.debug('*******endpointURLForFiles '+endpointURLForFiles );
            HttpRequest req = new HttpRequest();        
            req.setEndpoint(endpointURLForFiles );
            req.setMethod('GET');  
            req.setHeader('Authorization','Bearer '+AccessToken);
            req.setHeader('Content-Type', 'application/json; charset=UTF-8');       
            HttpResponse res =  new Http().send(req);
            Response =res.getBody();
            System.debug('**Folder Response:'+Response);
            RootObject c = (RootObject)System.JSON.deserialize(Response,RootObject.class);
            FileViewUrl =  c.expiring_embed_link.url;
            System.debug('Url'+FileViewUrl);
        }
        return Null;
     }
    
   // Method to Upload file
   Public String selectedFileIdagain{get;set;}
    public String downloadFile()
    { 
       
       
        return null;
   }
   
   // Method Upload file in Box
     public PageReference uploadFileToBox() 
     {
         
        if(selectedFolder!=null && selectedFolder!='')
        {
            if(uploadContent!=null)
            {
                blob base64EncodeFile=base64EncodeFileContent(uploadContent,uploadFilename); String uploadEndPointURL='https://upload.box.com/api/2.0/files/content?parent_id='+selectedFolder;
                String boundary = '----------------------------741e90d31eff';
                HttpRequest req = new HttpRequest();        
                req.setEndpoint(uploadEndPointURL);
                req.setMethod('POST'); 
                req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
                //req.setHeader('Content-Length',String.valueof(req.getBodyAsBlob().size()));
                req.setHeader('Authorization', 'Bearer ' +AccessToken);
                req.setMethod('POST');
                req.setEndpoint(uploadEndPointURL);
                req.setBodyAsBlob(base64EncodeFile);
                req.setTimeout(60000);
                HttpResponse res =  new Http().send(req);
                Response =res.getBody();
                System.debug('**Folder Response:'+Response);
                Integer uploadStatusCode=res.getStatusCode();
                if(uploadStatusCode==201)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'File uploaded successfully.'));
                }else
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error encountered. Status Code;'+uploadStatusCode));
                } 
            }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please select file.'));
                }
        }else
            {
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select folder.');
               ApexPages.addMessage(myMsg);
           }
      return null;
     }  
    public blob base64EncodeFileContent(Blob file_body, String file_name)
    {
        String boundary = '----------------------------741e90d31eff';
        String header = '--'+boundary+'\nContent-Disposition: form-data; name="file"; filename="'+file_name+'";\nContent-Type: application/octet-stream';
        String footer = '--'+boundary+'--';             
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        while(headerEncoded.endsWith('='))
        {
            header+=' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }
        String bodyEncoded = EncodingUtil.base64Encode(file_body);
        Blob bodyBlob = null;
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
 
        if(last4Bytes.endsWith('==')) {
            last4Bytes = last4Bytes.substring(0,2) + '0K';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        } else if(last4Bytes.endsWith('=')) {
            last4Bytes = last4Bytes.substring(0,3) + 'N';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            footer = '\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);              
        } else {
            footer = '\r\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);  
        }
 
        return bodyBlob;
    }
    public PageReference CreateFolderInBox() 
    {
        System.debug('folderName'+folderName);
        System.debug('selectedFolder'+selectedFolder);
        String url = 'https://api.box.com/2.0/folders';
        string authorizationHeader = 'Bearer '+Accesstoken;
        
        HttpRequest req = new HttpRequest();
        req.setheader('Authorization',authorizationHeader);
        req.setBody('{"name":"'+folderName+'", "parent":{"id":"0"}}');
        req.setMethod('POST');
        req.setEndpoint(url);
        
        Http h = new Http();
        Httpresponse res= h.send(req);
        System.debug(res.getbody()+'-----------------------'+res);
        Integer uploadStatusCode=res.getStatusCode();
        if(uploadStatusCode==201)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Folder successfully created.'));
        }else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error encountered. Status Code;'+uploadStatusCode));
        } 
        return null;
    }
    
    Public String DeletefileID { get; set; }
    public PageReference DeleteFile() 
    {
        System.debug('DeletefileID'+DeletefileID );
        return null;
    }


  
      
}