public class exportExcel {

    public PageReference getexport() {
        return null;
    }


    public Boolean isExport { get; set; }
    
    Public String sExcelHeader{get;set;} 
  
    Public exportExcel(){
      
        sExcelHeader = 'FirstName, LastName';
        isExport = true;
    }
    public List<contact> contacts {get;set;}
    public pageReference fetch()
    {
        contacts = [SELECT Id,firstname,lastname FROM Contact limit 20];
        
        return null;
    }   
}