public with sharing   class RemotingWithWrapper {
 
    public String accountName { get; set; }
    public static Account account { get; set; }
     public string strDealIdMNA { get;set;}
    public RemotingWithWrapper() { 
    strDealIdMNA ='Rahulconstructor';
    } // empty constructor
    public PageReference sayHello() {
        System.debug('------------Hey Action--------------');
        return null;
    }
    @RemoteAction
    public static jsonWrapper  searchJosn(String abc ) {
         System.debug('------------Hey abc--------------'+abc);

        jsonWrapper objwrapper =  new jsonWrapper();
        objwrapper.sAccountJson = abc;
         objwrapper.sTargetJson = 'Target';
             return objwrapper;
    } 
    public class jsonWrapper {
        public string sAccountJson {get;set;}    
        public string sTargetJson {get;set;}    

    }
}