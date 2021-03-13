/*********************************************************************************
** Module Name : preqinRE_Controller 
** Description : preqinRE_Controller 
** Revision History:-
** Version   Date        Author        WO#   Description of Action
** 1.2      29/06/2018  Kumar Jonson        To implement Preqin RE app user functionality to make hit and show the data based on Preqin Id. It will also search the entered name on the preqin server by making a REST request.

*********************************************************************************/

public class preqinRE_Controller {
    public static string key = 'GYeDg2K0GbuOu4BHxhkgf9dGAsDJRt8f';
    public static string secret = 'ZroduAHZaVnO7ZXQ';
    public static boolean flag=false;
    public static boolean stoprec {get;set;}
    public static string access_token ;
    public static string refresh_token; 
    public static string dynamic_url ='re';
    
    
    //Constructor
    public preqinRE_Controller(){
        flag = false;
        stoprec = false;
        //dynamic_url='re';
        
    }//constructor close
    
    
    //Query on Navatar Setup object to query the access_token and refresh_token. 
    @Auraenabled
    public static WrapperSetupRecord getNavSetupRec(){
        WrapperSetupRecord wr = new WrapperSetupRecord();
        try{
            flag=false;
            String userId = UserInfo.getUserId();
            String refreshTokenfield;
            String accessTokenfield;
            Cls_SchemaObjectClass.SchemaWrapper schemawrap = new Cls_SchemaObjectClass.SchemaWrapper();
            String navSchema;
            
            //Calling the class 'Cls_SchemaObjectClass' method.
            schemawrap = Cls_SchemaObjectClass.getSchemaNameSapce();
            system.debug('schemawrap>>>'+schemawrap);
            if(schemawrap.navSetupobj <> null && schemawrap.wraprefreshToken <> null && schemawrap.wrapaccessToken <> null){
                navSchema = String.valueof(schemawrap.navSetupobj);
                refreshTokenfield = schemawrap.wraprefreshToken;
                accessTokenfield = schemawrap.wrapaccessToken;
            }
            String query ='select id,'+refreshTokenfield+','+accessTokenfield+' from '+navSchema+' where ownerid=: userId order by createddate desc limit 1';
            List<sObject> objlist = new List<sObject>(); 
            objlist = Database.query(query);
            If(objlist <> null && objlist.size() > 0){
                
                If(String.valueof(objlist[0].get(accessTokenfield)) <> null && String.valueof(objlist[0].get(refreshTokenfield)) <> null){
                    wr.setUpRecordid = (String)objlist[0].id;
                    wr.accessToken = (String)objlist[0].get(accessTokenfield);
                    wr.refreshToken = (String)objlist[0].get(refreshTokenfield);
                    wr.setUpStatus ='Ok';
                    wr.exceptionStr ='';
                }else{
                    wr.setUpStatus ='Fail';
                    wr.exceptionStr ='';
                }
            }//If close
            else{
                wr.setUpStatus ='Fail';
                wr.exceptionStr ='';
            }
            
        }catch(exception e){
            wr.exceptionStr =e.getMessage();
        }
        system.debug('>>>tokenMap>>>>'+wr);
        return wr;
    }//method close getNavSetupRec
    
    //Getting Account Information, Purpose: It will return the Account Preqin Id and account name which will use hit the data on search
    @Auraenabled
    public static String getAccountdetails(String accId){
        Map<string,string> accMap = new Map<string,string>();
        string acccountPreqinfield ='';
        boolean idflag = false;  
        boolean accPreqinflag = false;
        boolean accNameFlag = false;
        try{
            //Calling the abstract class 'Cls_SchemaObjectClass' method.
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType accSchema = schemaMap.get('Account');
            Map<String, Schema.SObjectField> fieldMap = accSchema.getDescribe().fields.getMap();
            for (String fieldName: fieldMap.keySet()){ 
                //It provides to get the object fields label.
                String fieldApi = fieldMap.get(fieldName).getDescribe().getName();
                If(fieldApi.contains('Preqin_RE_Account_ID__c')){
                    acccountPreqinfield = fieldApi;
                    break;
                }
            }//for close
                    
            idflag = Cls_SchemaObjectClass.isAccessible('Account','id');
            accPreqinflag = Cls_SchemaObjectClass.isAccessible('Account',acccountPreqinfield);
            accNameFlag = Cls_SchemaObjectClass.isAccessible('Account','name');
            
            If(accId <> null || accId <> ''){
                if(idflag == true && accPreqinflag == true && accNameFlag == true){ 
                    String query ='select id, name, '+acccountPreqinfield+' from Account where id= \''+accId+'\'';
                    List<sObject> accList = new List<sObject>(); 
                    accList = Database.query(query);
                    If(accList <> null && accList.size() > 0){
                        accMap.put('preqinid',String.valueof(accList[0].get(acccountPreqinfield)));
                        accMap.put('accname',String.valueof(accList[0].get('name')));
                        accMap.put('Exception',null);
                    }
                }
            }//If close
        }catch(exception e){
            accMap.put('Exception',e.getMessage());
        }
        String serv = JSON.serialize(accMap);
        system.debug('>>>serv>>'+serv);
        return serv;
    }//method close getAccountdetails
    
    
    
    
    //Hit preqin based on account name or searched text and deserialize the data in the WrapperFirmName
    @Auraenabled
    public static WrapperFirmName getDatafromPreqin_accName(string accname,string setUprecId){
        WrapperFirmName wf = new WrapperFirmName();
        List<firmNameWrapper> firmwrapper = new List<firmNameWrapper>();
        try{
            //String access_token,refresh_token;
            if(stoprec == null || stoprec == false){
                stoprec = false;
            }
            if(flag == false){
                WrapperSetupRecord tokenwrapper = getNavSetupRec(); 
                if( tokenwrapper <> null && tokenwrapper.setUpStatus == 'Ok'){
                    if( tokenwrapper.accessToken <> null && tokenwrapper.accessToken <> '' ){
                        access_token =  tokenwrapper.accessToken;
                    }
                    if( tokenwrapper.refreshToken <> null && tokenwrapper.refreshToken <> ''){ 
                        refresh_token = tokenwrapper.refreshToken;
                    }
                }
            }
            If(String.isNotBlank(access_token)){
                
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                String accEncodeName = EncodingUtil.urlEncode(accname, 'UTF-8');
                String endpointURl =''; 
                req.setEndpoint(endpointURl);   
                
                req.setHeader('Content-Type','application/x-www-form-urlencoded');
                req.setHeader('Authorization', 'Bearer '+access_token);
                req.setTimeout(60*1000);
                Http h = new Http();
                String respBody;
                HttpResponse res = h.send(req);
                system.debug('>>>>respBody>>'+res.getBody());
                If(res.getStatusCode() == 200 && res.getStatus() == 'OK' && res.getBody() != ''){
                    //Token not expired
                    respBody = res.getBody();
                    wf.totalPageCount = res.getHeader('X-Pagination-Page-Count');
                    firmwrapper = (List<firmNameWrapper>) System.JSON.deserialize(respBody, List<firmNameWrapper>.class);
                    wf.firmNameWrapper = firmwrapper;
                    wf.strFirmStatus ='';
                    wf.strexception ='';
				}else If(res.getStatusCode() == 401 ){
                    //Token get Expied
                    if(stoprec == false){
                        
                        WrapperNewRefreshToken newAccesstoken = getNewAccessToken(access_token,refresh_token);   
                        if(newAccesstoken.statusStr <> 'Fail'){
                            If(String.isNotBlank(newAccesstoken.accessToken) && String.isNotBlank(newAccesstoken.refreshToken)){
                                access_token = newAccesstoken.accessToken;
                                refresh_token = newAccesstoken.refreshToken;
                                wf = getDatafromPreqin_accName(accname,setUprecId);
                            }
                            
                        }else if(newAccesstoken.statusStr == 'Fail'){
                            wf.strFirmStatus = 'Refresh token expire';
                            wf.strexception ='';
                        }else{
                            wf.strexception =newAccesstoken.excepStr;
                        }
                    }
                }else If(res.getStatusCode() == 500 ){
                    wf.strFirmStatus = '';
                    wf.strexception ='An error has occurred. Please try again. <br/>' +res.getBody();
                }
                else{
                    wf.strFirmStatus = '';
                    wf.strexception = 'Status Code:'+String.valueOf(res.getStatusCode())+' '+ res.getBody();
                }
                if(flag == true){
                    String strResult = updateToken(access_token,refresh_token,setUprecId);        //call Method to update the new Access token and refresh token
                    if(String.isNotBlank(strResult)){
                        wf.strexception = strResult;
                    }
				}
            }//If close
        }catch(exception ex){
            system.debug('_____'+ex.getMessage()+'____linenumber___'+ex.getLineNumber()+'exception type--'+ex.getTypeName());
            wf.strexception = ex.getMessage();
		}
		system.debug('wf>>>>'+wf);
        return wf;
    }//method close getDatafromPreqin_accName
    
