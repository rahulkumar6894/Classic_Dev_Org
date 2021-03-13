trigger UpdateAmountInContact on Opportunity (after insert) {
Map<String,Decimal > AccVsAmount = new Map<String,Decimal >();
List<String> AccountIds = new List<String>{'0017F00002MdmPaQAJ','0017F00002MeCiT'};

for(Account acc: [SELECT Id,(select Amount from opportunities order by Amount desc NULLS LAST Limit 1 )from Account where Id in:AccountIds])
{
      Decimal  abc=0;
      if(acc.opportunities.size()>0){
           abc= acc.opportunities[0].Amount;
      } 
        AccVsAmount.put(acc.id,abc);
}
system.debug('AccVsAmountAccVsAmountAccVsAmount'+AccVsAmount);
List<Contact>  updateconlist = new List<Contact>();
for(Contact con: [Select Id,AccountId from Contact where AccountId in: AccVsAmount.keySet()] )
{
    Contact objcon = new Contact(Id =con.ID );
    objcon.Salary__c =  AccVsAmount.get(con.AccountId);
    updateconlist.add(objcon);
}
system.debug('updateconlistupdateconlist'+updateconlist);
}