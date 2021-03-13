global class WebServiceGetACC {
 
  webService static List<Account>GetAllAccountData()
   {
         List<Account> acclist = new  List<Account>();
         acclist = [SELECT Id, Name FROM Account];
         return acclist ;
   }
}