    //Hit on Preqin to get data based on firmId 
    @Auraenabled
    public static WrapperDetailclass getDatafromPreqin_preqinId(string accPreqId,string setUprecId){
        WrapperDetailclass wc = new WrapperDetailclass();
        try{
            
                WrapperSetupRecord tokenwrapper = getNavSetupRec(); 
                if( tokenwrapper <> null && tokenwrapper.setUpStatus == 'Ok'){
                    if( String.isNotBlank(tokenwrapper.accessToken) && String.isNotBlank(tokenwrapper.accessToken)){
                        access_token =  tokenwrapper.accessToken;
                    }
                    if( String.isNotBlank(tokenwrapper.refreshToken) && String.isNotBlank(tokenwrapper.refreshToken)){ 
                        refresh_token = tokenwrapper.refreshToken;
                    }
				}
            If(String.isNotBlank(access_token)){
                 
                    //JSON.serialize(access_token);
                   
                    wc = (WrapperDetailclass) System.JSON.deserialize(access_token, WrapperDetailclass.class);
                    wc.strStatus = '';
                    wc.strexcep ='';
                    if(wc <> null ){
                        
                        //To show the Allocations table
                        if(wc.investmentAllocations <> null && wc.investmentAllocations.size() > 0){
                            List<AllocationWrapper> allcWraplist = new List<AllocationWrapper>();
                            Map<string,cls_investmentAllocations> invallCurrentMap = new Map<string,cls_investmentAllocations>();
                            Map<string,cls_investmentAllocations> invallTargetMap = new Map<string,cls_investmentAllocations>();
							Map<string,cls_investmentAllocations> onlyTargetMap = new Map<string,cls_investmentAllocations>();
                            Map<string,cls_investmentAllocations> newCurrentMap = new Map<string,cls_investmentAllocations>();

                            
                            for(cls_investmentAllocations invallc : wc.investmentAllocations){
                                if(invallc.allocationType <> null ){
                                    if(invallc.allocationType <> 'Current Allocation' && invallc.allocationType <> 'Target Allocation'){
                                        if(invallc.allocationType.contains('Current')){
                                            invallCurrentMap.put(invallc.allocationType,invallc);
                                        }
                                        if(invallc.allocationType.contains('Target')){
                                            invallTargetMap.put(invallc.allocationType,invallc);
                                        }
                                    }   
                                }//if close
                            }//for 
                            //If only Current OR Current and Target allocation is available
                            for(cls_investmentAllocations invallc : wc.investmentAllocations){
                                AllocationWrapper wrapalloc = new AllocationWrapper();
                                String alltype = invallc.allocationType;
                                if(invallCurrentMap <> null && invallCurrentMap.size() > 0){
                                    if(invallCurrentMap.containskey(alltype)){
                                        if(invallCurrentMap.get(alltype).allocationType <> null && invallCurrentMap.get(alltype).allocationType <> ''){
                                            String alctype = invallCurrentMap.get(alltype).allocationType; 
                                            system.debug('alctype Current>>=='+alctype);
                                            if(alctype.contains('Target'))
                                                alctype = alctype.replace('Target','');
                                            if(alctype.contains('Current'))
                                                alctype = alctype.replace('Current','');
                                            if(alctype.contains('Allocation'))
                                                alctype = alctype.replace('Allocation','');
                                            alctype = alctype.trim();
                                            
                                            if(alctype.startswith('UnListed')){
                                            alctype = alctype +' Infrastructures Funds!!!!!!!!!!';
                                            }
												else if(alctype.startswith('Listed')){
													alctype = alctype +' Infrastructures Funds';
												}
                                            
                                            else if(alctype.contains('Direct')){
                                                alctype = alctype +' Investments';
                                            }
                                            else{
                                                alctype = alctype +' Infrastructures Funds';
                                            }
                                            wrapalloc.type = alctype;
                                        }
                                        if(invallCurrentMap.get(alltype).allocationType == null || invallCurrentMap.get(alltype).allocationType == ''){
                                            wrapalloc.type = '';
                                        }
                                        
                                        wrapalloc.status = invallCurrentMap.get(alltype).status;
                                        if(invallCurrentMap.get(alltype).status == null || invallCurrentMap.get(alltype).status == ''){
                                            wrapalloc.status = '';
                                        }
                                        
                                        wrapalloc.current_value = String.valueof(invallCurrentMap.get(alltype).value);
                                        if(String.valueof(invallCurrentMap.get(alltype).value) == null || String.valueof(invallCurrentMap.get(alltype).value) == ''){
                                            wrapalloc.current_value  = '';
                                        }
                                        
                                        wrapalloc.current_perc = String.valueof(invallCurrentMap.get(alltype).percent);
                                        if(String.valueof(invallCurrentMap.get(alltype).percent) == null || String.valueof(invallCurrentMap.get(alltype).percent) == ''){
                                            wrapalloc.current_perc  = '';
                                        }
                                        if(alltype.contains('Current'))
                                            alltype = alltype.replace('Current','Target');
                                            system.debug('alltype Target>>=='+alltype);
											
                                        System.debug('invallTargetMap%%%%%'+invallTargetMap);
                                        //Checking the Target data corresponds to Current data
                                        if(invallTargetMap <> null && invallTargetMap.size() > 0){
                                            if(invallTargetMap.containskey(alltype)){
                                                
                                                wrapalloc.target_value = String.valueof(invallTargetMap.get(alltype).value);
                                                if(String.valueof(invallTargetMap.get(alltype).value) == null || String.valueof(invallTargetMap.get(alltype).value) == ''){
                                                    wrapalloc.target_value ='';
                                                }
                                                
                                                wrapalloc.target_perc = String.valueof(invallTargetMap.get(alltype).percent);
                                                if(String.valueof(invallTargetMap.get(alltype).percent) == null || String.valueof(invallTargetMap.get(alltype).percent) == ''){
                                                    wrapalloc.target_perc ='';
                                                }
												invallTargetMap.remove(alltype);
                                            }
										}  
                                    }
                                }
                                //If there is no Current allocation, only Target allocation are available.
                                if(invallTargetMap.size() >0){
                                    String alltype2 = invallc.allocationType;
                                    if(invallTargetMap.containskey(alltype2)){
                                    if(invallTargetMap.get(alltype2).allocationType <> null && invallTargetMap.get(alltype2).allocationType <> ''){
                                        String alctype = invallTargetMap.get(alltype2).allocationType; 
                                        if(alctype.contains('Target'))
                                            alctype = alctype.replace('Target','');
                                        if(alctype.contains('Allocation'))
                                            alctype = alctype.replace('Allocation','');
                                        alctype = alctype.trim();
                                        
                                        if(alctype.startswith('UnListed')){
                                            alctype = alctype +' Infrastructures Funds!!!!!!!!!!';
                                        }
                                        else if(alctype.startswith('Listed')){
                                            alctype = alctype +' Infrastructures Funds';
                                        }
                                        else if(alctype.contains('Direct')){
                                            alctype = alctype +' Investment';
                                        }
                                        else{
                                            alctype = alctype +' Infrastructures Funds';
                                        }
                                        wrapalloc.type = alctype;
                                    }
                                    
                                    if(invallTargetMap.get(alltype2).allocationType == null || invallTargetMap.get(alltype2).allocationType == '')
                                        wrapalloc.type = '';
                                    
                                    wrapalloc.status = invallTargetMap.get(alltype2).status;
                                    if(invallTargetMap.get(alltype2).status == null || invallTargetMap.get(alltype2).status == '')
                                        wrapalloc.status ='';
                                    
                                    wrapalloc.current_value = '';
                                    
                                    wrapalloc.current_perc ='';
                                    
                                    wrapalloc.target_value = String.valueof(invallTargetMap.get(alltype2).value);
                                    if(String.valueof(invallTargetMap.get(alltype2).value) == null || String.valueof(invallTargetMap.get(alltype2).value) == '')
                                        wrapalloc.target_value ='';
                                    
                                    
                                    wrapalloc.target_perc = String.valueof(invallTargetMap.get(alltype2).percent);
                                    if(String.valueof(invallTargetMap.get(alltype2).percent) == null || String.valueof(invallTargetMap.get(alltype2).percent) == '')
                                        wrapalloc.target_perc = '';
                                }
                            }
							
                                if(wrapalloc.type == null && wrapalloc.status == null && wrapalloc.current_value == null && wrapalloc.current_perc == null && wrapalloc.target_value == null && wrapalloc.target_perc == null){
                                    
                                }else{
                                   if(wrapalloc.type <> null){
                                        allcWraplist.add(wrapalloc);
                                    }
                                    
                                }
                            }
							
                            /*List<AllocationWrapper> templist = new List<AllocationWrapper>();
                            templist = allcWraplist;
							System.debug('%%%%%%%'+templist);
                            allcWraplist = new List<AllocationWrapper>();
                            if(templist <> null && templist.size() > 0){
                                for(Integer i = templist.size()-1; i >= 0; i--){
                                    allcWraplist.add(templist[i]);
                                }
                            }*/
                            wc.allocationWrapperList = allcWraplist;
                           System.debug('##########'+wc.allocationWrapperList); 
                        }//show the Allocations table close
                        
                        //apppend target blank in background section
                        if(wc.background <> null){
                            if(wc.background <> null && wc.background <> ''){
                                wc.background = wc.background.replace('<a ', '<a target="_blank" ');
                            }
                            
                            //To replace \n\r from the background to show in lightning:formattedRichText field.
                            if(wc.background <> null && wc.background <> ''){
                                if(wc.background.contains('\n')){
                                    String comments = wc.background;
                                    comments =comments.replaceAll('\n','<br/>');
                                    wc.background = comments;
                                }
                                
                                if(wc.background.contains('\r')){
                                    String comments = wc.background;
                                    comments =comments.replaceAll('\r','');
                                    wc.background = comments;
                                }
                            }
                        }
                        
                        //To show the Investment allocation in sequence order as Primary, Direct, Secondary
                        if(wc.investmentAllocationsPE <> null && wc.investmentAllocationsPE.size() > 0){
                            
                            Map<String,cls_investmentAllocationsPE> invAllMap = new Map<String,cls_investmentAllocationsPE>();
                            invAllMap.put('Current Primary Allocation',null);
                            invAllMap.put('Current Direct Allocation',null);
                            invAllMap.put('Current Secondary Allocation',null);
                            List<cls_investmentAllocationsPE> InvAllList = new List<cls_investmentAllocationsPE>();
                            for(cls_investmentAllocationsPE allc : wc.investmentAllocationsPE){
                                if(allc.allocationType != 'Current Allocation' && allc.allocationType != 'Target Allocation'){
                                    if(invAllMap.containskey(allc.allocationType)){
                                        invAllMap.put(allc.allocationType,allc);
                                    }
                                }
                            }//for close
                            if(invAllMap <> null && invAllMap.values().size()>0){
                                for(cls_investmentAllocationsPE inv : invAllMap.values()){
                                    if(inv <> null ){
                                        InvAllList.add(inv);
                                    }
                                }
                                if(InvAllList <> null && InvAllList.size() >0){
                                    wc.primaryDirectSecondaryInvAllocList = InvAllList;
                                }
                            }//if close
                        }
                         System.debug('gggggggQQQQQQ@@@@@@'+ wc.investorPreferences.projectStages);
						 System.debug('gggggggQQQQQQ@@@@@@'+ wc.investmentConsultantsRE);
                        //To hold the Non-PE investment consultant
                        if(wc.investmentConsultants <> null && wc.investmentConsultants.size() > 0){
                            if(wc.investmentConsultantsINF <> null && wc.investmentConsultantsINF.size() > 0){
                                Set<string> peInvSet = new Set<string>();
                                List<cls_investmentConsultantsINF> peInvList = new List<cls_investmentConsultantsINF>();
                                peInvList = wc.investmentConsultantsINF;
                                for(cls_investmentConsultantsINF inv : peInvList){
                                    peInvSet.add(inv.name);
                                }
								System.debug('######peInvSet'+peInvSet);
                                if(peInvSet <> null && peInvSet.size() > 0 ){
                                    List<cls_investmentConsultants> nonPeInvList = new List<cls_investmentConsultants>();
                                    nonPeInvList = wc.investmentConsultants;
						         	System.debug('######nonPeInvList'+nonPeInvList);
                                    List<string> nonpeList = new List<string>();
                                    for(cls_investmentConsultants cinv : nonPeInvList){
									        System.debug('PPPPPPPP'+cinv.name);
                                        if(!peInvSet.contains(cinv.name)){
                                            nonpeList.add(cinv.name);
											
                                        }
                                    }
									System.debug('$$$$$$'+nonpeList);
                                    wc.nonPEInvConsltList = nonpeList;
                                }
                            }else{
                                List<cls_investmentConsultants> nonPeInvList = new List<cls_investmentConsultants>();
                                nonPeInvList = wc.investmentConsultants;
                                List<string> nonpeList = new List<string>();
                                for(cls_investmentConsultants cinv : nonPeInvList){
                                    
                                    nonpeList.add(cinv.name);
                                }
								System.debug('^^^^^^^'+nonpeList);
                                wc.nonPEInvConsltList = nonpeList;
                            }
                        }//if close 
                        
                        
                        //making a List of country to display in Other Country section
                        if(wc.addresses <> null && wc.addresses.size() >0){
                            List<cls_addresses> otherAdd = new List<cls_addresses>();
                            otherAdd = wc.addresses;
                            if(otherAdd <> null && otherAdd.size() >0){
                                Set<String> otheraddSet = new Set<String>();
                                for(cls_addresses othrAddress: otherAdd){
                                    if(othrAddress.isMain == 'false'){
                                        otheraddSet.add(othrAddress.country);
                                    }
                                }
                                List<String> otheraddList = new List<String>();
                                otheraddList.addAll(otheraddSet);
                                otheraddList.sort();
                                wc.otherCountryList = otheraddList;
                            }
                        }
                        
                        
                        //To calculate the Quarter based on next12MonthsQuarter field.
                        if(wc.futureInvestmentPlan <> null ){
                            if(wc.futureInvestmentPlan.next12MonthsQuarter <> null && wc.futureInvestmentPlan.next12MonthsQuarter <> ''){
                                String quarterDate = String.valueOf(wc.futureInvestmentPlan.next12MonthsQuarter);
                                DateTime date1 = (DateTime)Json.deserialize('"'+quarterDate+'"', DateTime.class);
                                Integer qMonth = date1.month();
                                Integer qYear = date1.year();
                                If(qMonth >=1 && qMonth <= 3){
                                    String dateOfPlans = 'Q1 '+qyear;
                                    wc.futureInvestmentPlan.next12MonthsQuarter = dateOfPlans;
                                }else If(qMonth >=4 && qMonth <= 6){
                                    String dateOfPlans = 'Q2 '+qyear;
                                    wc.futureInvestmentPlan.next12MonthsQuarter = dateOfPlans;
                                }else If(qMonth >=7 && qMonth <= 9){
                                    String dateOfPlans = 'Q3 '+qyear;
                                    wc.futureInvestmentPlan.next12MonthsQuarter = dateOfPlans;
                                }else If(qMonth >=10 && qMonth <= 12){
                                    String dateOfPlans = 'Q4 '+qyear;
                                    wc.futureInvestmentPlan.next12MonthsQuarter = dateOfPlans;
                                }
                            }//If close
                            
                            //To replace \n\r from the summaryOfNextYear to show in lightning:formattedRichText field.
                            if(wc.futureInvestmentPlan.summaryOfNextYear <> null && wc.futureInvestmentPlan.summaryOfNextYear <> ''){
                                if(wc.futureInvestmentPlan.summaryOfNextYear.contains('\n')){
                                    String comments = wc.futureInvestmentPlan.summaryOfNextYear;
                                    comments =comments.replaceAll('\n','<br/>');
                                    wc.futureInvestmentPlan.summaryOfNextYear = comments;
                                }
                                
                                if(wc.futureInvestmentPlan.summaryOfNextYear.contains('\r')){
                                    String comments = wc.futureInvestmentPlan.summaryOfNextYear;
                                    comments =comments.replaceAll('\r','');
                                    wc.futureInvestmentPlan.summaryOfNextYear = comments;
                                }
                                wc.futureInvestmentPlan.summaryOfNextYear = wc.futureInvestmentPlan.summaryOfNextYear.replace('<a ', '<a target="_blank" ');
                            }
                        }//If close
                        
                        //apppend target blank in comment section of initial contact
                        if(wc.initialContact <> null){
                            if(wc.initialContact.comments <> null && wc.initialContact.comments <> ''){
                                wc.initialContact.comments = wc.initialContact.comments.replace('<a ', '<a target="_blank" ');
                            }
                            //To replace \n\r from the comments to show in lightning:formattedRichText field.
                            if(wc.initialContact.comments <> null && wc.initialContact.comments <> ''){
                                if(wc.initialContact.comments.contains('\n')){
                                    String comments = wc.initialContact.comments;
                                    comments =comments.replaceAll('\n','<br/>');
                                    wc.initialContact.comments = comments;
                                }
                                
                                if(wc.initialContact.comments.contains('\r')){
                                    String comments = wc.initialContact.comments;
                                    comments =comments.replaceAll('\r','');
                                    wc.initialContact.comments = comments;
                                }
                            }
                        }
                        
                        
                        //check primary contact and whether initialcontact has name or email
                        if((wc.initialContact <> null) &&  (wc.initialContact.email <> null || wc.initialContact.firstName <> null || wc.initialContact.surName <> null || wc.initialContact.jobTitle <> null || wc.initialContact.tel <> null || wc.initialContact.linkedIn <> null || wc.initialContact.address <> null)){
                            //If primary contact is available
                            if(wc.contacts <> null && wc.contacts.size() > 0){
                                List<cls_contacts> conwraplist = new List<cls_contacts>();
                                conwraplist.addall( wc.contacts);
                                wc.contacts.clear();
                                cls_contacts primaryContact = new cls_contacts();
                                
                                primaryContact.email =wc.initialContact.email;
                                primaryContact.firstName =wc.initialContact.firstName;
                                primaryContact.surName =wc.initialContact.surName;
                                primaryContact.jobTitle =wc.initialContact.jobTitle;
                                primaryContact.tel =wc.initialContact.tel;
                                primaryContact.linkedIn =wc.initialContact.linkedIn;
                                
                                primaryContact.address = wc.initialContact.address;
                                
                                primaryContact.isPrimary = 'true';
                                List<cls_contacts> templist = new List<cls_contacts>();
                                templist.add(primaryContact);
                                if(conwraplist <> null && conwraplist.size() > 0){
                                    for(cls_contacts con : conwraplist){
                                        con.isPrimary= 'false';
                                        if((con.email <> primaryContact.email) || (primaryContact.email == null || primaryContact.email == '')){
                                            
                                            cls_address conAdd = new cls_address();
                                            conAdd = con.address;
                                            templist.add(con);
                                        }
                                    }
                                }
                                wc.contacts.addAll(templist);
                            }
                        }else{
                            //If there is no primary contact, only Contacts is available
                            if(wc.contacts <> null && wc.contacts.size() > 0){
                                for(cls_contacts con  : wc.contacts){
                                    con.isPrimary = 'false';
                                    if(con.linkedIn <> null && con.linkedIn <> ''){
                                        if(!con.linkedIn.contains('https://')){
                                            String furl = 'https://'+con.linkedIn;
                                            con.linkedIn = furl;
                                        }
                                    }
                                    
                                }
                            }
                        }//else close
                    }//if close wc
                    
                    
               
			}
        }catch(exception ex){
            system.debug('_____'+ex.getMessage()+'____linenumber___'+ex.getLineNumber()+'-----exception type--'+ex.getTypeName());
            wc.strexcep = ex.getMessage();
        }
        system.debug('wc>>>'+wc);
        return wc;
    }//method close getDatafromPreqin_preqinId
    
    
    
