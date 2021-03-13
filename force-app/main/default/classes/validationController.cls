public with sharing class validationController {
        public String Phone { get; set; } // Variable for Phone
        public String email { get; set; }  // Variable for email 
        public String lastName { get; set; }// Variable for lastName 
        public String firstname { get; set; }// Variable for firstname 
        public id Idstr {get;set;} // Checked Id for Delete
        public id Idstr1 {get;set;} // Checked  Id for edit,update Idstrlist
        public List<Contact> conlist { get; set; } // list of contact to Show in vf page
        public String Idstrlist {get;set;} 
        // Constructor
        public validationController ()
        {
            conlist =new  List<Contact>();
            conlist = [SELECT Id, FirstName,LastName ,Email,Phone FROM Contact ORDER BY createddate DESC LIMIT 10]; // Retrive Record from Contact Object
        }
        public void show()
        {
            conlist = [SELECT Id, FirstName,LastName ,Email,Phone FROM Contact ORDER BY createddate DESC LIMIT 10]; // Retrive Record from Contact Object
        }
        // Method for Insert in object  Record after Validation 
        public PageReference showData() 
        {
             contact con = new contact();
             con.FirstName = firstname;
             con.LastName = lastName;
             con.email = email;
             con.phone = phone;
             insert con;     
             show();
             return null;
      }
      // Method for update in object  Record after Validation 
      public PageReference updateData() 
      {
            Contact con =[SELECT id,firstname,LastName ,Email,Phone  FROM Contact WHERE Id = :Idstr1];
            con.firstname =  firstname;
            con.LastName  =  LastName ;
            con.Email     =  Email   ;
            con.Phone     =  Phone   ;
            update con;
            show();
            return null;
      }
      // Edit Method after click edit method
      public PageReference editrecord()
      {
        Contact con =[SELECT id,firstname,LastName ,Email,Phone  FROM Contact WHERE Id = :Idstr1];
        firstname = con.firstname ;
        LastName = con.LastName ;
        Email   = con.Email;
        Phone  = con.Phone  ;
        return null;
      }
      // Method for Delete Data from Contact
      public PageReference deletedata()
     {
        Contact myObjs = [SELECT Id FROM Contact WHERE Id =:Idstr];
        delete myObjs;
        show();
        return null;
    }
    // Method for multiDelete Data from Contact
    public PageReference multideletedata1()
    {
        list<object> lstString = (list<object>)JSON.deserializeUntyped(Idstrlist);
        list<string> abcString = new list<String>();
        for(object abc : lstString)
        {
          abcString.add((string)abc);
        }
        system.debug(abcString);
        delete [SELECT Id FROM Contact WHERE id in :abcString ];
        show();
        return null;
    }
    
    

}