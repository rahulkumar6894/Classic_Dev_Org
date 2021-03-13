public class sObjects {
    public void Show(){
    //List<Employee2__c> emplist=[Select Id,Name,Last_Name__c from Employee2__c where Name='Rohit' Limit 1];
    List< Account> conlist=[Select Name,AccountNumber from  Account];
       // System.debug('MY employee2 List Here!'+emplist);
        System.debug('Account List Here!'+conlist);
/*
         // Insert
         List
        Account a=new Account();
        a.Name='';
         insert a;
        Integer i1= [SELECT COUNT() FROM Account];
          System.debug('Count'+i1);
        Employee2__c onj= new Employee2__c();*/
        //Update
    /* Contact conobj=[Select Id,Name,LastName from Contact where LastName='Rahul'];
        conobj.FirstName='Rahul';
        conobj.LastName='Gupta';
        update conobj;
        System.debug(conobj);
          Contact conobj1=[Select Id,Name,LastName from Contact where LastName='yNavatarGroup'];
        delete conobj1;
        System.debug('Succes');*/
    }

}