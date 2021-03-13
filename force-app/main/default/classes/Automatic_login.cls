public with sharing class Automatic_login {

    public String sCurrentUser {get; set;}

    public Automatic_login(){
       sCurrentUser = Userinfo.getUserId();
           redirect(); 
    }
    public PageReference redirect(){
        
       PageReference pageRef = new PageReference('/apex/schoolHome');
            return pageRef;
    }
}