public class mapExamples{
     
    map<ID,Map<ID,Contact>> mapofacc = new map<ID,map<ID,Contact>>();
    public mapExamples()
    {
      list<Account> listofacc = [Select Id from account ];
      Map<String,Map<String,String>>initStringStringMap = new Map<String,Map<String,String>>{'one' => new Map<String, String>{'a'=>'b', 'c'=> 'd'}, 'two' =>new Map<String, String> {'e'=>'f', 'g'=> 'h'} };
for(String outerKey : initStringStringMap.keySet())
for(String innerKey : initStringStringMap.get(outerKey).keySet())
System.debug(' ----------------------------------------------------------------  >>>>>>>>>>>>>>>' + initStringStringMap.get(outerKey).get(innerKey));
    }
}