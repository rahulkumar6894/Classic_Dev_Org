public with sharing class jsActivewigetsGrid_ctrl {
 
     public List<string> emplist {get;set;}
    
     public jsActivewigetsGrid_ctrl()
     {
          emplist=new List<string>();
          
     }
     public void getrecord()
     {
      // emplist.add('Rahul');
       for(Employee2__c emp : [Select Id,Name,Client__c,Department__c from Employee2__c])
       {
          emplist.add('["<input type=\'checkbox\' onclick=\'showData()\'/>","<a value=\''+emp.Id+'\' title=\''+emp.Id+'\' onclick=\'ShowData('+emp.Id+')\'>Show</a>","<span title=\''+emp.name+'\'>'+emp.Name+'</span>","<label  value=\''+emp.Name+'\'>'+emp.Name+'</label>"]');
          //emplist.add('["<a>Remove</a>", "<a>'+emp.Name+'</a>","<a>'+emp.Client__c+'</a>"]'); 
          
       }
          /*String Boxid ='12345';
           String docname = 'I am file';
           //string fevlink ='<img  onclick=\'viewFile_grid1('+Boxid +');\' id=\''+docname+'\'/>';
           //string fevlink = '<img onclick=\'viewFile_grid1('+Boxid +');\' src="" ></img>';
           //string fevlink ='<a href=\'#\' onclick=\'viewFile_grid1('+Boxid +');\' title=\''+docname+'\'>' +docname+ '</a>';
        string fevlink=  '<img src="https://rahulkasaundhan-dev-ed--c.ap5.visual.force.com/resource/1525286379000/Refresh_Icon" />';
          string fileName ='<a href=\'#\' onclick=\'viewFile_grid1('+Boxid +');\' title=\''+docname+'\'>' +docname+ '</a>';
          String dealname = '<img src="url({!URLFOR($Resource.resourceName,\''+docname+'\')})" />';
          emplist.add('["'+fevlink+'","'+fileName+'","'+dealname+'"]');*/
          
       System.debug('FinalList'+emplist);
     }
}