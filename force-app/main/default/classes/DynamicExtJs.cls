public with sharing class DynamicExtJs {

    public String val { get; set; }

    public String JsonVal { get; set; }

    public DynamicExtJs()
    {
        JsonVal = '';
    }
    public void addNewNode()
    {
        if(val != null && val != '')
        {
            JsonVal =  JsonVal + '{"text":"<label>'+val+'</label>"},';
            system.debug('---------'+Val);
        }
        val='';
    }


}