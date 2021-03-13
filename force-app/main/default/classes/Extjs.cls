public class Extjs 
{

    public String rootName { get; set; }
    public String child{get;set;}
    public String name{get;set;}
    public Extjs()
    {
        rootName ='country';
        child = '';
    }
    public void actionfn()
    {
        if(name != null && name != '')
        {
            child =  child + '{"text":"'+name+'<label class=\'appendIcons\'></label><label class=\'appendIcons1\'></label></label><label class=\'appendIcons2\'></label>"},'; 
            System.debug(child);       
        }
        name='';
    }
}