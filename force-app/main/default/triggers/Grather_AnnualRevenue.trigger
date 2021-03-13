trigger Grather_AnnualRevenue  on Account (Before Update) {
   
    Set<Id> OldAccountId = new Set<ID>();
    for(Account acc :Trigger.old)
    {
        OldAccountId.add(acc.ID);
    }
    Map<Id,Decimal> MapAcc = new Map<Id,Decimal>();
    for(Account a : [Select Id,AnnualRevenue from Account where Id In :OldAccountId])
    {
        MapAcc.put(a.Id,a.AnnualRevenue );
    }
    IF(Trigger.isUpdate)
    {
        for(Account acc2 : Trigger.new)
        {
            if( MapAcc.ContainsKey(acc2.Id) )
            {
                Decimal Value1 =  acc2.AnnualRevenue;
                Decimal Value2 = MapAcc.get(acc2.Id);
                System.debug('@@@@@@'+Value1+'#######'+Value2);
                if(Value1<Value2)
                {
                    acc2.AnnualRevenue.addError('Please Enter Grather Value Then Old Value ');
                }
            }
        }
    }

     /*
        IF(Trigger.isUpdate)
    {
         for(Account acc :Trigger.old)
         {
              for(Account acc2 : Trigger.new)
              {
                 if(acc2.AnnualRevenue <= acc.AnnualRevenue )
                 {
                    acc2.AnnualRevenue.addError('Length'+acc.AnnualRevenue+'@@@@@@@'+acc2.AnnualRevenue);
                 }
              }
              
         }
    }
    */
}