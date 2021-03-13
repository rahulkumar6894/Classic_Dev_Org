public with sharing class folderTemplate{

public class RootObject 
    {
        public string z_id { get; set; }
        public string y_text { get; set; }
        public string x_relatedId { get; set; }
        public boolean w_internal { get; set; }
        public boolean v_isGlobal { get; set; }
        public boolean u_shared { get; set; }
        public string t_parentId { get; set; }
        public string s_name { get; set; }
        public boolean r_expanded { get; set; }
        public List<RootObject> q_children { get; set; }
        //public string p_index { get; set; }
        
       
    }
   Set<string> setofIds = new Set<string>();
      public void myfunction()
     {
        List<Account> results = [SELECT Id,Description FROM Account where id ='0017F00000N2HnT'];
        string jsonToUpdate = results[0].Description;
        system.debug('my ft>>>'+jsonToUpdate);
        string FolderId = '475223106' ;
        List<RootObject > folderObj1 = new List<RootObject >();
        //List<string> setofIds = new List<string>();
         setofIds.Add(FolderId);
        String jsonStr;
        jsonStr = jsonToUpdate;
            
           jsonStr = jsonStr.replace('text:', '"y_text":').replace('parentId:', '"t_parentId":').replace('id:', '"z_id":').replace('name:', '"s_name":').replace('expanded:', '"r_expanded":').replace('children:', '"q_children":').replace('global:', '"v_isGlobal":').replace('shared:', '"u_shared":').replace('internal:', '"w_internal":').replace('relatedId:', '"x_relatedId":').replace('leaf:', '"p_index":');
            
            //jsonStr = jsonStr.replace('"text":', '"y_text":').replace('"parentId":', '"t_parentId":').replace('"id":', '"z_id":').replace('"name":', '"s_name":').replace('"expanded":', '"r_expanded":').replace('"children":', '"q_children":').replace('"global":', '"v_isGlobal":').replace('"shared":', '"u_shared":').replace('"internal":', '"w_internal":').replace('"relatedId":', '"x_relatedId":').replace('"leaf:"', '"p_index":');
            
            system.debug('jsonStr before serialization'+jsonStr);

            //Deserialize json into wrapper class
            JSONParser parser = JSON.createParser(jsonStr);
            folderObj1 = (List<RootObject>)parser.readValueAs(List<RootObject>.class);
            system.debug('jsonStr folderObj1'+folderObj1);
            List<RootObject> currChild = new List<RootObject>();
            currChild = folderObj1[0].q_children;
            String currIds = folderObj1[0].z_id;
            List<RootObject > nextChild = new List<RootObject >();
            folderIdsfunction(currChild,FolderId);
    }
     
      public void folderIdsfunction(List<RootObject> subChild,String FolderId)
      {
            //System.debug('IDs>>>>'+IDs);
           for (RootObject myobj : subChild)
           {
                System.debug('t_parentId!!!!!!!!!!!!'+myobj.t_parentId);
                System.debug('>>'+FolderId);
                System.debug('z_id!!!!!!!!!!!!'+myobj.z_id);
                
                if(myobj.t_parentId == FolderId && setofIds.contains(FolderId))
                {
                    setofIds.Add(myobj.z_id);
                    
                }
                if(myobj.q_children != null && myobj.q_children.size()>0)
                    {
                        folderIdsfunction(myobj.q_children,myobj.z_id);
                    }
                
                        
           } 
              System.debug('>>>setofIds>'+setofIds);    
      }
      
}