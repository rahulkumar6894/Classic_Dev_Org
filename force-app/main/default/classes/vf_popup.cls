public with sharing class vf_popup {

      public String getTable2() {
        return null;
    }


    public String getTable1() {
        return null;
    }

    
    public boolean displayPopup {get; set;}    
   
    public void closePopup()
    {       
        displayPopup = false;   
    }    
    public void showPopup()
    {       
        displayPopup = true;   
    }   
 

}