    //To hit preqin to get new access token
    @Auraenabled
    public Static WrapperNewRefreshToken getNewAccessToken(String accesstoken,string refreshtoken)
    {
        WrapperNewRefreshToken wn = new WrapperNewRefreshToken();
        try{
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint('https://data.preqin.com/oauth2/connect/token');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            system.debug('key=='+key+'secret== '+secret);
            String messageBody= 'grant_type=refresh_token&refresh_token='+refreshtoken+'&client_id='+key+'&client_secret='+secret;
            req.setHeader('Content-length', String.valueOf(messageBody.length()));
            req.setBody(messageBody);
            req.setTimeout(60*1000);
            Http h = new Http();
            HttpResponse res = h.send(req);
            If(res.getStatusCode() == 200 && res.getStatus() == 'OK' && res.getBody() != ''){
                String respBody = res.getBody();
                system.debug('res===>>'+res.getBody());
                accesstoken ='';
                refreshtoken ='';
                map<string,object> mapTokens = (map<string,object>)JSON.deserializeUntyped(respBody);
                accesstoken = (String)mapTokens.get('access_token');
                refreshtoken = (String)mapTokens.get('refresh_token');
                flag = true;
                stoprec = true;
                wn.accessToken = accesstoken;
                wn.refreshToken = refreshtoken;
                wn.statusStr = 'Ok';
            }else If(res.getStatusCode() == 500 ){
                wn.statusStr = '';
                wn.excepStr ='An error has occurred. Please try again. <br/>' +res.getBody()+'<br/>Status : '+String.valueOf(res.getStatus());
            }
            else{
                stoprec = true;
                wn.excepStr = '';
                wn.statusStr = 'Fail';
            }
            
        }catch(exception ex){
            wn.excepStr = ex.getMessage();
            system.debug('_____'+ex.getMessage()+'____linenumber___'+ex.getLineNumber()+'-----exception type--'+ex.getTypeName());
        }
        return wn;
    }// method close getNewAccessToken
    
    
    //Method to update new access token and refresh token
    @Auraenabled
    public static String updateToken(String access_token,string refresh_token,string setUprecId){
        string returnMsg ='';
        string accessTokenfield ='';
        string refreshTokenfield ='';
        boolean idflag = false;  
        boolean reftokenflag = false;
        boolean accesstokenflag = false;
        Cls_SchemaObjectClass.SchemaWrapper schemawrap = new Cls_SchemaObjectClass.SchemaWrapper();
        Schema.SObjectType navSchema;
         try{
            //Calling the abstract class 'Cls_SchemaObjectClass' method.
            schemawrap = Cls_SchemaObjectClass.getSchemaNameSapce();
            if(schemawrap.navSetupobj <> null && schemawrap.wraprefreshToken <> null && schemawrap.wrapaccessToken <> null){
                    navSchema = schemawrap.navSetupobj;
                    refreshTokenfield = schemawrap.wraprefreshToken;
                    accessTokenfield = schemawrap.wrapaccessToken;
            }
            String objname = String.valueof(navSchema);
            
            idflag = Cls_SchemaObjectClass.isAccessible(objname,'id');
            reftokenflag = Cls_SchemaObjectClass.isUpdateable(objname,refreshTokenfield);
            accesstokenflag = Cls_SchemaObjectClass.isUpdateable(objname,accessTokenfield);
            //system.debug('idflag>>>> '+idflag+' reftokenflag>>'+reftokenflag+' accesstokenflag>>'+accesstokenflag);
            if(flag == true && setUprecId <> ''){
                    
                if(idflag == true && reftokenflag == true && accesstokenflag == true){    
                    
                    Schema.SObjectType setupobj = Schema.getGlobalDescribe().get(objname);
                    SObject navsetupRec = setupobj.newSObject();
                    navsetupRec.put('id', setUprecId);
                    navsetupRec.put(accessTokenfield, access_token);
                    navsetupRec.put(refreshTokenfield, refresh_token);
                    flag = false;
                    update navsetupRec;
                }
            }
        }catch(exception ex){
            returnMsg ='Exception:' +ex.getMessage()+' linenumber :'+ex.getLineNumber()+' Type : '+ex.getTypeName();
            system.debug('_____'+ex.getMessage()+'____linenumber___'+ex.getLineNumber()+'-----exception type--'+ex.getTypeName());
        }
        system.debug('returnMsg>>>'+returnMsg);
        return returnMsg;
    }
    
