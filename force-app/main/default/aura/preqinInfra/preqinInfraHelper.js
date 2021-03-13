/*********************************************************************************
			** Module Name : Preqin PERE Helper
			** Description : To call PreqinRE_Controller to make hit on preqin server and implemented the hide and show fuctionality and set classes to display data in 1,2,3 or 4 envelope size and apply the sorting functionality.
			** Revision History:-
			** Version   Date        Author        WO#   Description of Action
			** 1.2      02/07/2018  Kumar Jonson        
			
	*********************************************************************************/

({
    //To open the preqin endpoint login window for authentication
    openPreqinloginWindow : function(cmp){
        debugger;
        this.togglesection(cmp,'_div_refresh_pere');
        var recordUrl = window.location.href;
        var strUrl = recordUrl.toString();
        var splitUrl = strUrl.split('.com/');
        if(splitUrl != null && splitUrl.length > 0){
            
            var finalbaseUrl = splitUrl[0]+'.com';
            var openurl = finalbaseUrl+'/c/preqinOathApp.app?state='+recordUrl;
            //window.open(openurl, '_blank', 'width=450,height=580,top='+top+', left='+left+', scrollbars=yes,status=yes');
            var w = 400, h = 580,
                left = Number((screen.width/2)-(w/2)), tops = Number((screen.height/2)-(h/2));
            window.open(openurl, '_blank', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=1, copyhistory=no, width='+w+', height='+h+', top='+tops+', left='+left);
            
        }
    },
    toggleCollapseShow_helper : function(component, showbutton, hidebutton, showhidesection) { 
        debugger;
        var showBtm = component.find(showbutton) ;
        var hideBtm = component.find(hidebutton) ;   
        var divsection = component.find(showhidesection) ;
        $A.util.toggleClass(showBtm, 'slds-hide');       
        $A.util.toggleClass(hideBtm, 'slds-hide');  
        $A.util.toggleClass(divsection, 'slds-hide');
    },
    resetallSection: function(cmp){
        this.resetSection(cmp,'Show_Div1_pere','Hide_Div1_pere','ShoHide_Div1_pere');
        this.resetSection(cmp,'Show_Div2_pere','Hide_Div2_pere','ShoHide_Div2_pere');
        this.resetSection(cmp,'Show_Div3_pere','Hide_Div3_pere','ShoHide_Div3_pere');		
        this.resetSection(cmp,'Show_Div_OtherOffices_pere','Hide_Div_OtherOffices_pere','ShoHide_Div_OtherOffices_pere');
    },
    resetSection : function(component, showbutton, hidebutton, showhidesection) { 
        debugger;
        
        var showBtm = component.find(showbutton) ;
        var isExpandable = $A.util.hasClass(component.find(showbutton), "slds-hide");
        var hideBtm = component.find(hidebutton) ; 
        var isExpandable1 = $A.util.hasClass(component.find(hidebutton), "slds-hide");
        var divsection = component.find(showhidesection) ;
        var isExpandable2 = $A.util.hasClass(component.find(showhidesection), "slds-hide");
        if(showbutton=='Show_Div1_pere')
        {
            if(isExpandable)
                $A.util.toggleClass(showBtm, 'slds-hide');  
            if(!isExpandable1)		
                $A.util.toggleClass(hideBtm, 'slds-hide');  		
            if(isExpandable2)
                $A.util.toggleClass(divsection, 'slds-hide');
        }
        else{
            if(isExpandable)
                $A.util.toggleClass(showBtm, 'slds-hide');  
            if(!isExpandable1)		
                $A.util.toggleClass(hideBtm, 'slds-hide');  		
            if(!isExpandable2)
                $A.util.toggleClass(divsection, 'slds-hide');
        }
    },
    doInitHelper : function(component,event){
        this.afterdoinit(component,event);
    },
    
    afterdoinit : function(cmp, event){
        debugger;
        this.showblurredImage(cmp);
		this.resetallSection(cmp);	
        var accountId = cmp.get("v.recordId");
        var action = cmp.get("c.getNavSetupRec");
        action.setCallback(this, function(res){
            debugger;
            var setUprecord = res.getReturnValue();
            if(setUprecord != null && setUprecord != '' && setUprecord.setUpStatus!= null ){
              
                if(setUprecord.setUpStatus == 'Ok'){
                    
                    cmp.set("v.setUprecId", setUprecord.setUpRecordid);
                    var flag = false;
                    
                    this.checkaccountAndHitPreqin(cmp,accountId,flag);
                }else if(setUprecord.setUpStatus == 'Fail'){
                    this.togglesection(cmp,'_div_login_pere');
                    this.HideblurredImage(cmp);
                }else if(setUprecord.exceptionStr != '' || setUprecord.exceptionStr != null){
                    this.showAlertError(cmp,'Error',setUprecord.exceptionStr);
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    //called from js controller will query the account and hit the preqin accordingly.
    checkaccountAndHitPreqin : function(cmp,accid,flag){
        debugger;
        var action = cmp.get("c.getAccountdetails"); 
        var preqid='' ;
        var accname='';
        action.setParams({
            accId : accid
        });
        action.setCallback(this, function(res){
            var state = res.getState();
            if (state === "SUCCESS") {
                debugger;
                var accountMap  = res.getReturnValue();
                var accvalue = JSON.parse(accountMap);
                if(accvalue.Exception != null || accvalue.Exception != ''){
                    preqid = accvalue.preqinid;
                    accname  = accvalue.accname;
                    cmp.set("v.firmname",accname);
                    cmp.set("v.accountPreqinId",preqid);
                    if(preqid != null && preqid != ''){
                       alert('@@@'+preqid);
                        this.getDatafromPreqin_bypreqinId(cmp,preqid,flag);
                    }
                    else{
                       // this.getDatafromPreqin_frimName(cmp,accname);
                    }
                }else{
                    
                    this.showAlertError(cmp,'Error',accvalue.Exception);
                }
            }else if (state === "ERROR") {
                var errors = res.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    } else {
                        console.log("Unknown error");
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    //called from js controller, and hit preqin based on account name or serch text. In case of first time load, if there is only 1 serached result, then it will open in the detail page, and if there are more than 1 serached result then it will display on the serach grid.
    getDatafromPreqin_frimName : function(cmp,accname){
        //this.showblurredImage(cmp);
        var action2 = cmp.get("c.getDatafromPreqin_accName"); 
        var setupRecid =cmp.get("v.setUprecId");
        action2.setParams({
            accname : accname,
            setUprecId : setupRecid
        });
        action2.setCallback(this, function(res2){
            var state = res2.getState();
			var globalId = cmp.getGlobalId();
            if(state === "SUCCESS"){
                debugger;
				var firmList  = res2.getReturnValue();
                if(firmList.strexception == null || firmList.strexception == ''){
                    if(firmList.strFirmStatus == '' || firmList.strFirmStatus == null){
						var firmdetails = firmList.firmNameWrapper;
                        var accPreqId = cmp.get("v.accountPreqinId");
                        if(firmdetails != null){
                            if(firmdetails.length == 1 ){
                                var flag = false;
                                if(accPreqId == '' || accPreqId == undefined){
                                    if(accPreqId != firmdetails["0"].firmID){
                                        flag = true;
                                    }
                                }
                                this.getDatafromPreqin_bypreqinId(cmp,firmdetails["0"].firmID,flag);
                            }else{
                                document.getElementById(globalId+'_div_login_pere').style.display = "none";
                                document.getElementById(globalId+'_div_refresh_pere').style.display = "none";              
                                document.getElementById(globalId+'_div_grid_pere').style.display = "block";
								cmp.set("v.mydataPageCount", firmList.totalPageCount);
                                this.HideblurredImage(cmp);
                            }
                            this.preqinFirmDataBinding(cmp,firmdetails,accPreqId);						
                        }	
                    }else{
                        document.getElementById(globalId+'_div_refresh_pere').style.display = "block";
                        document.getElementById(globalId+'_div_grid_pere').style.display = "none";
						this.HideblurredImage(cmp);
                        this.openPreqinloginWindow(cmp);
                    }
                }else{
                    this.showAlertError(cmp,'Error',firmList.strexception);
                    
                }
            }else if (state === "ERROR") {
                var errors = res2.getError();
                if(errors) {
                    document.getElementById(globalId+'_div_login_pere').style.display = "block";
                    if(errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }else {
                        console.log("Unknown error");
                    }
                }
            }
        });
        $A.enqueueAction(action2);
        
        
    },
    
    //called from js controller, It will hit the preqin based on the account preqin id
    getDatafromPreqin_bypreqinId : function(cmp,preqinid,flag){
        debugger;
        
        //this.showblurredImage(cmp);
        var action3 = cmp.get("c.getDatafromPreqin_preqinId"); 
        var setupRecid =cmp.get("v.setUprecId");
		var globalId = cmp.getGlobalId();
        action3.setParams({
            accPreqId : preqinid,
            setUprecId : setupRecid
        });
        action3.setCallback(this, function(res){
            var state = res.getState();
            if(state === "SUCCESS"){
                debugger;
                cmp.set("v.moreOtherOffices",0);
                cmp.set("v.allocationSectionCheck",false);
                cmp.set("v.current_N_TargetAlloc_check",false);
                cmp.set("v.show_all_contact",false);
                cmp.set("v.next12MonthsTable",false);
                cmp.set("v.futurePlanSection",false);
                cmp.set("v.contactSection",false);
                cmp.set("v.preferenceSection",false);
                cmp.set("v.investmentConsultantsSection",false);
                var accountdetail  = res.getReturnValue();
                  alert('FFFF'+accountdetail.futureInvestmentPlan);
                //If Refresh token not expire
                if(accountdetail.strexcep == null || accountdetail.strexcep == ''){
                    if(accountdetail.strStatus == '' || accountdetail.strStatus == null){
                        if(accountdetail !=null && accountdetail != ''){
                            
                            //To set the wrapperclass in component's wrappers variable.
                            cmp.set("v.wrappers",accountdetail);
                            
                            //To check weather it has any contact or not
                            var nullcount = false;
                            var notnullcount = false;
                            if(accountdetail.contacts != null && accountdetail.contacts.length > 0){
                                var allcontact = accountdetail.contacts;
                                //var flag = false;
                                
                                if(allcontact.length > 0 && allcontact != undefined){
                                    for(var cont in allcontact){
                                        if(	!notnullcount && (allcontact[cont].email != null && allcontact[cont].email != '') || (allcontact[cont].firstName != null && allcontact[cont].firstName != '') || (allcontact[cont].surName != null && allcontact[cont].surName != '') || (allcontact[cont].jobTitle != null && allcontact[cont].jobTitle != '') || (allcontact[cont].tel != null && allcontact[cont].tel != '') || (allcontact[cont].linkedIn != null && allcontact[cont].linkedIn != '') || (allcontact[cont].address1 != null && allcontact[cont].address1!= '') || (allcontact[cont].address2 != null && allcontact[cont].address2 != '') || (allcontact[cont].city != null && allcontact[cont].city != '') || (allcontact[cont].state != null && allcontact[cont].state != '') || (allcontact[cont].country != null && allcontact[cont].country != '') || (allcontact[cont].zipCode != null && allcontact[cont].zipCode != '')){
                                            notnullcount= true;
                                        }
                                    }//for close
                                }
                                if(notnullcount){
                                    cmp.set("v.show_all_contact",true);
                                }else{
                                    cmp.set("v.show_all_contact",false);
                                }
                            }else{
                                cmp.set("v.show_all_contact",false);
                            }
                            debugger;
                            
                            //To check the contact section
                            if(((accountdetail.initialContact != null && accountdetail.initialContact != undefined ) && ((accountdetail.initialContact.preferedMethod != null && accountdetail.initialContact.preferedMethod != '') || (accountdetail.initialContact.initialEmail != null && accountdetail.initialContact.initialEmail != '') || (accountdetail.initialContact.comments != null && accountdetail.initialContact.comments != ''))) || (notnullcount == true) || (accountdetail.investmentConsultantsINF != null && accountdetail.investmentConsultantsINF.length > 0) || (accountdetail.nonPEInvConsltList != null && accountdetail.nonPEInvConsltList.length > 0)){
                                cmp.set("v.contactSection",true);
                            }else{
                                cmp.set("v.contactSection",false);
                            }
                            
                            debugger;
                            //To check the investor Consultants sectoin
                            if(((accountdetail.investmentConsultantsINF != undefined) && (accountdetail.investmentConsultantsINF != null && accountdetail.investmentConsultantsINF.length > 0)) || ((accountdetail.nonPEInvConsltList != undefined) && ( accountdetail.nonPEInvConsltList != null  && accountdetail.nonPEInvConsltList.length > 0))){
                                
                                cmp.set("v.investmentConsultantsSection",true);
                            }else{
                                cmp.set("v.investmentConsultantsSection",false);
                            }
                            
                            //To check the other offices
                            var otherOffices = accountdetail.addresses;
                            var otherOfficeCheck = true;  //assign default value as true
                            if(otherOffices != null && otherOffices.length > 0){
                                for(var otherOff in otherOffices){
                                    if((otherOffices[otherOff].isMain == 'false') && ((otherOffices[otherOff].address1 != null && otherOffices[otherOff].address1 != '') || (otherOffices[otherOff].address2 != null && otherOffices[otherOff].address2 != '') || (otherOffices[otherOff].city != null && otherOffices[otherOff].city != '') || (otherOffices[otherOff].state != null && otherOffices[otherOff].state != '') || (otherOffices[otherOff].country != null && otherOffices[otherOff].country != '') || (otherOffices[otherOff].zipCode != null && otherOffices[otherOff].zipCode != '') || (otherOffices[otherOff].fax != null && otherOffices[otherOff].fax != '') || (otherOffices[otherOff].tel != null && otherOffices[otherOff].tel != ''))){
                                        otherOfficeCheck = false;
                                    }
                                }
                                
                                if(otherOfficeCheck == false){
                                    cmp.set("v.moreOtherOffices",otherOffices.length);
                                }
                            }
                            
                            //To check the preference section
                            if( (accountdetail.investorPreferencesRE != null && accountdetail.investorPreferencesRE != undefined) && ((accountdetail.investorPreferencesRE.firstTimeREFunds != undefined && accountdetail.investorPreferencesRE.firstTimeREFunds != '' && accountdetail.investorPreferencesRE.firstTimeREFunds != null) || (accountdetail.investorPreferencesRE.separateAccountsRE != undefined && accountdetail.investorPreferencesRE.separateAccountsRE != '' && accountdetail.investorPreferencesRE.separateAccountsRE != null) || (accountdetail.investorPreferencesRE.coinvestwithGP != undefined && accountdetail.investorPreferencesRE.coinvestwithGP != '' && accountdetail.investorPreferencesRE.coinvestwithGP != null) || (accountdetail.investorPreferencesRE.jointVenturesRE != undefined && accountdetail.investorPreferencesRE.jointVenturesRE != '' && accountdetail.investorPreferencesRE.jointVenturesRE != null) || (accountdetail.investorPreferencesRE.locations != null && accountdetail.investorPreferencesRE.locations.length > 0 ) ||  (accountdetail.investorPreferencesRE.debtTypes != null && accountdetail.investorPreferencesRE.debtTypes.length > 0 ) || (accountdetail.investorPreferencesRE.propertyTypes != null && accountdetail.investorPreferencesRE.propertyTypes.length > 0 ) ) ) {
                                cmp.set("v.preferenceSection",true);
                            }else{
                                cmp.set("v.preferenceSection",false);
                            }
                            
                            
                            
                            
                            //Future plan section
                            if(accountdetail.futureInvestmentPlan != null && accountdetail.futureInvestmentPlan != undefined){
                                
                                var next12MonthsTable = accountdetail.futureInvestmentPlan;
                                if((accountdetail.futureInvestmentPlan.next12MonthsQuarter != null && accountdetail.futureInvestmentPlan.next12MonthsQuarter != '') ||  (accountdetail.futureInvestmentPlan.estimatedAmount != null && accountdetail.futureInvestmentPlan.estimatedAmount != '') || ( accountdetail.futureInvestmentPlan.timeFrameOfNextCommitments != null && accountdetail.futureInvestmentPlan.timeFrameOfNextCommitments != '') || ( accountdetail.futureInvestmentPlan.newManagers != null && accountdetail.futureInvestmentPlan.newManagers != '') || ( accountdetail.futureInvestmentPlan.summaryOfNextYear != null && accountdetail.futureInvestmentPlan.summaryOfNextYear != '') || ((accountdetail.futureInvestmentPlan.numberOfFunds != null && accountdetail.futureInvestmentPlan.numberOfFunds != undefined) && ( accountdetail.futureInvestmentPlan.numberOfFunds.min != null && accountdetail.futureInvestmentPlan.numberOfFunds.min != undefined) || (accountdetail.futureInvestmentPlan.numberOfFunds.max != null && accountdetail.futureInvestmentPlan.numberOfFunds.max != undefined )) || (accountdetail.futureInvestmentPlan.next12MonthsRegions != null && accountdetail.futureInvestmentPlan.next12MonthsRegions.length > 0 ) || (accountdetail.futureInvestmentPlan.next12MonthsStrategies != null && accountdetail.futureInvestmentPlan.next12MonthsStrategies.length > 0 ) || (accountdetail.futureInvestmentPlan.next12MonthsIndustries != null && accountdetail.futureInvestmentPlan.next12MonthsIndustries.length > 0 )){
                                    
                                    cmp.set("v.futurePlanSection",true);
                                }else{
                                    cmp.set("v.futurePlanSection",false);
                                }
                            }else{
                                cmp.set("v.futurePlanSection",false);
                            }
                            
                            
                            //To check Next 12 months Table
                            debugger;
                            if(accountdetail.futureInvestmentPlan != null && accountdetail.futureInvestmentPlan != undefined){
                                
                                var next12MonthsTable = accountdetail.futureInvestmentPlan;
                                if(((accountdetail.futureInvestmentPlan.numberOfFunds != null && accountdetail.futureInvestmentPlan.numberOfFunds != undefined) && ( accountdetail.futureInvestmentPlan.numberOfFunds.min != null && accountdetail.futureInvestmentPlan.numberOfFunds.min != undefined) || (accountdetail.futureInvestmentPlan.numberOfFunds.max != null && accountdetail.futureInvestmentPlan.numberOfFunds.max != undefined )) || ( accountdetail.futureInvestmentPlan.estimatedAmount != null && accountdetail.futureInvestmentPlan.estimatedAmount != '') || (accountdetail.futureInvestmentPlan.newManagers != null && accountdetail.futureInvestmentPlan.newManagers != '')){
                                    cmp.set("v.next12MonthsTable",true);
                                }else{
                                    cmp.set("v.next12MonthsTable",false);
                                }
                            }else{
                                cmp.set("v.next12MonthsTable",false);
                            }
                            
                            
                            //To check the Primay, Direct and Secondary Allocation type
                            var allocPEflag = false;
                            var Curr_n_targetAlloc = false;
                            if(accountdetail.investmentAllocations != null && accountdetail.investmentAllocations.length > 0){
                                var allocExceptCurrentTarget = accountdetail.investmentAllocations;
                                if(allocExceptCurrentTarget != undefined){
                                    for(var alloc in allocExceptCurrentTarget){
                                        if(allocExceptCurrentTarget[alloc].allocationType != 'Current Allocation' && allocExceptCurrentTarget[alloc].allocationType != 'Target Allocation'){
                                            allocPEflag = true;
                                        }else{
                                            Curr_n_targetAlloc = true;
                                        }
                                    }
                                    if(allocPEflag == true){
                                        cmp.set("v.allocationSectionCheck",true);
                                    }
                                    if(Curr_n_targetAlloc == true){
                                        cmp.set("v.current_N_TargetAlloc_check",true);
                                    }else{
                                        cmp.set("v.current_N_TargetAlloc_check",false);
                                    }
                                }
                            }
                            
                            
                            
                            this.setClassinComponent(cmp);
                            
                            debugger;
                            this.togglesection(cmp,'_div_detail_pere');
                            if(flag == true){
                                //cmp.set("v.selectedfirmID",preqinid);					
                                this.updateAccountwithPreqinId(cmp,preqinid);
                            }else{
                                cmp.set("v.selectedfirmID",preqinid);
                            }
                            this.HideblurredImage(cmp);
                            
                        }
                    }else if(accountdetail.strStatus.includes('<@@>404')){
                        //alert('Preqin Account ID:'+preqinid+' is not found.');
                        this.showAlertError(cmp,'Error',accountdetail.strStatus.replace('<@@>404',''));
                        this.togglesection(cmp,'_div_detail_pere');
                        this.HideblurredImage(cmp);
                    }else{
                        //If Refresh token get expired
                        document.getElementById(globalId+'_div_refresh_pere').style.display = "block";
                        document.getElementById(globalId+'_div_detail_pere').style.display = "none";
                        this.HideblurredImage(cmp);
                        this.openPreqinloginWindow(cmp);
                    }
                }else{
                    this.showAlertError(cmp,'Error',accountdetail.strexcep);
                    this.togglesection(cmp,'_div_login_pere');
                }
            }else if (state === "ERROR") {
                if(errors) {
                    document.getElementById(globalId+'_div_login_pere').style.display = "block";
                    if(errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }else {
                        console.log("Unknown error");
                    }
                }
            }
        });
        $A.enqueueAction(action3);
        
        
    },
    
    //It will search the entered text and show the record in grid. 
    Incorrectprofile_gridhit : function(cmp,accname){
        debugger;
        this.showblurredImage(cmp);
		var globalId = cmp.getGlobalId();
        var action4 = cmp.get("c.getDatafromPreqin_accName"); 
        var setupRecid =cmp.get("v.setUprecId");
        var firmID = cmp.get("v.selectedfirmID");
        action4.setParams({
            accname : accname,
            setUprecId : setupRecid
        });
        action4.setCallback(this, function(res2){
            debugger;
            var firmList  = res2.getReturnValue();
            if(firmList.strexception == null || firmList.strexception == ''){
                ///If Refresh token not expire
                if(firmList.strFirmStatus == '' || firmList.strFirmStatus == null){
                    var firmdetails = firmList.firmNameWrapper;
                    document.getElementById(globalId+'_div_login_pere').style.display = "none";
                    document.getElementById(globalId+'_div_refresh_pere').style.display = "none";              
                    document.getElementById(globalId+'_div_detail_pere').style.display = "none"; 
					document.getElementById(globalId+'_div_grid_pere').style.display = "block"; 
					
					cmp.set("v.mydataPageCount", firmList.totalPageCount);
					cmp.set("v.alertforblanktext",false);
                    this.preqinFirmDataBinding(cmp,firmdetails,firmID);
                    this.HideblurredImage(cmp);
                    
                }else{
                    //If Refresh token get expired
                    document.getElementById(globalId+'_div_refresh_pere').style.display = "block";
                    document.getElementById(globalId+'_div_grid_pere').style.display = "none";
					this.HideblurredImage(cmp);
                    this.openPreqinloginWindow(cmp);
                }
            }else{
                this.showAlertError(cmp,'Error',firmList.strexception);
                this.HideblurredImage(cmp);
            }
        });
        $A.enqueueAction(action4);
        
        
    },
    
    showblurredImage : function(cmp){
        debugger;
        var showBtm = cmp.find('LoadingvfDIV_pere') ;       
        $A.util.removeClass(showBtm, 'slds-hide'); 
        
    },
    HideblurredImage : function(cmp){
        debugger;
        var showBtm = cmp.find('LoadingvfDIV_pere') ;       
        $A.util.addClass(showBtm, 'slds-hide'); 
    },
    
    preqinFirmDataBinding :function(component,firmdetails,firmID){
        debugger;
        
        var cwidth = component.find("col1_pere").getElement().clientWidth;
        console.log("screen size"+cwidth);
        var frmWidth = 330;
        var locWidth = 110;
        
        if(cwidth < 600 ){
            frmWidth=120;
            locWidth=90;
            
        }
        else if(cwidth > 600)
        {
            frmWidth=330;
            locWidth=150;
        }
            else if(cwidth > 1000 ){
                frmWidth=null;
                locWidth=null;
                
            }
                else if(cwidth > 1400 )
                {
                    frmWidth=null;
                    locWidth=null; 
                }
        
        component.set('v.mycolumns', [
            {type:'button', label: 'Action',fieldName: 'btnStatus',initialWidth:80, typeAttributes: { label:{fieldName: 'btnStatus'}, title:{fieldName: 'btnStatus'},variant:'base'}},
            {label: 'Name', fieldName: 'firmName', type: 'text', sortable:true},
            {label: 'Firm Type', fieldName: 'firmType', type: 'text', sortable:true},
            {label: 'Location', fieldName: 'location', type: 'text', sortable:true}]);  
        
        for(var i=0; i< firmdetails.length; i++) 
        { 
            if(firmdetails[i].firmID == firmID)
            {
                firmdetails[i].btnStatus='Selected';
            }
            else{
                firmdetails[i].btnStatus='Select';
            }
        } 
        component.set("v.mydata", firmdetails); 
        component.set("v.selectedRows", [firmID]);
        
    }, 
    showAlertError : function(component,errorheader,errormessage ) {
        debugger;
		var globalId = component.getGlobalId();
        this.HideblurredImage(component);
        document.getElementById(globalId+'_errorheader').innerHTML= errorheader;
        document.getElementById(globalId+'_errorbody').innerHTML = errormessage;
        document.getElementById(globalId+'_errorpopup').style.display = "block";
    },
    
    //call from js controller, to update the selected preqinId in Account
    updateAccountwithPreqinId : function(cmp,preqinId){
        debugger;
        //this.showblurredImage(cmp);
		var globalId = cmp.getGlobalId();
        var action4 = cmp.get("c.updateAccount"); 
        action4.setParams({
            accid : cmp.get("v.recordId"),
            preqinId : preqinId
        });
        action4.setCallback(this, function(res2){
            debugger;
            //this.showblurredImage(cmp);
            var messageStr = res2.getReturnValue();
            if(messageStr != null){
                this.showAlertError(cmp,'Error',messageStr.replace('Exception:',''));
                document.getElementById(globalId+'_div_grid_pere').style.display = "block"; 								
                document.getElementById(globalId+'_div_detail_pere').style.display = "none";
                cmp.set("v.selectedfirmID",'');
            }
            else{
                this.togglesection(cmp,'_div_detail_pere');
                cmp.set("v.selectedfirmID",preqinId);	
            }
            this.HideblurredImage(cmp);
        });
        
        $A.enqueueAction(action4);
    },
    
    //To toggle the div
    togglesection: function(cmp,divid){
        debugger;	
		var globalId = cmp.getGlobalId();
		try{
			
            document.getElementById(globalId+'_div_login_pere').style.display = "none";
            document.getElementById(globalId+'_div_refresh_pere').style.display = "none";
            document.getElementById(globalId+'_div_detail_pere').style.display = "none";
            document.getElementById(globalId+'_div_grid_pere').style.display = "none";
			document.getElementById(globalId+divid).style.display = "block";
			}
        catch(err)
        {
        }
        finally {
            document.getElementById(globalId+divid).style.display = "block";
        }
        
    },
    
    //To sort the search grid
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.mydata");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.mydata", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    setClassinComponent : function(component){
        debugger;
        //Other Office Section envelope size change according to component width length.
        var cwidth = component.find("col1_pere").getElement().clientWidth;
        console.log('width=other office='+cwidth);
        var width =  component.find("oneCol_pere");
        if(cwidth < "600" ){
            if($A.util.isObject(width))
                $A.util.addClass(width, 'col-xs-12 col-sm-12 col-md-12 col-lg-12');  
            for(var cmp in width) {
                $A.util.addClass(width[cmp], 'col-xs-12 col-sm-12 col-md-12 col-lg-12');  
            }
        }
        
        else if(cwidth < "1100" && cwidth > "600"){
            if($A.util.isObject(width))
                $A.util.addClass(width, 'col-xs-12 col-sm-6 col-md-6 col-lg-6');  
            for(var cmp in width) {
                $A.util.addClass(width[cmp], 'col-xs-12 col-sm-6 col-md-6 col-lg-6');  
                
            }
        }
        
            else if(cwidth > "1400"){
                if($A.util.isObject(width))
                    $A.util.addClass(width, 'col-xs-12 col-sm-12 col-md-3 col-lg-3');  
                for(var cmp in width) {
                    $A.util.addClass(width[cmp], 'col-xs-12 col-sm-12 col-md-3 col-lg-3');  
                    
                }
            }
        
                else{
                    if($A.util.isObject(width))
                        $A.util.addClass(width, 'col-xs-12 col-sm-12 col-md-3 col-lg-3');  
                    for(var cmp in width) {
                        $A.util.addClass(width[cmp], 'col-xs-12 col-sm-12 col-md-3 col-lg-3');  
                        
                    }
                }
        
        var cwidth2 = component.find("col1_pere").getElement().clientWidth;
        console.log('width=='+cwidth);
        var width2 =  component.find("oneCol2_pere");
        if(cwidth2 < "600" ){
            for(var cmp2 in width2) {
                $A.util.addClass(width2[cmp2], 'col-xs-12 col-sm-12 col-md-12 col-lg-12 padding-left-remove');
                
            }
        }
        else{
            for(var cmp2 in width2) {
                $A.util.addClass(width2[cmp2], 'col-xs-12 col-sm-12 col-md-6 col-lg-6');  
                
            }
        }
        
        debugger;
        //Contact Envelope size change according to component length.
        var cwidth4 = component.find("col1_pere").getElement().clientWidth;
        console.log('cwidth4=kj='+cwidth4);
        
        var width4 =  component.find("oneCol400_pere");
        console.log('width4=='+width4);
        
        
        if(cwidth4 < "650" ){
            if($A.util.isObject(width4))
                $A.util.addClass(width4, 'col-xs-12 col-sm-12 col-md-4 col-lg-12');
            for(var cmp4 in width4) {
                $A.util.addClass(width4[cmp4], 'col-xs-12 col-sm-12 col-md-12 col-lg-12');  
                
            }
        }			
        
        else if(cwidth4 >=  "650" && cwidth4 <= "1010"){
            if($A.util.isObject(width4))
                $A.util.addClass(width4, 'col-xs-12 col-sm-6 col-md-6 col-lg-6');  
            for(var cmp4 in width4) {
                $A.util.addClass(width4[cmp4], 'col-xs-12 col-sm-6 col-md-6 col-lg-6');  
                
            }
        }
            else if(cwidth4 > "1010" && cwidth4 < "1400"){
                if($A.util.isObject(width4))
                    $A.util.addClass(width4, 'col-xs-12 col-sm-12 col-md-4 col-lg-4');
                for(var cmp4 in width4) {
                    $A.util.addClass(width4[cmp4], 'col-xs-12 col-sm-12 col-md-4 col-lg-4');
                    
                }
            }
                else if(cwidth4 >= "1400"){	
                    if($A.util.isObject(width4))
                        $A.util.addClass(width4, 'col-xs-12 col-sm-12 col-md-3 col-lg-3');  
                    for(var cmp4 in width4) {
                        $A.util.addClass(width4[cmp4], 'col-xs-12 col-sm-12 col-md-3 col-lg-3');  
                        
                    }
                }    
        
        //Investor consultant
        var cwidth6 = component.find("col1_pere").getElement().clientWidth;
        console.log('width6=='+cwidth6);
        var width6 =  component.find("oneCol6_pere");
        
        if(cwidth6 < "600" ){
            if($A.util.isObject(width6))
                $A.util.addClass(width6, 'col-xs-12 col-sm-12 col-md-12 col-lg-12');
            for(var cmp6 in width6) {
                $A.util.addClass(width6[cmp6], 'col-xs-12 col-sm-12 col-md-12 col-lg-12');
                
            }
        }
        else if(cwidth6 >= "600" && cwidth6 <= "865"){
            if($A.util.isObject(width6))
                $A.util.addClass(width6, 'col-xs-12 col-sm-6 col-md-6 col-lg-6 '); 
            for(var cmp6 in width6) {
                $A.util.addClass(width6[cmp6], 'col-xs-12 col-sm-6 col-md-6 col-lg-6 '); 
            }
        }
            else if( cwidth6 > "865" && cwidth6 <= "1400"){
                if($A.util.isObject(width6))
                    $A.util.addClass(width6, 'col-xs-12 col-sm-4 col-md-4 col-lg-4 '); 
                for(var cmp6 in width6) {
                    $A.util.addClass(width6[cmp6], 'col-xs-12 col-sm-4 col-md-4 col-lg-4 '); 
                }
            }
                else{
                    if($A.util.isObject(width6))
                        $A.util.addClass(width6, 'col-xs-12 col-sm-6 col-md-3 col-lg-3 '); 
                    for(var cmp6 in width6) {
                        $A.util.addClass(width6[cmp6], 'col-xs-12 col-sm-6 col-md-3 col-lg-3 '); 
                    }
                }       
        
        
        //Search bar for 600 and more than 1400 pixels
        var cwidth1 = component.find("col1_pere").getElement().clientWidth;
        console.log('width1-kj=='+cwidth1);
        var width1 =  component.find("STPPDiv");
        if(cwidth1 < "600" ){
            $A.util.addClass(width1, 'col-xs-12 col-sm-12 col-md-12 col-lg-6');  
        }            
        else{
            $A.util.addClass(width1, 'col-xs-6 col-sm-6 col-md-6 col-lg-4');  
        }    
        
        
        //Adjust Asset and Allocation table in one independent row for the size of 1920*150 resolution
        var cwidth1 = component.find("col1_pere").getElement().clientWidth;
        console.log('width1-kj=='+cwidth1);
        var assetDivWidth =  component.find("assetDivId_pere");
        var allocationDivWidth =  component.find("allocationDivId_pere");
        if(cwidth1 < "700" ){
            $A.util.addClass(assetDivWidth, 'assetDivLessThan400');  
            $A.util.addClass(allocationDivWidth, 'allocationDivLessThan400');  
        }            
        else{
            $A.util.addClass(assetDivWidth, 'assetDivGreaterThan400');  
            $A.util.addClass(allocationDivWidth, 'allocationDivGreaterThan400');  
        } 
        
    }        
})