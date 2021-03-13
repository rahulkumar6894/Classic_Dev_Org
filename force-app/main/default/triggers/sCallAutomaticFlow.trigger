trigger sCallAutomaticFlow on Employee__c (after insert) {
     if(Trigger.IsInsert){
      for(Employee__c  empObj : trigger.new){
         system.debug('empObj >>>>>'+empObj.Id);
         Flow.Interview.Create_Account  avgQualityOnContFlow = new Flow.Interview.Create_Account(new map<String,Object>{'AccountName' => empObj.Name});
         //avgQualityOnContFlow.start();
         
          /* How to Call Autolanched flow 
            Map<string, string> nor = new Map<string, string>();
            nor.put('AccountName' , 'Test');
            system.debug('conMap::Before:::::' + nor);
            Flow.Interview.Create_Account  avgQualityOnContFlow = new Flow.Interview.Create_Account(new map<String,Object>{'AccountName' => 'yes Console'});
            avgQualityOnContFlow.start();
         */
      }
     }

}