    //To set blank in access token and refresh token field of navatar setup object
    @Auraenabled 
    public static String updateSetupRecord(String setUprecId){
        String returnStr='';
        string accessTokenfield ='';
        string refreshTokenfield ='';
        boolean idflag = false;  
        boolean reftokenflag = false;
        boolean accesstokenflag = false;
        Cls_SchemaObjectClass.SchemaWrapper schemawrap = new Cls_SchemaObjectClass.SchemaWrapper();
        Schema.SObjectType navSchema;
        try{
            //Calling the abstract class 'Cls_SchemaObjectClass' method.
            schemawrap = Cls_SchemaObjectClass.getSchemaNameSapce();
            if(schemawrap.navSetupobj <> null && schemawrap.wraprefreshToken <> null && schemawrap.wrapaccessToken <> null){
                    navSchema = schemawrap.navSetupobj;
                    refreshTokenfield = schemawrap.wraprefreshToken;
                    accessTokenfield = schemawrap.wrapaccessToken;
            }
            String objname = String.valueof(navSchema);
        
            idflag = Cls_SchemaObjectClass.isAccessible(objname,'id');
            reftokenflag = Cls_SchemaObjectClass.isUpdateable(objname,refreshTokenfield);
            accesstokenflag = Cls_SchemaObjectClass.isUpdateable(objname,accessTokenfield);
               
            if(idflag == true && reftokenflag == true && accesstokenflag == true){    
                if(setUprecId <> null && setUprecId <> ''){
                    
                    Schema.SObjectType setupobj = Schema.getGlobalDescribe().get(objname);
                    SObject navsetupRec = setupobj.newSObject();
                    navsetupRec.put('id', setUprecId);
                    navsetupRec.put(accessTokenfield, null);
                    navsetupRec.put(refreshTokenfield, null);
                    update navsetupRec;
                }
            }
        }catch(exception ex){
            returnStr ='Exception:' +ex.getMessage()+' linenumber :'+ex.getLineNumber()+' Type : '+ex.getTypeName();
        }
        system.debug('returnStr>>>'+returnStr);
        return returnStr;
    }//method close updateSetupRecord
    
