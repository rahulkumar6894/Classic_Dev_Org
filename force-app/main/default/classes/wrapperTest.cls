public with sharing class wrapperTest {

    public PageReference wrapperRecordLst() {
        return null;
    }


    public List<wrapperRecord> wrapperRecordLst { get; set; }// Wrapper Class list
    
    public wrapperTest (){
    wrapperRecordLst = new List<wrapperRecord>();
    
    // Retrive Data from Object
    List<Employee2__C> listEmp2 = [SELECT Id,Name,CreatedByID,CreatedBy.name  FROM Employee2__c];
    List<Project_Name__c> listpro = [SELECT Id,Name,CreatedByID,CreatedBy.name   FROM Project_Name__c];
    
    // adding Employee2 data in WrapperRecord LIst
    for(Employee2__C emp2 :listEmp2 ){
        wrapperRecord wrapObj = new wrapperRecord();
        wrapObj.id = emp2.id;
        wrapObj.name = emp2.name;
        wrapObj.CreatedByID = emp2.CreatedByID ;
        wrapObj.CreatedByname = emp2.CreatedBy.name;
        wrapObj.ObjectName ='Employee';
        wrapperRecordLst.add(wrapObj);}
    
    for(Project_Name__c pro :listpro){
        wrapperRecord wrapObj = new wrapperRecord();
        wrapObj.id = pro .id;
        wrapObj.name = pro .name;
        wrapObj.CreatedByID = pro .CreatedByID ;
        wrapObj.CreatedByname = pro .CreatedBy.name;
        wrapObj.ObjectName ='Project';
        wrapperRecordLst.add(wrapObj);}
    }
    
    
   // wrapper Class 
   public class wrapperRecord {
   
   public String name { get; set; }
   public String CreatedByID { get; set; }
   public string id { get; set; }
   public String CreatedByname{ get; set; }
   public String ObjectName{ get; set; }
   public wrapperRecord(){
       id = '';
       name = '';
       CreatedByID = '' ;
       CreatedByname ='';
   }
  
   
   }
    
}