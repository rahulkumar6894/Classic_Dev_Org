public with sharing class BoxPage_Sameer_Sir_ctrl
{
    public String accessTokens { get; set; } // Variable for AccessTokens 
    public String FileInformatiom {get;set;} // Variable for File Informatiom to show in grid
    public Integer SizeOfSet {get;set;} // Variable for File Informatiom to show in grid
    public Integer count ;
    public Integer count2 ; 
    Set<String> setofid  = new Set<String>();
    Set<String> hitids= new Set <String>();
    //  constructor which have vaule of  FileInformatiom 
    public BoxPage_Sameer_Sir_ctrl() 
    {
        FileInformatiom='';
        String  FileInformatiom1='';
       
        count = 0;
        count2 = 0;
    } 
    public PageReference RootfolderDetails()
    {
     try
        {   
            count = 0;
            FileInformatiom='';
            string URL2 ='https://api.box.com/2.0/folders/0/items?limit=50&offset=0'; // making EndPoint URL variable
            HttpRequest req2 = new HttpRequest();        
            req2.setEndpoint(URL2);
            req2.setMethod('GET');  
            req2.setHeader('Authorization','Bearer '+accessTokens); // set headder Using AccessTokens
            req2.setHeader('Content-Type', 'application/json; charset=UTF-8');  
            Http ht = new Http();                       
            HttpResponse res2 = ht.send(req2);
            Count++;          
            String  Bodyinfo1 = res2.getBody(); 
            // Get the Body of box in Json 
            System.debug('res2.getBody()###############'+res2.getBody());
            if(res2.getStatusCode() == 200)
            {   
                RootObject rootobj1 = (RootObject)System.JSON.deserialize(Bodyinfo1,RootObject.class); //deserialize Json In Apex 
                //System.debug('rootobj1'+rootobj1);
                Integer entriesLenght = rootobj1.entries.size(); //check ka box folder and file lenght
                //System.debug('entriesLenght ***BoxitemDitails***'+entriesLenght);
                for(Integer i=0; i<=entriesLenght;i++) // loop for fetchOne By One folder 
                {  
                    String ValRootFolder = 'RootFolder'; 
                    if(rootobj1.entries[i].type =='folder')
                    { 
                        setofid.add(rootobj1.entries[i].id);system.debug('+++++setofid ***Root***+++++++++**'+setofid);
                    }                  
                    if(rootobj1.entries[i].type =='file')
                    { 
                        FileInformatiom += rootobj1.entries[i].id+','+rootobj1.entries[i].name+','+ValRootFolder+',';
                    }
                    BoxfileInfo(rootobj1.entries[i].id ,rootobj1.entries[i].type,rootobj1.entries[i].name,ValRootFolder);// check its folder or file  
                }
            }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,res2.getBody()));  
                    System.debug('Unauthorized ');
                 }            
        }
        catch(exception ex)
        {
            system.debug(ex.getMessage()+'  '+ex.getLineNumber());
        }  
        return null;   
    } 
    public void BoxfileInfo(String id1,String type,String Name,String ValRootFolder2)
    {
        try
        {   
            String RootFolder2;
            if(count<5)  //first Method Count 
            {
                if(type == 'folder')  // condition if getting folder otherWise its file
                {
                    //System.debug('Id'+ id1);
                      
                      
                    if(setofid.contains(id1))
                    {
                        setofid.remove(id1);
                        system.debug('removeID'+id1);                       
                    }
                    RootFolder2 = Name;
                    string URL2 ='https://api.box.com/2.0/folders/'+id1+'/items'; // making EndPoint URL variable
                    HttpRequest req2 = new HttpRequest();        
                    req2.setEndpoint(URL2);
                    req2.setMethod('GET');  
                    req2.setHeader('Authorization','Bearer '+accessTokens); // set headder Using AccessTokens
                    req2.setHeader('Content-Type', 'application/json; charset=UTF-8');  
                    Http ht = new Http();                       
                    HttpResponse res2 = ht.send(req2);
                    Count++;
                    String  Bodyinfo2 = res2.getBody(); // Get the Body of box in Json 
                    //System.debug('res2'+res2); 
                    //System.debug('res2.getBody()###############'+res2.getBody());
                    RootObject rootobj2 = (RootObject)System.JSON.deserialize(Bodyinfo2,RootObject.class);
                    Integer  len = rootobj2.entries.size();
                    System.debug('**Count****'+Count); 
                    for(integer j=0;j<len;j++)
                    { 
                        if(rootobj2.entries[j].id != null  )
                        { 
                            if(rootobj2.entries[j].type == 'folder')
                            { 
                                setofid.add(rootobj2.entries[j].id);
                                System.debug('set of id'+setofid);
                            }
                        BoxfileInfo(rootobj2.entries[j].id,rootobj2.entries[j].type,rootobj2.entries[j].name,RootFolder2 );// Again check its folder or file
                        }      
                   }
                }else
                {    
                    //System.debug(ValRootFolder2);
                        string hrf = 'https://www.google.com';  
                     // String FileName = '<a>'+Name+'</a>';
                      String FileName =  '<a href='+hrf+' target="_blank" >'+Name+'</a>/>';
                     FileInformatiom += id1+','+FileName +','+ValRootFolder2+',';
                    //System.debug('FileInformatiom'+FileInformatiom);
                }     
            }
          SizeOfSet = setofid.size();
          System.debug('SizeOfSet&&&&****&&*&'+SizeOfSet);
        }catch(exception ex)
        {
            system.debug(ex.getMessage()+'  '+ex.getLineNumber());
        }
    }
    public void againfiledetailsfn() 
    {
        count2  = 0;
        System.debug('finalsetofid'+setofid);
        Integer setofIdLength = setofid.size();
        //System.debug('setofIdLength '+setofIdLength );
        for(Integer i=0; i<=setofIdLength-1; i++)
        {
            String id1= new List<String> (setofid).get(i);
            System.debug('id1'+id1);
            string URL2 ='https://api.box.com/2.0/folders/'+id1+'/items'; // making EndPoint URL variable
            HttpRequest req2 = new HttpRequest();        
            req2.setEndpoint(URL2);
            req2.setMethod('GET');  
            req2.setHeader('Authorization','Bearer '+accessTokens); // set headder Using AccessTokens
            req2.setHeader('Content-Type', 'application/json; charset=UTF-8');  
            Http ht = new Http();                       
            HttpResponse res2 = ht.send(req2);
            count2 ++;
            System.debug('count2++againfiledetailsfn()'+count2 );
            String  Bodyinfo1 = res2.getBody(); // Get the Body of box in Json 
            //System.debug('res2.getBody()###############'+res2.getBody());
            if(res2.getStatusCode() == 200)
            {   
                RootObject rootobj3 = (RootObject)System.JSON.deserialize(Bodyinfo1,RootObject.class); //deserialize Json In Apex
                Integer entriesLenght = rootobj3.entries.size(); //check ka box folder and file lenght
                System.debug('entriesLenght ***BoxitemDitails***'+entriesLenght);
                for(Integer j=0; j<=entriesLenght-1;j++) // loop for fetchOne By One folder 
                {  
                    if(rootobj3.entries[j].id != null  )
                    {
                        System.debug(rootobj3.entries[j].id+','+rootobj3.entries[j].name);
                        String folderName= 'SecoundMethod';
                        BoxfileInfo2(rootobj3.entries[j].id,rootobj3.entries[j].type,rootobj3.entries[j].name,folderName);// Again check its folder or file
                    } 
                }                  
            }
        }   
    }
    public void BoxfileInfo2(String id3,String type3,String Name3, String ValRootFolder3 )
    {
        //System.debug('id1'+id3+'type'+type3+'Name'+Name3);
        String RootFolder3 ;
        System.debug('Iam'+count2);
        if(count<5)                                     // Secound Method Count 
        {
            if(type3 == 'folder')  // condition if getting folder otherWise its file
            {
                RootFolder3 = Name3;
                string URL2 ='https://api.box.com/2.0/folders/'+id3+'/items'; // making EndPoint URL variable
                HttpRequest req2 = new HttpRequest();        
                req2.setEndpoint(URL2);
                req2.setMethod('GET');  
                req2.setHeader('Authorization','Bearer '+accessTokens); // set headder Using AccessTokens
                req2.setHeader('Content-Type', 'application/json; charset=UTF-8');  
                Http ht = new Http();                       
                HttpResponse res2 = ht.send(req2);
                count2++;
                System.debug('BoxfileInfo2*****count'+''+count2);
                String  Bodyinfo2 = res2.getBody(); // Get the Body of box in Json 
                //System.debug('res2'+res2); 
                //System.debug('res2.getBody()###############'+res2.getBody());
                RootObject rootobj2 = (RootObject)System.JSON.deserialize(Bodyinfo2,RootObject.class);
                Integer  len = rootobj2.entries.size();
                for(integer j=0;j<len;j++)
                {  
                    if(rootobj2.entries[j].id != null  )
                    { 
                        BoxfileInfo2(rootobj2.entries[j].id,rootobj2.entries[j].type,rootobj2.entries[j].name,RootFolder3 );// Again check its folder or file
                    }      
                }
          }else{    
                //System.debug(ValRootFolder2);  
                 FileInformatiom += id3+','+Name3 +','+ValRootFolder3+',';
                System.debug('FileInformatiom======'+FileInformatiom);
            } 
       }
                           
    }
     
    // Wrapper class    
    public class RootObject
    {
        public List<Entry> entries { get; set; } // Entries have information file& folder form Box
        public String created_at;   // Variable for Created date 
        public CreatedBy created_by { get; set; } // Variable for modified date
        public String name; // Variable for name   @ user name
        public String id; // Variable for Id   @    userId
        public String type;    //type= user 
    }
    // Wrapper class in class for Entries
    public class Entry
    {
        public string type { get; set; }
        public string id { get; set; }
        public string name { get; set; }
        public String created_at  {get;set;}
    }
     // Wrapper class in class for CreatedBy
    public class CreatedBy
    {
        public string type { get; set; }
        public string id { get; set; }
        public string name { get; set; }
        public string login { get; set; }
    }
}