    //To update account with new preqin Id
    @Auraenabled
    public static String updateAccount(String accid,string preqinId){
        String returnStr = null;
        string acccountPreqinfield ='';
        boolean idflag = false;  
        boolean accPreqinflag = false;
        try{
            //Calling the abstract class 'Cls_SchemaObjectClass' method.
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType accSchema = schemaMap.get('Account');
            Map<String, Schema.SObjectField> fieldMap = accSchema.getDescribe().fields.getMap();
            for (String fieldName: fieldMap.keySet()){ 
                //It provides to get the object fields label.
                String fieldApi = fieldMap.get(fieldName).getDescribe().getName();
                If(fieldApi.contains('Preqin_RE_Account_ID__c')){
                    acccountPreqinfield = fieldApi;
                    break;
                }
            }//for close
                    
            idflag = Cls_SchemaObjectClass.isAccessible('Account','id');
            accPreqinflag = Cls_SchemaObjectClass.isUpdateable('Account',acccountPreqinfield);
            
            if(accid <> null && accid <> '' && preqinId <> null && preqinId <> '' ){
                if(idflag == true && accPreqinflag == true ){ 

                    Schema.SObjectType accObj = Schema.getGlobalDescribe().get('Account');
                    SObject accountRec = accObj.newSObject();
                    accountRec.put('id', accid);
                    accountRec.put(acccountPreqinfield, preqinId);
                    update accountRec;
                    
                }
            }
        }catch(exception ex){
                returnStr ='Exception:' +ex.getMessage()+' linenumber :'+ex.getLineNumber()+' Type : '+ex.getTypeName();
                system.debug('_____'+ex.getMessage()+'____linenumber___'+ex.getLineNumber()+'-----exception type--'+ex.getTypeName());
        }
        system.debug('returnStr>>>'+returnStr);
        return returnStr;
    }
    
