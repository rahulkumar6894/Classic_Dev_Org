public class ExtjsbuildPage_ctrl {
    public String child {get;set;}
    public String strInternal ;   /*Variable showing folder structure in Left Section of Content Grid*/
    public String strGlobal ; 
    public String strShared ;
    public String st_grid11 ;
    
    public ExtjsbuildPage_ctrl()
    {
        child = '[]';
        strInternal = '';
        strGlobal ='';
        strShared ='';
        st_grid11 ='';
        //child='[{id:"0",text:"All Folders&nbsp;",relatedId:"all010000",global:false,parentId:"",name:"All Folders",expanded:true,children:[{id:"4400579034",text:"Hi Internal(Internal)",expanded:false,children:[]},{id:"4306407881",text:"test (global)",expanded:false,children:[]},{id:"4400562354",text:"Shayerd(Shared)",expanded:false,children:[]},{id:"4307229177",text:"data com",expanded:false,children:[]},{id:"4306480469",text:"DealRoom_Brahma",expanded:false,children:[]},]}]';
        string intiateJson = '[{id:"0",text:"All Folders",relatedId:"all010000",global:false,parentId:"",name:"All Folders",expanded:true,children:[';
        
        strInternal = strInternal + '{id:"1",text:"Internal",expanded:false,children:[';
        strInternal = strInternal + ']},';
      /*  for(interger i=0;i<=10;i++)
        {
            strGlobal = strGlobal + '{id:"'+i+'",text:"'+i+'",expanded:false,children:[';
            
            strGlobal = strGlobal + ']},'; 
        }*/
        
      
        
        strGlobal = strGlobal + ']},';
        
        strShared = strShared + '{id:"3",text:"strShared",expanded:false,children:[';
        strShared = strShared + ']},';
        
        st_grid11 = st_grid11 + '{id:"4",text:"Standard",expanded:false,children:[';
        st_grid11 = st_grid11 + ']},';
        
        child = intiateJson+ strInternal + strGlobal + strShared  + st_grid11 ; 
        child = child + ']}]';
    }
}