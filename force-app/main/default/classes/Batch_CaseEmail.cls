/*How to Send More than 10 E-mails
This is about how to send more than 10 E-mails. As we know we have a governor limit of sending 10 emails in a process so this is a workaround to send more than E-mails. We can do this by using batch class.


Lets say we have to send all System Administrators details of case logged by them 
today in a particular format. If suppose we have 15 System Administrators in our organisation, 
all of them logged 2-3 cases in a day and in the end of the day
we want to send the details of case logged only by them in an Email. So here is the code :

To run code
Batch_CaseEmail controller = new Batch_CaseEmail() ;
Integer batchSize = 1;
database.executebatch(controller , batchSize);


*/
global class Batch_CaseEmail implements Database.Batchable<sObject>,Database.Stateful
{
   Map<Id , List<Case>> userCaseMap {get; set;}
   List<Case> allCaseLoggedToday {get; set;}
   
   global Batch_CaseEmail()
   {
       //Map to maintain user id and cases logged by them today
       userCaseMap = new Map<Id, List<Case>>() ;
       
       //All sales rep (System admins)
       List<User> salesRep = new List<User>() ;
       salesRep = [select id , name , Email , ManagerId from User where Profile.Name = 'System Administrator'] ;
       
       //All sales rep ids
       List<Id> salesIds = new List<Id>() ;
       for(User ur : salesRep)
       {
           salesIds.add(ur.Id) ;
       }
      
       //All cases logged today by sales rep
       allCaseLoggedToday = new List<Case>() ;
       allCaseLoggedToday = [select Id, CaseNumber,CreatedById, Owner.name , account.Name , contact.name from Case where CreatedDate = TODAY AND CreatedById in : salesIds] ;
   }

   global Database.QueryLocator start(Database.BatchableContext BC)
   {
      //Creating map of user id with cases logged today by them
      for(Case c : allCaseLoggedToday)
      {
          if(userCaseMap.containsKey(c.CreatedById))
          {
              //Fetch the list of case and add the new case in it
              List<Case> tempList = userCaseMap.get(c.CreatedById) ;
              tempList.add(c);
              //Putting the refreshed case list in map
              userCaseMap.put(c.CreatedById , tempList) ;
          }
          else
          {
              //Creating a list of case and outting it in map
              userCaseMap.put(c.CreatedById , new List<Case>{c}) ;
          }
      }

      //Batch on all system admins (sales rep)
      String query = 'select id , name , Email from User where Profile.Name = \'System Administrator\'';
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope)
   {
       
      for(Sobject s : scope)
      {
          //Type cast sObject in user object
          User ur = (User)s ;
          
          //If system admin has logged any case today then only mail will be sent
          if(userCaseMap.containsKey(ur.Id))
          {
              //Fetching all cases logged by sys admin
              List<Case> allCasesOfSalesRep = userCaseMap.get(ur.Id) ;
              
              String body = '' ;
              //Creating tabular format for the case details
              body = BodyFormat(allCasesOfSalesRep) ;
              
              //Sending Mail
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;
              
              //Setting user email in to address
              String[] toAddresses = new String[] {ur.Email} ;
              
              // Assign the addresses for the To and CC lists to the mail object
              mail.setToAddresses(toAddresses) ;
    
              //Email subject to be changed
              mail.setSubject('New Case Logged');
              
              //Body of email
              mail.setHtmlBody('Hi ' + ur.Name + ',<br/><br/> Details of Cases logged today is as follows : <br/><br/>' + body + '<br/> Thanks');
        
              //Sending the email
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
          }
      }
   }
   
   public String BodyFormat(List<Case> lst)
   {
       String str = '' ;
       for(Case cs : lst)
       {
           str += '<tr><td>'+ cs.CaseNumber +'</td>'+'<td>'+ cs.Owner.Name +'</td>'+'<td>'+ cs.Account.Name +'</td>'+'<td>'+ cs.Contact.Name +'</td>'+'</tr>' ;
       }
       str = str.replace('null' , '') ;
       String finalStr = '' ;
       finalStr = '<table border="1"> <td> CaseNumber </td> <td> Owner </td> <td> Account </td> <td> Contact </td> '+ str +'</table>' ;
       return finalStr ;
   }

   global void finish(Database.BatchableContext BC)
   {
   }

}