trigger Duplicate_Email on Contact (before insert, before update){
    Set<String> EmailSet = new set<String>();
    Set<String> ExistingEmailSet = new set<string>();
 
    for(Contact c : Trigger.New){
        IF(c.Email != '' && c.Email != NULL){
            If(!EmailSet.contains(c.Email)){
                EmailSet.add(c.Email);
            }
        }
    }
    
    //Updating ExistingEmailSet
    for(Contact con : [SELECT Email From Contact where Email IN :EmailSet]){
        ExistingEmailSet.add(con.Email);
    }
    
    IF(Trigger.IsInsert || Trigger.IsUpdate){
        for(Contact c1 : Trigger.New){
            System.Debug(ExistingEmailSet);
            IF(ExistingEmailSet.contains(c1.Email)){
                c1.Email.addError('Email Already Exists : '+c1.Email);
            }else if(c1.Email != null || c1.Email != ''){
                ExistingEmailSet.add(c1.Email);
            }
        }
    }
    
}