    //AllocationWrapper class for Showing Allocation in preqin PERE
    public class AllocationWrapper{
        @Auraenabled
        public string type {get;set;}
        
        @Auraenabled
        public string status {get;set;}
        
        @Auraenabled
        public string current_value {get;set;}
        
        @Auraenabled
        public string current_perc {get;set;}
        
        @Auraenabled
        public string target_value {get;set;}
        
        @Auraenabled
        public string target_perc {get;set;}
    }
    
    //Returning New Refresh Token 
    public class WrapperNewRefreshToken{
        @Auraenabled
        public string accessToken {get;set;}
        
        @Auraenabled
        public string refreshToken {get;set;}
        
        @Auraenabled
        public string statusStr {get;set;}
        
        @Auraenabled
        public string excepStr {get;set;}
    }
    
    //Retruning Access Token and refresh token
    public class WrapperSetupRecord{
        @Auraenabled
        public string setUpRecordid {get;set;}
        
        @Auraenabled
        public string accessToken {get;set;}
        
        @Auraenabled
        public string refreshToken {get;set;}
        
        @Auraenabled
        public string setUpStatus {get;set;}
        
        @Auraenabled
        public string exceptionStr {get;set;}
    }
    
    //Returing to helper class. First var is List of firm name and second var is to check the Refresh token validity.
    public class WrapperFirmName{
        @Auraenabled
        public List<firmNameWrapper> firmNameWrapper{get;set;}
        
        @Auraenabled
        public string strFirmStatus {get;set;}
        
        @Auraenabled
        public string totalPageCount {get;set;}
        
        @Auraenabled
        public string strexception {get;set;}
        
    }
    
    public class firmNameWrapper{
        @Auraenabled
        public String firmID{get;set;} 
        
