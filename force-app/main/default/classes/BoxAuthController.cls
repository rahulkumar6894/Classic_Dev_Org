/* 
    Author: Sunil Kumar
    Purpose: Uploading and Downloading file from BOX
*/
public  class BoxAuthController {
    //Variables for Oauth 
    public String Authcode{get;set;}
    public String AccessToken{get;set;}
    public String RefreshToken{get;set;}
    public String clientid{get;set;}
    public String client_secret{get;set;}
    public String API_Key{get;set;}
    public String ViewAPI_Key{get;set;}
    public String securitycode;
    
    //Other for Viewing File
    public String Response{get;set;} //response from Box.com
    public String endPointURL{get;set;}
    public String FileViewUrl{get;set;}
    public String selectedFolder{get;set;}
    //map to store file id and file name present in box
    public Map<String,String>folderIdToNameMap=new Map<String,String>();
    //Variable to store all folder information in this wrapper
    public FoldersInfo folderDetails{get;set;}
    //list to dispaly file list in UI
    public List<entry> fileList{get;set;}
    
    //variables for file upload
    public blob uploadContent{get;set;}
    public String uploadFilename{get;set;}
    
    //Constructor
    public BoxAuthController(){
        Authcode=ApexPages.currentPage().getparameters().get('code');
        securitycode=ApexPages.currentPage().getparameters().get('state');
        //clientid=skforce__Box_com_parameters__c.getValues('Box_sunil02kumar').skforce__client_id__c;  
        clientid='dxfiq6dxlanu3xlz3ttz8innxqki7g4q';
       // client_secret=skforce__Box_com_parameters__c.getValues('Box_sunil02kumar').skforce__client_secret__c;
       client_secret='kgkW4FzOzQDMrs0TjYvlFcDnnYZMk3Xh';
        //ViewAPI_Key=skforce__Box_com_parameters__c.getValues('Box_sunil02kumar').skforce__View_API_Key__c;
        //AccessToken=skforce__Box_com_parameters__c.getValues('Box_sunil02kumar').skforce__Access_Token__c;
        AccessToken ='dO8ND4T599oS2JhNMCrAod1vpUKlVKQQ';
        //RefreshToken=skforce__Box_com_parameters__c.getValues('Box_sunil02kumar').skforce__Refresh_Token__c;
        RefreshToken = '3M4CwyeYCKu4v6BZZG35j18j02zU6ez0fYU5D3gVs7lSKE1RpHWmckAI83lQbsxM';
        endPointURL='https://app.box.com/api/oauth2/token?';
        folderDetails=new FoldersInfo();
        fileList=new List<entry>();
    }
    //method to fetch files details from folder Response
    public void FindFileList(FoldersInfo folderDetails){
        fileList=new List<entry>();
        if(selectedFolder!=null && selectedFolder!=''){
            if(folderDetails.item_collection!=null){
                if(folderDetails.item_collection.entries.size()>0){
                    for(entry en: folderDetails.item_collection.entries){
                        if(en.type.equalsignorecase('file')){
                            fileList.add(en);
                        }
                    }
                }
            }
        }
    }
    public List<selectoption> getAllFoldersList(){
        List<selectoption> options=new List<selectoption>();
        options.add(new selectoption('','--None--'));
        if(folderIdToNameMap.size()>0){
            for(String ss:folderIdToNameMap.keyset()){
                options.add(new selectoption(ss,folderIdToNameMap.get(ss)));
            }
        }
       return options;
    }
    //Method to get get Authorization code after validating user on Box server
    public Pagereference AutorizeBox(){
        String endpointUrl1='https://app.box.com/api/oauth2/authorize?response_type=code&client_id='+clientid+'&state=sk02';
        pageReference pag=new pageReference(endpointUrl1);
        pag.setRedirect(true);
        return pag;
    }
    //Method to find Access Token using AuthCode
    public Pagereference FindAccessToken(){
        Response='';
        system.debug('*******Authcode:'+Authcode);
        if(Authcode!=null && Authcode!='' && securitycode=='sk02'){
            HttpRequest req = new HttpRequest();
            //endPointURL='https://app.box.com/api/oauth2/token?code='+Authcode+'&client_id='+clientid+'&client_secret='+client_secret+'&grant_type=authorization_code';
           endPointURL='https://app.box.com/api/oauth2/token?';
            System.debug('******endPointURL:'+endPointURL);
            req.setEndpoint(endPointURL);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            String bb='grant_type=authorization_code';
            req.setbody('grant_type=authorization_code'+
                       '&code='+Authcode+
                       '&client_id='+clientid+
                       '&client_secret='+client_secret);
            req.setHeader('Accept','application/json');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            Response=res.getBody();
            Integer statusCode=res.getStatusCode();
            System.debug(Response);
            // Parse JSON response to get refresh_token values.
            JSONParser parser = JSON.createParser(Response);
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                    String fieldName = parser.getText();
                    parser.nextToken();
                    if(fieldName == 'access_token') {
                        AccessToken= parser.getText();
                    }if(fieldName == 'refresh_token') {
                        RefreshToken= parser.getText();
                    }
                }
            }
            
