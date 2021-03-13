public with sharing class extJsAgain {

    public String valchild { get; set; }
    public String child { get; set; }
    public String val { get; set; }
    public String JsonVal { get; set; }
    
    public extJsAgain ()
    {
        JsonVal = '';
       
    }
    public void addNewNode()
    { 
        if(val != null && val != '' )
        {  
         system.debug('---------'+valchild);
          JsonVal =  JsonVal + '{"text":"'+val+'<label class=\'addIcons\'></label>"},';
          //JsonVal =  JsonVal + '{"text":"'+val+'<label class=\'addIcons\' onclick=\'addNode()\'></label>"}';
        //  JsonVal =  JsonVal + '{"text":"'+val+'<label class=\'addIcons\' onclick=\'addNode()\'></label>"},"ghfg"';
             //JsonVal =  '{"text":"'+val+'<label class=\'addIcons\' onclick=\'childNode()\'></label>",children:[{"text":"'+valchild+'"}]},';

            system.debug('---------'+Val);
            system.debug('--jsonval-------'+JsonVal);
        }
        
     
    }
    
}