        @Auraenabled
        public String firmName{get;set;} 
        
        @Auraenabled
        public String firmType{get;set;} 
        
        @Auraenabled
        public String location{get;set;} 
        
        @Auraenabled
        public String btnStatus{get;set;}
        
    }//firmNameWrapper class close
    
    
    //Returning to helper controller. All the variable is set as per the record. Only strStatus var is used to check the refresh token.
    
    public class WrapperDetailclass{
        
        @Auraenabled
        public String name{get;set;}
        
        @Auraenabled
        public List<String> alternativeNames{get;set;}
        
        @Auraenabled
        public String firmType{get;set;}
        
        @Auraenabled
        public String background{get;set;}
        
        @Auraenabled
        public List<cls_addresses> addresses{get;set;}
        
        @Auraenabled
        public cls_typicallyInvest typicallyInvest{get;set;}
        
        @Auraenabled
        public List<cls_investmentConsultants> investmentConsultants{get;set;}
        
        @Auraenabled
        public cls_totalFundsUnderManagement totalFundsUnderManagement{get;set;}
        
        @Auraenabled
        public cls_initialContact initialContact{get;set;}
        
        @Auraenabled
        public List<cls_contacts> contacts{get;set;}
        
        @Auraenabled
        public List<cls_investmentAllocationsPE> investmentAllocationsPE{get;set;}
        
        @Auraenabled
        public List<cls_investmentConsultantsPE> investmentConsultantsPE{get;set;}
        
        @Auraenabled
        public cls_investorPreferencesPE investorPreferencesPE{get;set;}
        
        @Auraenabled
        public String strStatus{get;set;}
        
        @Auraenabled
        public String strexcep{get;set;}
        
        ///additional attribute
        @Auraenabled
        public String type{get;set;}
        
        @Auraenabled
        public String assetClass{get;set;}
        
        @Auraenabled
        public List<String> assetClasses {get;set;} 
        
        @Auraenabled
        public String currentlyInvesting {get;set;} 
        
        @Auraenabled
        public String investorCurrency {get;set;} 
        
        @Auraenabled
        public FutureInvestmentPlan futureInvestmentPlan{get;set;}
        
        @Auraenabled
        public AlternativesAllocation alternativesAllocation{get;set;}
		
        
        @Auraenabled
        public List<String> otherCountryList {get;set;}
        
        @Auraenabled
        public List<String> nonPEInvConsltList {get;set;}   
        
        @Auraenabled    
        public List<cls_investmentAllocationsPE> primaryDirectSecondaryInvAllocList{get;set;}
        
        
        //PRE New Fields
        @Auraenabled    
        public List<cls_strategyAllocationsRE> strategyAllocationsRE{get;set;}
        
        @Auraenabled 
        public List<cls_investmentAllocations> investmentAllocations{get;set;}
        
        @Auraenabled
        public List<cls_investmentConsultantsRE> investmentConsultantsRE{get;set;}
        
        @Auraenabled
        public cls_investorPreferencesRE investorPreferencesRE{get;set;}
        
		@Auraenabled
		public cls_investorPreferences investorPreferences { get; set; }
		
        @Auraenabled
        public List<AllocationWrapper> allocationWrapperList{get;set;}
		
		//Infra New fields
		@Auraenabled
		public string allocationSource { get; set; }

		@Auraenabled
		public string yearOfFirstInvestment { get; set; }
		
		@Auraenabled
        public List<cls_investmentConsultantsINF > investmentConsultantsINF {get;set;}
    }   
	    
    //Infra Fields
    public class cls_investmentConsultantsINF {
        @Auraenabled
        public String name{get;set;}
        
        @Auraenabled
        public String id{get;set;}
        
        @Auraenabled
        public String self{get;set;}
        
		
    }
	public class cls_investorPreferences
	{
	    @Auraenabled
		public List<string> projectStages { get; set; }
		
		@Auraenabled
		public List<string> strategies { get; set; }
		
		@Auraenabled
		public List<string> industries { get; set; }
		
		@Auraenabled
		public List<string> locations { get; set; }
		
		@Auraenabled
		public string investFirstTimeFunds { get; set; }
		
		@Auraenabled
		public string coInvestments { get; set; }
		
		@Auraenabled
		public string investSeparateAccounts { get; set; }
		
		@Auraenabled
		public string investPPPorPFI { get; set; }
		
		@Auraenabled
		public List<object> PPPorPFITypes { get; set; }
	}
    //PRE Fields
    public class cls_strategyAllocationsRE{
        @Auraenabled
        public string strategy {get;set;}
        
        @Auraenabled
        public decimal percent {get;set;}
    }
    
    //PRE Fields
    public  class cls_investmentAllocations {
        @Auraenabled
        public String allocationType{get;set;}
        
        @Auraenabled
        public decimal percent{get;set;}
        
        @Auraenabled
        public String status{get;set;}
        
        @Auraenabled
        public String source{get;set;}
        
        @Auraenabled
        public string valueUSD{get;set;}
        
        @Auraenabled
        public String valueEUR{get;set;}
        
        @Auraenabled
        public decimal value{get;set;}
        
        @Auraenabled
        public String currency_y{get;set;}
    }
    
    //PRE Fields
    public class cls_investmentConsultantsRE {
        @Auraenabled
        public String name{get;set;}
        
        @Auraenabled
        public String id{get;set;}
        
        @Auraenabled
        public String self{get;set;}
        
    }
    
    //PRE Fields
    public  class cls_investorPreferencesRE {
        @Auraenabled
        public String coinvestwithGP{get;set;}
        
        @Auraenabled
        public List<String> locations{get;set;}
        
        @Auraenabled
        public List<String> debtTypes{get;set;}
        
        @Auraenabled
        public List<String> propertyTypes{get;set;}
        
        @Auraenabled
        public String firstTimeREFunds{get;set;}
        
        @Auraenabled
        public String separateAccountsRE{get;set;}
        
        @Auraenabled
        public String jointVenturesRE{get;set;}
    }
    
    public class AlternativesAllocation{
        @Auraenabled
        public decimal value {get;set;}
        
        @Auraenabled
        public decimal percent {get;set;}
    }
    
    public class FutureInvestmentPlan{
        @Auraenabled
        public String timeFrameOfNextCommitments {get;set;} 
        
        @Auraenabled
        public NumberOfFunds numberOfFunds {get;set;} 
        
        @Auraenabled
        public string estimatedAmount {get;set;} 
        
        @Auraenabled
        public String newManagers {get;set;}
        
        @Auraenabled
        public String summaryOfNextYear {get;set;}
        
