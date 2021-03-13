global with sharing class Remoting_ctrl
{

    public String accountName { get; set; }
    public static Account account { get; set; }
    //Default Constructor..
    public Remoting_ctrl() {}
    
    @RemoteAction
    global static Account getAccount(String accountName) 
    {
        //account = [select id, name, phone, type, numberofemployees from Account where name = :accountName ];
        account = [select id, name, phone, type, numberofemployees from Account where id = '0017F00000KwGUy'];
        return account;
    }
}