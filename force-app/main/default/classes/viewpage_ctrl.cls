public with sharing class viewpage_ctrl {

    public viewpage_ctrl(ApexPages.StandardController controller) {

    }

  
   public String pagename  {get;set;}

   public String btn1 {get;set;}

    public viewpage_ctrl()
    {
          pagename = 'Viewpage';
    }
    public PageReference cmdbtn()
    {
         btn1  ='ButtonPress';
         return null;
        
    }
     public PageReference cmdlink()
    {
      //   btn1  ='ButtonPress2';
         return page.exportPage;
        
    }
     
    
}