        @Auraenabled
        public String next12MonthsQuarter {get;set;}
        
        @Auraenabled
        public List<String> next12MonthsRegions {get;set;}
        
        @Auraenabled
        public List<String> next12MonthsFundTypePreferences{get;set;}
        
        @Auraenabled
        public List<String> next12MonthsIndustries{get;set;}
        
        //New PRE Fields
        @Auraenabled
        public List<String> next12MonthsStrategies{get;set;}
        
    }
    public class NumberOfFunds{
        @Auraenabled
        public decimal min{get;set;}
        
        @Auraenabled
        public decimal max{get;set;}
    }
    
    public class cls_addresses {
        @Auraenabled
        public String address1{get;set;}
        
        @Auraenabled
        public String city{get;set;}
        
        @Auraenabled
        public String state{get;set;}
        
        @Auraenabled
        public String country{get;set;}
        
        @Auraenabled
        public String region{get;set;}
        
        @Auraenabled
        public String zipCode{get;set;}
        
        @Auraenabled
        public String tel{get;set;}
        
        @Auraenabled
        public String fax{get;set;}
        
        @Auraenabled
        public String email{get;set;}
        
        @Auraenabled
        public String web{get;set;}
        
        @Auraenabled
        public String googleMapUri{get;set;}
        
        @Auraenabled
        public String telExtension{get;set;}
        
        @Auraenabled
        public String longitude{get;set;}
        
        @Auraenabled
        public String latitude{get;set;}
        
        @Auraenabled
        public String placeID{get;set;}
        
        @Auraenabled
        public String address2{get;set;}
        
        @Auraenabled
        public String isMain{get;set;}
        
    }
    
    public  class cls_investmentConsultants {
        @Auraenabled
        public String id{get;set;} //need to confirm
        
        @Auraenabled
        public String name{get;set;}
        
        @Auraenabled
        public String self{get;set;}    //need to confirm
    }
    public  class cls_contacts {
        
        @Auraenabled
        public String email{get;set;}
        
        @Auraenabled
        public String firstName{get;set;}
        
        @Auraenabled
        public String surName{get;set;}
        
        @Auraenabled
        public String jobTitle{get;set;}
        
        @Auraenabled
        public String tel{get;set;}
        
        @Auraenabled
        public String linkedIn{get;set;}
        
        @Auraenabled
        public cls_address address{get;set;}
        
        @Auraenabled
        public string isPrimary{get;set;}
        
        //new added attribute
        @Auraenabled
        public string contactId{get;set;}
        
        @Auraenabled
        public string contactFirmId{get;set;}
        
    }
    public  class cls_investmentAllocationsPE {
        @Auraenabled
        public String allocationType{get;set;}
        
        @Auraenabled
        public decimal percent{get;set;}
        
        @Auraenabled
        public String status{get;set;}
        
        @Auraenabled
        public String source{get;set;}
        
        @Auraenabled
        public string valueUSD{get;set;}
        
        @Auraenabled
        public String valueEUR{get;set;}
        
        //new attribute
        @Auraenabled
        public decimal value{get;set;}
        
        @Auraenabled
        public String currency_x{get;set;}
    }
    public  class cls_investmentConsultantsPE {
        @Auraenabled
        public String name{get;set;}
        
        //new attribute, need to discuss
        @Auraenabled
        public String id{get;set;}
        
        @Auraenabled
        public String self{get;set;}
        
    }
    public  class cls_typicallyInvest {
        @Auraenabled
        public cls_ic ic{get;set;}
        
        @Auraenabled
        public cls_usd usd{get;set;}
        
        @Auraenabled
        public cls_eur eur{get;set;}
    }
    public  class cls_ic {
        @Auraenabled
        public decimal min{get;set;}
        
        @Auraenabled
        public decimal max{get;set;}
    }
    public  class cls_usd {
        @Auraenabled
        public String min{get;set;}
        
        @Auraenabled
        public String max{get;set;}
    }
    public  class cls_eur {
        @Auraenabled
        public String min{get;set;}
        
        @Auraenabled
        public String max{get;set;}
    }
    public  class cls_totalFundsUnderManagement {
        @Auraenabled
        public decimal ic{get;set;}
        
        @Auraenabled
        public String usd{get;set;}
        
        @Auraenabled
        public String eur{get;set;}
    }
    public  class cls_initialContact {
        @Auraenabled
        public String email{get;set;}
        
        @Auraenabled
        public String firstName{get;set;}
        
        @Auraenabled
        public String surName{get;set;}
        
        @Auraenabled
        public String jobTitle{get;set;}
        
        @Auraenabled
        public String tel{get;set;}
        
        @Auraenabled
        public String linkedIn{get;set;}
        
        @Auraenabled
        public cls_address address{get;set;}
        
        //new attribute
        @Auraenabled
        public String initialEmail{get;set;}  // need to check
        
        @Auraenabled
        public String comments{get;set;}
        
        @Auraenabled
        public String preferedMethod{get;set;}
        
    }
    public  class cls_investorPreferencesPE {
        @Auraenabled
        public String coinvestwithGP{get;set;}
        
        @Auraenabled
        public String firstCloseInvestor{get;set;}
        
        @Auraenabled
        public List<String> geographicPreferences{get;set;}
        
        @Auraenabled
        public List<String> fundTypes{get;set;}
        
        @Auraenabled
        public List<String> industries{get;set;}
        
        @Auraenabled
        public String firstTimeFunds{get;set;}
        
        @Auraenabled
        public String separateAccounts{get;set;}
    }
    public  class cls_address {
        @Auraenabled
        public String address1{get;set;}
        
        @Auraenabled
        public String city{get;set;}
        
        @Auraenabled
        public String state{get;set;}
        
        @Auraenabled
        public String country{get;set;}
        
        @Auraenabled
        public String region{get;set;}
        
        @Auraenabled
        public String zipCode{get;set;}
        
        @Auraenabled
        public String tel{get;set;}
        
        @Auraenabled
        public String email{get;set;}
        
        @Auraenabled
        public String googleMapUri{get;set;}
        
        @Auraenabled
        public String fax{get;set;}
        
        @Auraenabled
        public String longitude{get;set;}
        
        @Auraenabled
        public String latitude{get;set;}
        
        @Auraenabled
        public String placeID{get;set;} 
        
        @Auraenabled
        public String address2{get;set;}
        
        @Auraenabled
        public String telExtension{get;set;}
        
        @Auraenabled
        public String web{get;set;}
        
        @Auraenabled
        public String isMain{get;set;}
    }
    
}//class close