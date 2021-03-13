public with sharing class ExtJsController {

    public String rootName { get; set; }
    public String renameNode { get; set; }
    public String name { get; set; }
    public String newnode { get; set; }
    public ExtJsController()
    {
        rootName = 'Root';
        newnode = '';
        childofchild = '';
    }
     
    public void addNewNode()
    {
            if(name!= null && name!= '')
            {
                newnode =  newnode + name;
                system.debug('---------'+name);
            }
            name='';
    }
    
     public void renamefn()
     {
            rootName = renameNode ;
     }
     public String childofchild { get; set; }
     public String childname { get; set; }
     public String renamechild { get; set; }
     public String namechild { get; set; }
     public void addchildfn() 
     {
            if(namechild != null && namechild != '')
            {
                childofchild=  childofchild + namechild;
                system.debug('---------'+childname);
            }
            namechild ='';
    }
    public void childrenamefn() 
    {
        newnode = renamechild ;
    }

  
}