public with sharing class AjaxUtility {
 public List<Account> accList{get;set;}
    public List<Wrap> wrapList{get;set;}
    public AjaxUtility()
    {
        fillDataInTable();
    }
    public void fillDataInTable()
    {
        wrapList = new List<wrap>();
        for(Account acc : [Select id, name, phone, AccountNumber, fax From Account Order By LastModifiedDate DESC Limit 5])
        {
            wrapList.add(new wrap(acc));
        }
    }
    public class Wrap
    {
        public Account acc{get;set;}
        public boolean checkbox{get;set;}
        public Wrap(Account acc)
        {
            this.acc = acc;
            checkbox = false;
        }
    }





}