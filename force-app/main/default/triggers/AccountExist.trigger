trigger AccountExist on Account (before insert) {
   
    set <String> newnamelist= new set <String>();
    set <String> existinglist= new set <String>();
    
    for(Account c : Trigger.New){
        IF(c.Name != '' && c.Name != NULL){
            If(!newnamelist.contains(c.Name)){
                newnamelist.add(c.Name);
            }
        }
    }
    for(Account con : [SELECT Name From Account]){
        existinglist.add(con.Name);
    }
    
IF(Trigger.IsInsert ){
        for(Account c1 : Trigger.New){         
            IF(existinglist.contains(c1.Name)){
                c1.Name.addError('Name Already Exists : '+c1.Name);
            }else if(c1.Name != null || c1.Name != ''){
                existinglist.add(c1.Name);
            }
        }
    }  
           
   }