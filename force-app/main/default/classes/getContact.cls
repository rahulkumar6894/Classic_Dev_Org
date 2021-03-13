@RestResource(urlMapping='/Rahul/getContacts/*')
   global with sharing class getContact {
     @Httpget
      global static list<contact> fetchAccount(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        
        list<contact> lstcontact =[Select id ,name,Phone,Fax,Email from contact];
        
        return lstcontact ;
      }
   }