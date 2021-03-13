public with sharing class TableController {

    public String Phone { get; set; }

    public String email { get; set; }

    public String lastName { get; set; }

    public String firstname { get; set; }



   public id Idstr {get;set;} // Checked Id for Delete
   public String conlist { get; set; }
   
   
   // constructor for send the record in active widgets
   public TableController ()
   {
   
        conlist = '[';
        for (contact a : [SELECT Id, FirstName,LastName, Phone,Email 
                            FROM contact ORDER BY createddate DESC LIMIT 10]) 
        {
            System.debug('Rahullllll'+a);
            if(a.Phone == null ){
                a.Phone = 'Record Not Avialable ';
            }
            if( a.FirstName == null || a.FirstName == 'Null'){
                a.FirstName = 'Record Not Avialable ';
            }
            if(a.Email==null){
                a.Email = 'Record Not Avialable ';
            }
            String chkbox = '<input type=\'checkbox\' id=\'' +a.Id+ '\' value=\'' +a.Id+ '\' onclick=\'oncolumnckeckboxclick(this.value);\'>';
            conlist += '["' +chkbox+ '","' +a.Id + '","' +a.FirstName+ '","' +a.LastName + '","' + a.Phone+ '"],';
        }
        
        conlist += ']';
        system.debug('conlist::::'+ conlist);
    }
                   
   public String getconlist() { return conlist ; }
  
   // mehtod for Delete check data
   public PageReference deletedata() {
           try{
                    Contact myObjs = [SELECT Id FROM Contact WHERE Id =:Idstr];
                    delete myObjs;
                    PageReference pf = new PageReference('/apex/ActiveWidget_TableUsing_Controller');
                    pf.setRedirect(true);
                    return pf;
              }catch(Exception e){
                    system.debug(e);
                    apexpages.Message  msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Selected the checkbox ');
                    apexpages.addmessage(msg);  
                    }
        return null ;
        }
                
                
                
                
                
                
           // mehtod for Edit check data            
    public PageReference editrecord() {
            try{
                    Contact con =[SELECT id,firstname,LastName ,Email,Phone  FROM Contact WHERE Id = :Idstr];
                    firstname = con.firstname ;
                    LastName = con.LastName ;
                    Email   = con.Email;
                    Phone  = con.Phone  ;
              }catch(Exception e){
                    system.debug(e);
                    apexpages.Message  msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Selected the checkbox ');
                    apexpages.addmessage(msg);
                    }
                 return null ;
          }
                
                
                
                
           // method Update after Edit Data    
          
    public PageReference updateData() {
         try{
                Contact con =[SELECT id,firstname,LastName ,Email,Phone  FROM Contact WHERE Id = :Idstr];
                con.firstname =  firstname;
                con.LastName  =  LastName ;
                con.Phone     =  Phone   ;
                update con; 
                PageReference pf = new PageReference('/apex/ActiveWidget_TableUsing_Controller');
                pf.setRedirect(true);
                return pf;
               
          }catch(Exception e){
                    system.debug(e);
                    apexpages.Message  msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Selected the checkbox ');
                    apexpages.addmessage(msg);
                     }
        return null ;
        }
     
    
    
              
        /*  PageReference pf = new PageReference('/apex/ActiveWidget_TableUsing_Controller');
          pf.setRedirect(true);
          return pf;
          }*/
}