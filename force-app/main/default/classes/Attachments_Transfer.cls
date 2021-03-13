public with sharing class Attachments_Transfer{

   //Transfer_Attachments from One Sobject to Another One
   /*
   List insertingAttachments = new List();
   List deletingAttachments = new List();
   for(Attachment atch :  [select id,name,body from Attachment where parentid = 'your Opportunity id' ])
   {
        Attachment  newattch = new Attachment();  
        newattch = atch.clone(false);
        newattch.body = atch.body; // required field
        newattch.name = atch.name;// required field  
        newattch .parentId = 'your Case id ';
        insertingAttachments.add(newattch); 
        deletingAttachments.add(atch);
    }
    insert   insertingAttachments;
    delete  deletingAttachments 
   
   
   */
}