public with sharing class myAccounts {

    public PageReference ShowAccount() {
        return null;
    }


    public String a { get; set; }

    public List<Account> accounts { get {
    accounts = [select name, id from account where ownerid = :userinfo.getuserid()];

    return accounts;
    } set; }
}