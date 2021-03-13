public without sharing class flowpage_ctrl {

    

    public String Individual_s_Age_1 { get; set; }

    public Boolean ForgetThisIndividual { get; set; }

    public Boolean DontTrack { get; set; }

    public Boolean  dont_Profile { get; set; }

    public Boolean geological_Tracking { get; set; }

    public Boolean storePIIDataElsewhere { get; set; }

    public Boolean export_Individual_Data { get; set; }

    public Boolean  dont_Market { get; set; }

    public Boolean  dont_Process { get; set; }

    public Date Birthdate { get; set; }
    
    public string ContactId ;
    public String IndividualID ;
    public Boolean checkval {get;set;}
    public string FirstName {get;set;}
    public Individual ind {get;set;}
    
    public flowpage_ctrl(ApexPages.StandardController controller) {    
              
        ContactId = '0037F00000a2fRO';
        List<Contact> conlist = [Select Id,Name,IndividualID from Contact WHERE Id= :ContactId];
        System.debug('conlist'+conlist);
        if ( conlist.size() > 0 )
        {        
            for(Contact con : conlist )
            {
                IndividualID  = con.IndividualID ;
            }        
        }
        System.debug('IndividualID'+IndividualID);
        if(String.isNotEmpty(IndividualID))
        {   
            checkval = false;
           
            ind = [Select Id,BirthDate,IndividualsAge,ShouldForget,HasOptedOutGeoTracking,HasOptedOutTracking,HasOptedOutProfiling,CanStorePiiElsewhere,SendIndividualData,HasOptedOutProcessing,HasOptedOutSolicit from Individual Where ID = :IndividualID];
            Birthdate  = ind.BirthDate;
            Individual_s_Age_1  =ind.IndividualsAge;
            dont_Market  = ind.HasOptedOutSolicit;
            ForgetThisIndividual = ind.ShouldForget;
            geological_Tracking  = ind .HasOptedOutGeoTracking; 
            DontTrack  = ind.HasOptedOutTracking; 
            dont_Profile = ind.HasOptedOutProfiling;
            storePIIDataElsewhere = ind.CanStorePiiElsewhere;
            export_Individual_Data = ind.SendIndividualData;
            dont_Process = ind.HasOptedOutProcessing;
        }
        else
        {  
            checkval = true;
            System.debug('checkval'+checkval);  
        }
        
       }
   
   public void updaterecord()
   {
        ind.BirthDate = Birthdate;
        ind.IndividualsAge = Individual_s_Age_1;
        ind.HasOptedOutSolicit = dont_Market;
        ind.ShouldForget = ForgetThisIndividual;
        ind .HasOptedOutGeoTracking = geological_Tracking; 
        ind.HasOptedOutTracking = DontTrack; 
        ind.HasOptedOutProfiling = dont_Profile;
        ind.CanStorePiiElsewhere = storePIIDataElsewhere;
        ind.SendIndividualData = export_Individual_Data;
        ind.HasOptedOutProcessing = dont_Process;
            
        update ind;
   }
}