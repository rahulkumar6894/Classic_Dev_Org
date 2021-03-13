/*********************************************************************************
			** Module Name : Preqin PERE Javascript controller 
			** Description : To implement search functionality on Enter button and search  icon and implement Incorrect 'Click here' link functionality and call helper methods;
			** Revision History:-
			** Version   Date        Author        WO#   Description of Action
			** 1.2      02/07/2018  Kumar Jonson        
			
	*********************************************************************************/


({		
    //To open the preqin endpoint window to get login into this
    openPreqin: function (cmp, event, helper) {
        helper.openPreqinloginWindow(cmp);
    },
    
    //To set the component width and style, it will execute automatically after the script will get loaded(at the time when component get loaded)
    doInit1 : function(component, event, helper) {
        debugger;
         helper.doInitHelper(component,event);
        //helper.afterdoinit(component,event);
    },
    toggleCollapseShow_Div1 : function(component,event,helper ){
        debugger;
        helper.toggleCollapseShow_helper(component,'Show_Div1_pere','Hide_Div1_pere','ShoHide_Div1_pere');
    },
    toggleCollapseShow_Div2 : function(component,event,helper ){
        debugger;
        helper.toggleCollapseShow_helper(component,'Show_Div2_pere','Hide_Div2_pere','ShoHide_Div2_pere');
    },
    toggleCollapseShow_Div3 : function(component,event,helper ){
        debugger;
        helper.toggleCollapseShow_helper(component,'Show_Div3_pere','Hide_Div3_pere','ShoHide_Div3_pere');
    },
    OtherOfficeCollapseShow : function(component,event,helper ){
        debugger;
        helper.toggleCollapseShow_helper(component,'Show_Div_OtherOffices_pere','Hide_Div_OtherOffices_pere','ShoHide_Div_OtherOffices_pere');
    },
    //When we click on the Select link from the search grid
    getSelectedFirmData : function(cmp,event,helper){
        //debugger;
        
        var row = event.getParam('row');
        var selectedItem =row.firmID;
        var exstfirmId = cmp.get("v.selectedfirmID");
        if(selectedItem == exstfirmId){
            return null;
        }
        helper.showblurredImage(cmp);
        var action1 = cmp.get("c.getDatafromPreqin_preqinId"); 				//hit the preqin with Id
        
        action1.setParams({
            accPreqId : selectedItem
        });
        action1.setCallback(this, function(res){
			var globalId = cmp.getGlobalId();
            var state = res.getState();
            if(state === "SUCCESS"){
                
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
                alert('FFFF');
                if(accountdetail.strexcep == null || accountdetail.strexcep == ''){
                    if(accountdetail.strStatus == '' || accountdetail.strStatus == null){	
                        
                        if(accountdetail !=null && accountdetail != ''){
                            //To set the wrapperclass in component's wrappers variable.
                            cmp.set("v.wrappers",accountdetail);
                            
                            //To check weather it has any contact or not
                            var allcontact = accountdetail.contacts;
                            
                            //To check weather it has any contact or not
                            var nullcount = false;
                            var notnullcount = false;
                            if(accountdetail.contacts != null && accountdetail.contacts.length > 0){
                                var allcontact = accountdetail.contacts;
                                var flag = false;
                                
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
                            
                            
                            
                            helper.resetallSection(cmp);	
                            helper.setClassinComponent(cmp);
                            helper.updateAccountwithPreqinId(cmp,selectedItem);
                            
                            
                            
                        }//if close accountdetail
                    }else if(accountdetail.strStatus.includes('<@@>404')){
                        //alert('Preqin Account ID:'+preqinid+' is not found.');
                        helper.showAlertError(cmp,'Error',accountdetail.strStatus.replace('<@@>404',''));
                        helper.togglesection(cmp,'_div_grid_pere');
                        helper.HideblurredImage(cmp);
                    }else{
                        //If Refresh token get expired
						document.getElementById(globalId+'_div_refresh_pere').style.display='block'; 			
						document.getElementById(globalId+'_div_detail_pere').style.display='none'; 								
                        helper.HideblurredImage(cmp);
                        helper.openPreqinloginWindow(cmp);
                    }
                }else{
                    helper.showAlertError(cmp,'Error',accountdetail.strexcep);
                    
                }
            }else if (state === "ERROR") {
                if(errors) {
                    
					document.getElementById(globalId+'_div_login_pere').style.display='block'; 								
                    if(errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }else {
                        console.log("Unknown error");
                    }
                }
            }
        });
        $A.enqueueAction(action1);
        
    },
    
    
    //Enter event of search grid. Call the method to search the entered text and display in grid
    getEnterKeyEvent : function(cmp,event,helper){
        debugger;
        console.log('event.keyCode='+event);
        if(event.keyCode == 13 ){
            
            
            var searchValue = cmp.find("investorSearchtext_pere").get("v.value");
            console.log('=comp'+searchValue);
            
            var searchtext = searchValue;
            if( searchtext != null &&  searchtext != '' && searchtext != undefined){
                cmp.set("v.alertforblanktext",false);
                helper.showblurredImage(cmp);
                helper.Incorrectprofile_gridhit(cmp,searchtext);
            }else{
                cmp.set("v.alertforblanktext",true);
                helper.HideblurredImage(cmp);
            }
            
        }
        
    },
    
    //call on Logout button: It will set null to navatar setup Access token and Refresh token field. 
    LogoutclearSetUpRecord : function(cmp,event,helper){
        debugger;
        helper.showblurredImage(cmp);
        var action3 = cmp.get("c.updateSetupRecord");
        action3.setParams({
            setUprecId : cmp.get("v.setUprecId")
        });
        action3.setCallback(this, function(res){
            var state = res.getState();
            if (state === "SUCCESS") {
                var resp = res.getReturnValue();
                if(resp != null || resp != ''){
                    helper.togglesection(cmp,'_div_login_pere');
                }else{
                    helper.showAlertError(cmp,'Error',resp.replace('Exception:',''));
                }
            }
            helper.HideblurredImage(cmp);
        });
        $A.enqueueAction(action3);
    },
    
    //Sorting
    updateColumnSorting: function (cmp, event, helper) {
        debugger;
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    //Search Image onclick event of search grid. Call the method to search the entered text and display in grid
    searchFirmInfo: function(cmp,event,helper){
        debugger;    
        helper.showblurredImage(cmp);
        var searchValue = cmp.find("investorSearchtext_pere").get("v.value");
        console.log('=comp'+searchValue);
        
        var searchtext = searchValue;
        
        if(searchtext != '' || searchtext!= ''){
            if(searchtext != undefined ){
                helper.Incorrectprofile_gridhit(cmp,searchtext);
                cmp.set("v.alertforblanktext",false);
            }else{
                helper.HideblurredImage(cmp);
            }
        }else{
            cmp.set("v.alertforblanktext",true);
            helper.HideblurredImage(cmp);
        }
        
    },
    
    //It will get call on clicking on 'Click here' link from div_c
    showgridforIncorectprofile: function(cmp,event,helper){
        
		debugger;
		helper.showblurredImage(cmp);
		var action = cmp.get("c.getAccountdetails"); 
        var preqid='' ;
        var accname='';
        action.setParams({
            accId : cmp.get("v.recordId")
        });
        action.setCallback(this, function(res){
            debugger;
			var state = res.getState();
            
			if (state === "SUCCESS") {
                debugger;
                var accountMap  = res.getReturnValue();
                var accvalue = JSON.parse(accountMap);
                accname  = accvalue.accname;
                cmp.set("v.firmname",accname);
                if(accvalue.Exception != null || accvalue.Exception != ''){
                    preqid = accvalue.preqinid;
                    accname  = accvalue.accname;
                    cmp.set("v.firmname",accname);
                    if(accname != null && accname != ''){
                        console.log('@@@'+accname);
                        helper.Incorrectprofile_gridhit(cmp,accname);
                    }
                }else{
                    helper.showAlertError(cmp,'Error',accvalue.Exception);
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
    hideErrorPopUp : function(component){
		var globalId = component.getGlobalId();
        document.getElementById(globalId+'_errorpopup').style.display = "none";
        document.getElementById(globalId+'_errorheader').innerHTML= '';
        document.getElementById(globalId+'_errorbody').innerHTML = '';
    },
    
})