public with sharing class ExtJs_Ass2 {

    public String JsonVal { get; set; }

    public String val { get; set; }

    public ExtJs_Ass2()
    {
        JsonVal = '';
    }
    public void addNewNode()
    {
        if(val != null && val != '')
        {
            //JsonVal =  JsonVal + '{"text":"<label >'+val+'</label>"},';
          
             //JsonVal =  JsonVal + '{"text":"'+val+'<label class=\'Icons\'></label><label class=\'testIcons\'></label>"},';
             JsonVal =  JsonVal + '{"text":"'+val+'<label class=\'testIcons\' onclick=\'childNode();\'></label><label class=\'bestIcons\'></label>"},';


            system.debug('---------'+Val);
        }
        val='';
    }


}