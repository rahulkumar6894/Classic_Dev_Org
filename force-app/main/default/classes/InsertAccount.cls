public class InsertAccount {

    public  String insertAccount() {
      Account Acc = new Account();
        Acc.Name = AccountName;
        insert Acc;
         
     System.debug ('Account Name'+AccountName);
        return null;
    }


public String AccountName{get;set;}

}