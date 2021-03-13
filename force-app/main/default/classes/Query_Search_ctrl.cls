public with sharing class Query_Search_ctrl {

    public  list<Contact>  Records { get; set; }

    public String Search { get; set; }
    public String SelectField { get; set; }
    public String operater { get; set; }
    public String text1 {get;set;}
   // list<sobject> records;
    public Query_Search_ctrl(){
       
     }
    public PageReference Search() {
     try{
        String soql ='';
        Records  = new list<Contact>();
        System.debug('SelectField '+SelectField );
        System.debug('operater '+operater );
        System.debug('text1+++++++++++'+text1.length());
        if(text1.length() ==0)
        {
         text1= ' ';
        }
        if(operater == 'LIKE')
        {  
            IF(SelectField != 'id')
             {
               
                System.debug('Like and first and last' );
                soql = 'select  Id ,FirstName from ' +'Contact where'+' '+SelectField+' ' +operater+ '\'%' + text1 + '%\''; 
                 System.debug('soql '+soql );
           }
        }
        
        if(operater =='Equals' && SelectField == 'id')
        {
            System.debug('Equalsand first and ID' );
            soql = 'select  Id ,FirstName from '+'Contact where '+SelectField+' = '+'\'' + text1 + '\''; 
        }
        if(operater =='NotEquals'&& SelectField == 'id')
        {
            System.debug('NotEquals and first and ID' );
            soql = 'select  Id, FirstName from Contact where '+SelectField+' != '+'\'' + text1 + '\''; 
       }
        
       

        System.debug('soql'+soql);
        System.debug('soql'+soql.length());
        if(soql.length()!=0)
        {  
           System.debug(Database.query(soql).Size());
           if(Database.query(soql).Size() !=0)
           {
             Records = Database.query(soql ); 
             System.debug('Records Lenght'+Records.Size());
             System.debug('Records '+Records );
           }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No Data to Display'));

                }
       }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Set Proper Filter'));
                }
      }catch (System.CalloutException e)
       {
       System.debug('ERROR:' + e);
       }
    return null;
    }

}