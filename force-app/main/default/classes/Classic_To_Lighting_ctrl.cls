public with sharing class Classic_To_Lighting_ctrl {

    public String Iam { get; set; }
    
   public Classic_To_Lighting_ctrl()
   {
      
      String theme = UserInfo.getUiThemeDisplayed(); 
      system.debug('#####'+theme);
      if(theme =='Theme3')
      {
          Iam ='I am Classic';
      }
      if(theme =='Theme4d')
      {
          Iam ='I am Lighting';
      }
   }
}