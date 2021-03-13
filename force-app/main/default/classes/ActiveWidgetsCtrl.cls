public with sharing class ActiveWidgetsCtrl{

    public List<string> emplist{get;set;}
    //public list<wrapPath> pathlist { get; set;}
    public ActiveWidgetsCtrl()
    {
        emplist=new List<string>();
        //pathlist = new list<wrapPath>();
        String Boxid ='12345';
        String docname = 'I am file';
        string fileName ='<a href=\'#\' onclick=\'ShowData('+Boxid+')\' id=\''+Boxid+'\'>' +docname+ '</a>';
        emplist.add('["'+fileName+'","'+fileName+'","'+fileName+'"]');
        
        System.debug('FinalList'+emplist);
    }
    /*@RemoteAction
    public static list<wrapPath> CreatePath(String FSSID) {
            list<wrapPath> pathlist = new list<wrapPath>();
            wrapPath wrapobj = new wrapPath();
            
            wrapobj.sTittle = 'sx>Z>xx>Zxx>';
            wrapobj.sPath = '...CZ>ZXCZX>ZCGBGFBHGFFB';
            wrapobj.sSize = '333';
            wrapobj.sDate = '23/33/33333';
            
            pathlist.add(wrapobj);
            System.debug('>>>'+pathlist);
        return pathlist;
    }*/
    @RemoteAction
    public static wrapPath CreatePath(String FSSID)
    {
        wrapPath wrapCalc = new wrapPath();
        wrapCalc.sTittle = 'sx>Z>xx>Zxx>';
        wrapCalc.sPath = '...CZ>ZXCZX>ZCGBGFBHGFFB';
        wrapCalc.sSize = FSSID;

        return wrapCalc;
    }
     public class wrapPath {
        public String sTittle;
        public String sPath;
        public String sSize;
        public String sDate;
    }  
}