            //fetch all folders details from BOX account by doing Callout
            FindAllAvailableBoxFolders(); 
            
            //always remeber that don't perform DML before callout 
            //updateBoxCustomSetting(); 
        }
        return null;
        
    }
    //Update access token and refresh token to custom setting
    /*public void updateBoxCustomSetting(){
        try{
           // List<skforce__Box_com_parameters__c> bx=[SELECT id,skforce__Access_Token__c, skforce__client_id__c, skforce__client_secret__c, skforce__Refresh_Token__c FROM skforce__Box_com_parameters__c 
                                                    where name='Box_sunil02kumar' limit 1] ;
          //  bx[0].skforce__Access_Token__c=AccessToken;
          //  bx[0].skforce__Refresh_Token__c =RefreshToken;
          //  update bx[0];
        }catch(exception e){
            system.debug('*********Exception while updating custom setting:'+e.getmessage());
        }
    }*/
    
    public PageReference SearchFolders(){
        FindAllAvailableBoxFolders();
        return null;
    }
    //This method will do callout and find out all available folders from Box
    public void FindAllAvailableBoxFolders(){
        Response='';
        folderDetails = new FoldersInfo();
        fileList=new List<entry>();
        //The root folder of a Box account is always represented by the id “0”.
        String boxPointURL='https://api.box.com/2.0/folders/0';
        Map<String,String>headers=new Map<String,String>();
        headers.put('Content-Type','application/x-www-form-urlencoded');
        headers.put('Accept','application/json');
        headers.put('Authorization','Bearer ' + accessToken);
        HTTPRequest req=createHTTPReq('', boxPointURL,'GET',headers);
        
        //do call out to fetch folders details
        HTTPResponse res=sendHttpRequest(req);
        Response=res.getBody();
        System.debug('**Folder Response:'+Response);
        //parse JSON response
        integer responseStatusCode=res.getStatusCode();
        if(responseStatusCode==200){
            folderDetails = (FoldersInfo )JSON.deserialize(Response,FoldersInfo.class);
            system.debug('********folderDetails :'+folderDetails );
            if(folderDetails.item_collection.entries.size()>0){
                for(entry en: folderDetails.item_collection.entries){
                    if(en.type.equalsignorecase('folder')){
                        folderIdToNameMap.put(en.id,en.name);
                    }
                }
            }
        }
        system.debug('******folderIdToNameMap:'+folderIdToNameMap);
    }
    
    
    //****code to find files present in different folders
    public Pagereference FindFilesFromFolder(){
        Response='';
        FileViewUrl='';
        folderDetails = new FoldersInfo();
        fileList=new List<entry>();
        if(selectedFolder!=null && selectedFolder!=''){
            String endpointURLForFiles = 'https://api.box.com/2.0/folders/'+selectedFolder;
            system.debug('*******endpointURLForFiles '+endpointURLForFiles );
            Map<String,String>headers=new Map<String,String>();
            headers.put('Content-Type','application/x-www-form-urlencoded');
            headers.put('Accept','application/json');
            headers.put('Authorization','Bearer ' + accessToken);
            HTTPRequest req=createHTTPReq('', endpointURLForFiles ,'GET',headers);
            
            //Now send request to fetch files details
            HTTPResponse res=sendHttpRequest(req);
            Response=res.getBody();
            System.debug('**Files Response:'+Response);
            
            //parse file response json
            folderDetails = (FoldersInfo )JSON.deserialize(Response,FoldersInfo.class);
            system.debug('********folderDetails :'+folderDetails );
            //find file list from respone to display in ui
            FindFileList(folderDetails);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select folder.'));
        }
        return null;
    }
    
    //Code to download file from Box
    public String selectedFileId{get;set;}
    public PageReference ViewFile(){
        
        system.debug('*****selectedFileId:'+selectedFileId);
        String fileDownloadUrl='';
        String tempDocumentid='';
        String fileSessionId='';
        if(selectedFileId!=null && selectedFileId!=''){
            fileDownloadUrl=FindFileDownloadUrl(selectedFileId);
            if(fileDownloadUrl!=null && fileDownloadUrl!=''){
                tempDocumentid=FindTempDocumentId(fileDownloadUrl);
            }
            if(tempDocumentid!=null && tempDocumentid!=''){
                fileSessionId=FindSessionIdForViewingFile(tempDocumentid);
                while(fileSessionId=='retry'){
                    fileSessionId=FindSessionIdForViewingFile(tempDocumentid); 
                }
                FileViewUrl='https://view-api.box.com/1/sessions/'+fileSessionId+'/view?theme=dark';
            }
        }
        return null;
    }
    //method to do call out to find out file download URL
    public String FindFileDownloadUrl(String selectedFileId){
        String downloadUrl='';
        Response='';
        if(selectedFileId!=null && selectedFileId!=''){
            String endPointURLToViewFile='https://api.box.com/2.0/files/'+selectedFileId+'/content';
            Map<String,String>headers=new Map<String,String>();
            headers.put('Authorization', 'Bearer ' + accessToken);
            headers.put('Content-Type','application/json');
            headers.put('Accept','application/json');
            HTTPRequest req=createHTTPReq('', endPointURLToViewFile,'GET',headers);
            
            //Now send request to fetch files details
            HTTPResponse res=sendHttpRequest(req);
            Response=res.getBody();
            System.debug('**File Download Response:'+Response);
            downloadUrl=res.getHeader('Location');
            system.debug('*******downloadUrl='+downloadUrl);
            
        }
        return downloadUrl;
    }
    //method to do call out to find temp Document Id
    public String FindTempDocumentId(String downloadUrl){
        String documentTempid='';
        Response='';
        if(downloadUrl!=null && downloadUrl!=''){
            String endPointURLForTempDocId='https://view-api.box.com/1/documents';
            Map<String,String>headers=new Map<String,String>();
            headers.put('Authorization', 'Token ' + ViewAPI_Key);
            headers.put('Content-Type','application/json');
            headers.put('Accept','application/json');
            String reqBody='{"url":"'+downloadUrl+'"}';
            HTTPRequest req=createHTTPReq(reqBody, endPointURLForTempDocId, 'GET', headers);
            
            //Now send request to fetch files details
            HTTPResponse res=sendHttpRequest(req);
            Response=res.getBody();
            System.debug('**File temp document id Response:'+Response);
            
            // Parse JSON response to get document id.
            /*
                {
                "type": "document",
                "id": "2da6cf9261824fb0a4fe532f94d14625",
                "status": "done",
                "name": "",
                "created_at": "2013-08-30T00:17:37Z",
                "modified_at": "2013-08-30T00:17:37Z"
                }
            */
            JSONParser parser = JSON.createParser(Response);
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                    String fieldName = parser.getText();
                    parser.nextToken();
                    if(fieldName == 'id') {
                        documentTempid= parser.getText();
                    }
                }
            }
            system.debug('*********temp document id:'+documentTempid);
             
        }
        return documentTempid;
    }
    
    public String FindSessionIdForViewingFile(String documentTempid){
        Response='';
        String fileViewSessionId='';
        if(documentTempid!=null && documentTempid!=''){
            String fileSessionIdendPointURL='https://view-api.box.com/1/sessions ';
            Map<String,String>headers=new Map<String,String>();
            headers.put('Authorization', 'Token ' + ViewAPI_Key);
            headers.put('Content-Type','application/json');
            headers.put('Accept','application/json');
            String reqBody='{"document_id":"'+documentTempid+'"}';
            HTTPRequest req=createHTTPReq(reqBody, fileSessionIdendPointURL, 'POST', headers);
            
            //Now send request to fetch files details
            HTTPResponse res=sendHttpRequest(req);
            Response=res.getBody();
            System.debug('**File temp document id Response:'+Response);
            Integer statusCode=res.getStatusCode();
            System.debug('***statusCode:'+statusCode);
            String retryDuration='';
            if(statusCode==202){
                //The document is not ready for viewing. A Retry-After header will be included in the response indicating the time to wait before trying again.
                retryDuration=res.getheader('Retry-After');
                system.debug('****retryDuration:'+retryDuration);
                //specify fileViewSessionId value as retry if file is not yet ready for viewing
                fileViewSessionId='retry';
            }else if(statusCode==201){
            
                // Parse JSON response to get document id.
                /*
                    {
                       "type": "session",
                       "id": "d1425e031062455f909740bb770b95a7",
                       "document": {
                          "type": "document",
                          "id": "ab0dc2d377524f44a98fd1476343637e",
                          "status": "processing",
                          "name": "",
                          "created_at": "2015-06-19T08:35:09Z"
                       },
                       "expires_at": "2015-06-19T09:35:10.020Z",
                       "urls": {
                          "view": "https://view-api.box.com/1/sessions/d1425e031062455f909740bb770b95a7/view",
                          "assets": "https://view-api.box.com/1/sessions/d1425e031062455f909740bb770b95a7/assets/",
                          "realtime": "https://view-api.box.com/sse/d1425e031062455f909740bb770b95a7"
                       }
                    }
                */
                String typeId='';
                JSONParser  parser = JSON.createParser(Response);
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                        String fieldName = parser.getText();
                        parser.nextToken();
                        String fieldValue=parser.getText();
                        if(fieldName == 'type' && fieldValue=='session') {
                            parser.nextToken();
                            if(parser.getText()=='id'){
                                parser.nextToken();
                                fileViewSessionId= parser.getText();
                                break;
                            }
                        }
                    }
                }
                system.debug('********typeId:'+typeId);
                system.debug('********fileViewSessionId:'+fileViewSessionId);
            }
        }
        return fileViewSessionId;
    }
    
    //Method to do call out to Box
    public HTTPResponse sendHttpRequest(HTTPRequest req){
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('****response body:'+res.getBody());
        return res;
    }
    //Method to generate HTTPRequest for call out
    public HTTPRequest createHTTPReq(String reqBody, string reqEndPoint, string reqMethod, Map<String,String> headersMap){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(reqEndPoint);
        req.setMethod(reqMethod);
        if(reqBody!=null && reqBody!=''){
            req.setbody(reqBody);
        }
        if(headersMap.size()>0){
            for(String ss : headersMap.keyset()){
                req.setHeader(ss,headersMap.get(ss));   
            }
        }
        req.setTimeout(120000);
        return req;
    }
    
    //apex class structure to deserialize Folder response JSON
    public class FoldersInfo{
        public String type{get;set;}
        public String id{get;set;}
        public String sequence_id{get;set;}
        public String etag{get;set;}
        public String name{get;set;}
        public String created_at{get;set;}
        public String modified_at{get;set;}
        public String item_status{get;set;}
        public String description{get;set;}
        public itemCollections item_collection{get;set;}
        public FoldersInfo(){}
        public FoldersInfo(String type,String id,String sequence_id,String etag,String name,String created_at,String modified_at,String description,String item_status ){
            this.type=type;
            this.id=id;
            this.sequence_id=sequence_id;
            this.etag=etag;
            this.created_at=created_at;
            this.modified_at=modified_at;
            this.description=description;
            this.item_status=item_status;
            this.item_collection=new itemCollections();
            
        }
    }
    
    public class itemCollections{
        public String total_count{get;set;}
        public List<entry> entries{get;set;}
        public itemCollections(){}
        public itemCollections(String count){
            this.total_count=count;
            this.entries=new list<entry>();  
        }
    }
    
    public class entry{
        public String type{get;set;}
        public String id{get;set;}
        public String name{get;set;}
        public entry(String type,String id,String name){
            this.type=type;
            this.id=id;
            this.name=name;
        }   
    }
    
   //code to upload files to BOX.COM
   public PageReference uploadFileToBox(){
       Response='';
       system.debug('****selectedFolder;'+selectedFolder);
       if(selectedFolder!=null && selectedFolder!=''){
           if(uploadContent!=null){
                blob base64EncodeFile=base64EncodeFileContent(uploadContent,uploadFilename);
                //blob fileContent=blob.valueof('test String');
                //blob base64EncodeFile=BoxUtility.base64EncodeFileContent(fileContent,'First file Upload');
                String uploadEndPointURL='https://upload.box.com/api/2.0/files/content?parent_id='+selectedFolder;
                String boundary = '----------------------------741e90d31eff';
                HttpRequest req = new HttpRequest();
                req.setBodyAsBlob(base64EncodeFile);
                req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
                req.setHeader('Content-Length',String.valueof(req.getBodyAsBlob().size()));
                req.setHeader('Authorization', 'Bearer ' + accessToken);
                req.setMethod('POST');
                req.setEndpoint(uploadEndPointURL);
                req.setMethod('POST');
                req.setTimeout(120000);
                //Send request to Box
                HTTPResponse res=sendHttpRequest(req);
                Response=res.getBody();
                System.debug('**Files upload Response:'+Response);
                Integer uploadStatusCode=res.getStatusCode();
                if(uploadStatusCode==201){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'File uploaded successfully.'));
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error encountered. Status Code;'+uploadStatusCode));
                }
           }else{
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please select file.'));
           }
       }else{
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select folder.');
           ApexPages.addMessage(myMsg);
       }
       return null;
   }
   
   //reference :http://blog.enree.co/2013/01/salesforce-apex-post-mutipartform-data.html
    public blob base64EncodeFileContent(Blob file_body, String file_name){
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
 
}