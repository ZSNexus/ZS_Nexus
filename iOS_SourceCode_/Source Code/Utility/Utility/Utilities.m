//
//  Utilities.m
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 12/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#import "Utilities.h"
#import "CustomerObject.h"
#import "AddressObject.h"
#import "OrganizationObject.h"
#import "RequestStatusHistoryObject.h"
#import "RequestObject.h"
#import "DatabaseManager.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "GTMStringEncoding.h"
#import "DealignBPA.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation Utilities

{}
#pragma mark - Parse JSON response
+(BOOL)parseJsonLoginUserDetails:(NSDictionary *)jsonDataObject
{
    BOOL status=FALSE;
    @try {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *hoUser =[jsonDataObject objectForKey:@"ho_user"];
        //Parsing for HO User
        if ([hoUser isEqualToString:@"Y"]) {
            
            NSMutableDictionary * loggedInHoUserData=[[NSMutableDictionary alloc]init];
            if([jsonDataObject objectForKey:@"hoUser_RemoveMessage"]!=nil)
            {
                [defaults setObject:[jsonDataObject objectForKey:@"hoUser_RemoveMessage"] forKey:REMOVE_MESSAGE_KEY];
            }
            if([jsonDataObject objectForKey:@"hoUser_RequestMessage"]!=nil)
            {
                [defaults setObject:[jsonDataObject objectForKey:@"hoUser_RequestMessage"] forKey:REQUEST_MESSAGE_KEY];
            }
            if([jsonDataObject objectForKey:@"hoUser_SearchMessage"]!=nil)
            {
                [defaults setObject:[jsonDataObject objectForKey:@"hoUser_SearchMessage"] forKey:SEARCH_MESSAGE_KEY];
            }
            if([jsonDataObject objectForKey:@"hoUser_TargetMessage"]!=nil)
            {
                [defaults setObject:[jsonDataObject objectForKey:@"hoUser_TargetMessage"] forKey:TARGET_MESSAGE_KEY];
            }
            
            if([jsonDataObject objectForKey:@"full_name"]!=nil)
            {
                [loggedInHoUserData setObject:[jsonDataObject objectForKey:@"full_name"] forKey:@"FullName"];
                [defaults setObject:[jsonDataObject objectForKey:@"full_name"] forKey:@"FullName"];
            }
            if([jsonDataObject objectForKey:@"login_name"]!=nil)
            {
                [loggedInHoUserData setObject:[jsonDataObject objectForKey:@"login_name"] forKey:@"LoginName"];
                [defaults setObject:[jsonDataObject objectForKey:@"login_name"] forKey:@"LoginName"];
            }
            if([jsonDataObject objectForKey:@"token"]!=nil)
            {
                [loggedInHoUserData setObject:[jsonDataObject objectForKey:@"token"] forKey:@"NexusServerToken"];
                [defaults setObject:[jsonDataObject objectForKey:@"token"] forKey:@"hoUserToken"];

            }
            if([jsonDataObject objectForKey:@"personnel_id"]!=nil)
            {
                [loggedInHoUserData setObject:[jsonDataObject objectForKey:@"personnel_id"] forKey:@"PersonalId"];
                [defaults setObject:[jsonDataObject objectForKey:@"personnel_id"] forKey:@"personalid"];
            }
            
            //get bu data
            NSMutableArray *buNameArray = [[NSMutableArray alloc]init];
            NSMutableArray *buCodeArray = [[NSMutableArray alloc]init];
            NSMutableArray *teamNameArray;
            NSMutableArray *teamCodeArray;
            NSMutableArray *teamCodeNameArray;
            NSMutableArray *terriotaryNameArray;
            NSMutableArray *terriotaryCodeArray;

            NSMutableDictionary *buTeamDict = [[NSMutableDictionary alloc]init];
            NSMutableDictionary *teamTerriotaryDict = [[NSMutableDictionary alloc]init];
            
            for(NSDictionary * buObj in [[jsonDataObject objectForKey:@"hoUser"] objectForKey:@"bu"])
            {
                [buCodeArray addObject:[buObj objectForKey:@"buCode"]];
                [buNameArray addObject:[buObj objectForKey:@"buName"]];// added bu details
               
                teamNameArray = [[NSMutableArray alloc]init];
                teamCodeArray = [[NSMutableArray alloc]init];
                teamCodeNameArray = [[NSMutableArray alloc]init];

                NSArray *tempTeamArray = [buObj objectForKey:@"team"];
                for (NSDictionary *teamObj in tempTeamArray) {
                    [teamCodeArray addObject:[teamObj objectForKey:@"teamCode"]];
                    [teamNameArray addObject:[teamObj objectForKey:@"teamName"]];
                    [teamCodeNameArray addObject:[NSString stringWithFormat:@"%@-%@",[teamObj objectForKey:@"teamCode"],[teamObj objectForKey:@"teamName"]]];
                    terriotaryNameArray = [[NSMutableArray alloc]init];
                    terriotaryCodeArray = [[NSMutableArray alloc]init];
                    
                    [buTeamDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:teamCodeArray, @"teamId", teamNameArray, @"teamName", nil] forKey:[buObj objectForKey:@"buCode"]];
                    [buTeamDict setObject:teamCodeNameArray forKey:@"teamCodeName"];

                    NSArray *teamTerrArray = [teamObj objectForKey:@"terr"];
                    
                    for (NSDictionary *terriotaryObj in teamTerrArray) {
                        [terriotaryCodeArray addObject:[terriotaryObj objectForKey:@"sfOrgUnitId"]];
                        [terriotaryNameArray addObject:[terriotaryObj objectForKey:@"sfOrgUnitName"]];
                        
                        [teamTerriotaryDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:terriotaryCodeArray, @"terrId", terriotaryNameArray, @"terrName", nil] forKey:[teamObj objectForKey:@"teamCode"]];

                    }
                }
            }
            [loggedInHoUserData setObject:buCodeArray forKey:@"hoBuCodeDataArray"];
            [loggedInHoUserData setObject:buNameArray forKey:@"hoBuNameDataArray"];
            [loggedInHoUserData setObject:buTeamDict forKey:@"buTeamDataDict"];
            [loggedInHoUserData setObject:teamTerriotaryDict forKey:@"teamTerrDataDict"];

            [defaults setObject:buNameArray forKey:@"hoBuNameDataArray"];
            [defaults setObject:buCodeArray forKey:@"hoBuCodeDataArray"];
            
            [defaults setObject:buTeamDict forKey:@"buTeamDataDict"];
            [defaults setObject:teamTerriotaryDict forKey:@"teamTerrDataDict"];
            
            [defaults setObject:loggedInHoUserData forKey:@"LoggedInUser"];
            
        }
        else//Parsing for rep User
        {
            NSMutableDictionary * loggedInUser=[[NSMutableDictionary alloc]init];
            Boolean  statusObj=(Boolean)[jsonDataObject objectForKey:@"status"];
            if(!statusObj)
            {
                if([jsonDataObject objectForKey:@"full_name"]!=nil)
                {
                    [loggedInUser setObject:[jsonDataObject objectForKey:@"full_name"] forKey:@"FullName"];
                }
                if([jsonDataObject objectForKey:@"login_name"]!=nil)
                {
                    [loggedInUser setObject:[jsonDataObject objectForKey:@"login_name"] forKey:@"LoginName"];
                }
                if([jsonDataObject objectForKey:@"token"]!=nil)
                {
                    [loggedInUser setObject:[jsonDataObject objectForKey:@"token"] forKey:@"NexusServerToken"];
                }
                if([jsonDataObject objectForKey:@"personnel_id"]!=nil)
                {
                    [loggedInUser setObject:[jsonDataObject objectForKey:@"personnel_id"] forKey:@"PersonalId"];
                }
                
                if([jsonDataObject objectForKey:@"roles"]!=nil)
                {
                    if([[jsonDataObject objectForKey:@"roles"] count]==1)
                    {
                        [defaults setObject:@"1" forKey:@"NoOfRoles"];
                    }
                    else
                    {
                        [defaults setObject:[NSString stringWithFormat:@"%ul",(unsigned)[[jsonDataObject objectForKey:@"roles"] count] ] forKey:@"NoOfRoles"];
                    }
                    NSMutableDictionary * territoriesAndRolesDict=[[NSMutableDictionary alloc]init];
                    for(NSDictionary * roleObj in [jsonDataObject objectForKey:@"roles"])
                    {
                        NSMutableDictionary * terrRoleObj1 = [[NSMutableDictionary alloc] init];
                        
                        
                        
                        if ([roleObj objectForKey:@"TR_ENBLE_FLAG"]) {
                            [terrRoleObj1 setObject:[roleObj objectForKey:@"TR_ENBLE_FLAG"] forKey:@"TargetFlag"];
//                            [defaults setObject:[roleObj objectForKey:@"TR_ENBLE_FLAG"] forKey:@"TargetFlag"];
                        }
                        
                        if([roleObj objectForKey:@"role_id"])
                        {
                            [terrRoleObj1 setObject:[roleObj objectForKey:@"role_id"] forKey:@"RoleId"];
                        }
                        
                        if([roleObj objectForKey:@"role_nm"])
                        {
                            [terrRoleObj1 setObject:[roleObj objectForKey:@"role_nm"] forKey:@"RoleName"];
                        }
                        
                        if([roleObj objectForKey:@"terr_nm"])
                        {
                            [terrRoleObj1 setObject:[roleObj objectForKey:@"terr_nm"] forKey:@"TerritoryName"];
                        }
                        
                        if([roleObj objectForKey:@"team_id"])
                        {
                            [terrRoleObj1 setObject:[roleObj objectForKey:@"team_id"] forKey:@"teamId"];
                        }
                        
                        if([roleObj objectForKey:@"ex_addr_usg_type"])
                        {
                            [terrRoleObj1 setObject:[NSArray arrayWithArray:[[[roleObj objectForKey:@"ex_addr_usg_type"] uppercaseString] componentsSeparatedByString:@","]] forKey:@"excludedAddrUsgType"];
                        }
                        
                        if([roleObj objectForKey:@"bp_clsfn_inc"])
                        {
                            [terrRoleObj1 setObject:[NSArray arrayWithArray:[[[roleObj objectForKey:@"bp_clsfn_inc"] uppercaseString] componentsSeparatedByString:@","]] forKey:@"includedBpClassificationType"];
                        }
                        
                        //If role count is one than set that as default selected
                        if([[defaults objectForKey:@"NoOfRoles"] isEqualToString:@"1"])
                        {
                            [defaults setObject:[roleObj objectForKey:@"ter_id"] forKey:@"SelectedTerritoryId"];
                            [defaults setObject:[roleObj objectForKey:@"terr_nm"] forKey:SELECTED_TERRITTORY_NAME];
                            //Set Role Id for role - Can be changed in future
                            [defaults setObject:[roleObj objectForKey:@"role_id"] forKey:@"Role"];
                            [defaults setObject:[roleObj objectForKey:@"team_id"] forKey:@"SelectedTeamId"];
                            
                            //Excluded address usage type
                            if([roleObj objectForKey:@"ex_addr_usg_type"])
                            {
                                [defaults setObject:[NSArray arrayWithArray:[[[roleObj objectForKey:@"ex_addr_usg_type"] uppercaseString] componentsSeparatedByString:@","]] forKey:@"SelectedRoleExcludedAddrUsgType"];
                            }
                            else
                            {
                                [defaults removeObjectForKey:@"SelectedRoleExcludedAddrUsgType"];
                            }
                            
                            //Inclusion bp classification
                            if([roleObj objectForKey:@"bp_clsfn_inc"])
                            {
                                [defaults setObject:[NSArray arrayWithArray:[[[roleObj objectForKey:@"bp_clsfn_inc"] uppercaseString] componentsSeparatedByString:@","]] forKey:@"SelectedRoleIncludedBpClassificationType"];
                            }
                            else
                            {
                                [defaults removeObjectForKey:@"SelectedRoleIncludedBpClassificationType"];
                            }
                            
                            //User roles
                            if([[defaults objectForKey:@"Role"] isEqualToString:USER_ROLE_ID_MA] || [[defaults objectForKey:@"Role"] isEqualToString:USER_ROLE_ID_MSL])
                            {
                                [defaults setObject:USER_ROLE_MA_MSL forKey:USER_ROLES_KEY];
                            }
                            else
                            {
                                [defaults setObject:USER_ROLE_SALES_REP forKey:USER_ROLES_KEY];
                            }
                        }
                        
                        if ([roleObj objectForKey:@"add_rmv_disbl_flag"]) {
                            [terrRoleObj1 setObject:[roleObj objectForKey:@"add_rmv_disbl_flag"] forKey:TERRIOTARY_ONOFF_KEY];
                        }
                        if ([roleObj objectForKey:@"add_disbl_msg"]) {
                            [terrRoleObj1 setObject:[roleObj objectForKey:@"add_disbl_msg"] forKey:ADD_ONOFF_ERROR_KEY];
                        }
                        if ([roleObj objectForKey:@"rem_disbl_msg"]) {
                            [terrRoleObj1 setObject:[roleObj objectForKey:@"rem_disbl_msg"] forKey:REMOVE_ONOFF_ERROR_KEY];
                        }
                        
                        [territoriesAndRolesDict setObject:terrRoleObj1 forKey:[roleObj objectForKey:@"ter_id"]];
                        [defaults setObject:territoriesAndRolesDict forKey:ADD_REMOVE_USER_DEFAULT_KEY];
                    }
                    [loggedInUser setObject:territoriesAndRolesDict forKey:@"TerritoriesAndRoles"];
                    [defaults setObject:loggedInUser forKey:@"LoggedInUser"];
                    status=TRUE;
                }
            }
            else
            {
                
                NSString * reasonCode=[jsonDataObject objectForKey:@"reasonCode"];
                ErrorLog(@"Error - parseJsonLoginUserDetails  Parsing json  : %@",reasonCode);
                
            }
        }
        // else req data
    }
    @catch (NSException *exception) {
        ErrorLog(@"Error - parseJsonLoginUserDetails  Parsing json  : %@",exception);
    }
    return status;
}

//Json parser based on the selection of Business unit, Team and Terriotary
+(BOOL)parseHOUserJsonLoginUserDetails:(NSDictionary *)jsonDataObject
{
    BOOL status=FALSE;
    @try {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary * loggedInUser=[[NSMutableDictionary alloc]init];
                if([defaults objectForKey:@"FullName"]!=nil)
                {
                    [loggedInUser setObject:[defaults objectForKey:@"FullName"] forKey:@"FullName"];
                }
                if([defaults objectForKey:@"LoginName"]!=nil)
                {
                    [loggedInUser setObject:[defaults objectForKey:@"LoginName"] forKey:@"LoginName"];
                }
                if([defaults objectForKey:@"hoUserToken"]!=nil)
                {
                    [loggedInUser setObject:[defaults objectForKey:@"hoUserToken"] forKey:@"NexusServerToken"];
                }
                if([defaults objectForKey:@"personalid"]!=nil)
                {
                    [loggedInUser setObject:[defaults objectForKey:@"personalid"] forKey:@"PersonalId"];
                }
        
                if([jsonDataObject objectForKey:@"roles"]!=nil)
                {
                    if([[jsonDataObject objectForKey:@"roles"] count]==1)
                    {
                        [defaults setObject:@"1" forKey:@"NoOfRoles"];
                    }
                    else
                    {
                        [defaults setObject:[NSString stringWithFormat:@"%ul",(unsigned)[[jsonDataObject objectForKey:@"roles"] count] ] forKey:@"NoOfRoles"];
                    }
                }
                    NSMutableDictionary * territoriesAndRolesDict=[[NSMutableDictionary alloc]init];
                    for(NSDictionary * roleObj in [jsonDataObject objectForKey:@"roles"])
                    {
                        NSMutableDictionary * terrRoleObj1 = [[NSMutableDictionary alloc] init];
                        
                        if ([roleObj objectForKey:@"TR_ENBLE_FLAG"]) {
                            [terrRoleObj1 setObject:[roleObj objectForKey:@"TR_ENBLE_FLAG"] forKey:@"TargetFlag"];
//                            [defaults setObject:[roleObj objectForKey:@"TR_ENBLE_FLAG"] forKey:@"TargetFlag"];
                        }
                        
                        if([roleObj objectForKey:@"role_id"])
                        {
                            [terrRoleObj1 setObject:[roleObj objectForKey:@"role_id"] forKey:@"RoleId"];
                        }
                        
                        if([roleObj objectForKey:@"role_nm"])
                        {
                            [terrRoleObj1 setObject:[roleObj objectForKey:@"role_nm"] forKey:@"RoleName"];
                        }
                        
                        if([roleObj objectForKey:@"terr_nm"])
                        {
                            [terrRoleObj1 setObject:[roleObj objectForKey:@"terr_nm"] forKey:@"TerritoryName"];
                        }
                        
                        if([roleObj objectForKey:@"team_id"])
                        {
                            [terrRoleObj1 setObject:[roleObj objectForKey:@"team_id"] forKey:@"teamId"];
                        }
                        
                        if([roleObj objectForKey:@"ex_addr_usg_type"])
                        {
                            [terrRoleObj1 setObject:[NSArray arrayWithArray:[[[roleObj objectForKey:@"ex_addr_usg_type"] uppercaseString] componentsSeparatedByString:@","]] forKey:@"excludedAddrUsgType"];
                        }
                        
                        if([roleObj objectForKey:@"bp_clsfn_inc"])
                        {
                            [terrRoleObj1 setObject:[NSArray arrayWithArray:[[[roleObj objectForKey:@"bp_clsfn_inc"] uppercaseString] componentsSeparatedByString:@","]] forKey:@"includedBpClassificationType"];
                        }
                        
                        if ([roleObj objectForKey:@"add_rmv_disbl_flag"]) {
                            [terrRoleObj1 setObject:[roleObj objectForKey:@"add_rmv_disbl_flag"] forKey:TERRIOTARY_ONOFF_KEY];
                        }
                        if ([roleObj objectForKey:@"add_disbl_msg"]) {
                            [terrRoleObj1 setObject:[roleObj objectForKey:@"add_disbl_msg"] forKey:ADD_ONOFF_ERROR_KEY];
                        }
                        if ([roleObj objectForKey:@"rem_disbl_msg"]) {
                            [terrRoleObj1 setObject:[roleObj objectForKey:@"rem_disbl_msg"] forKey:REMOVE_ONOFF_ERROR_KEY];
                        }
                        
                        [territoriesAndRolesDict setObject:terrRoleObj1 forKey:[roleObj objectForKey:@"ter_id"]];
                        [defaults setObject:territoriesAndRolesDict forKey:ADD_REMOVE_USER_DEFAULT_KEY];
                    }
                    [loggedInUser setObject:territoriesAndRolesDict forKey:@"TerritoriesAndRoles"];
                    [defaults setObject:loggedInUser forKey:@"LoggedInUser"];
                    status=TRUE;
    }
    @catch (NSException *exception) {
        ErrorLog(@"Error - parseJsonLoginUserDetails  Parsing json  : %@",exception);
    }
    return status;
}

+(NSArray *)parseJsonSearchIndividual:(NSArray *)jsonDataArrayOfObjects
{
    NSMutableArray * searchedCustomerArray=[[NSMutableArray alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    @try {
        if(jsonDataArrayOfObjects!=nil && [jsonDataArrayOfObjects count]>0)
        {
            NSDictionary *   statusObj=[jsonDataArrayOfObjects objectAtIndex:0];
            
            NSString *status = [[statusObj objectForKey:@"status"] lowercaseString];
            
            if([status isEqualToString:LOGOUT_KEY])
            {
                [Utilities displayErrorAlertWithTitle:SESSION_EXPIRED andErrorMessage:[statusObj objectForKey:@"reasonCode"] withDelegate:nil];
                return nil;
            }
            else if(![status isEqualToString:@"failure"])
            {
                for(NSDictionary * customer in jsonDataArrayOfObjects)
                {
                    CustomerObject* cust=[[CustomerObject alloc]init];
                    //For "Add to terriotary" set isHoUser flag based on HO User.
                    if ([[defaults objectForKey:HO_USER] isEqualToString:@"Y"]) {
                        [cust setIsHoUser:@"Y"];
                    }
                    else
                        [cust setIsHoUser:@"N"];
                    
                    if([customer objectForKey:@"SALU_TXT"] !=nil && [[customer objectForKey:@"SALU_TXT"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                    {
                        [cust setCustTitle:[[customer objectForKey:@"SALU_TXT"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    }
                    
                    if([customer objectForKey:@"FRST_NM"] !=nil && [[customer objectForKey:@"FRST_NM"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                    {
                        [cust setCustFirstName:[[customer objectForKey:@"FRST_NM"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    }
                    
                    if([customer objectForKey:@"MIDL_NM"] !=nil && [[customer objectForKey:@"MIDL_NM"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                    {
                        [cust setCustMiddleName:[[customer objectForKey:@"MIDL_NM"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    }
                    
                    if([customer objectForKey:@"LAST_NM"] !=nil && [[customer objectForKey:@"LAST_NM"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                    {
                        [cust setCustLastName:[[customer objectForKey:@"LAST_NM"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    }
                    //modified ATTR_1 
                    if([customer objectForKey:@"ATTR_1"] !=nil && [[customer objectForKey:@"ATTR_1"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length && !([[NSString stringWithFormat:@"%d",[[customer objectForKey:@"ATTR_1"] intValue]] isEqualToString:@"99"]))
                    {
                        [cust setCustAttr1:[[customer objectForKey:@"ATTR_1"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    }
                    if([customer objectForKey:@"ATTR_2"] !=nil && [[customer objectForKey:@"ATTR_2"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                    {
                        [cust setCustAttr2:[[customer objectForKey:@"ATTR_2"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    }
                    if([customer objectForKey:@"ATTR_3"] !=nil && [[customer objectForKey:@"ATTR_3"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                    {
                        [cust setCustAttr3:[[customer objectForKey:@"ATTR_3"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    }
                    if([customer objectForKey:@"ATTR_4"] !=nil && [[customer objectForKey:@"ATTR_4"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                    {
                        [cust setCustAttr4:[[customer objectForKey:@"ATTR_4"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    }
                    if([customer objectForKey:@"ATTR_5"] !=nil && [[customer objectForKey:@"ATTR_5"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                    {
                        [cust setCustAttr5:[[customer objectForKey:@"ATTR_5"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    }
                    if([customer objectForKey:@"CUST_SFX_TXT"] !=nil && [[customer objectForKey:@"CUST_SFX_TXT"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                    {
                        [cust setCustSuffix:[[customer objectForKey:@"CUST_SFX_TXT"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    }
                    
                    if(([[customer objectForKey:@"PENDING"] integerValue]==0) || ([[customer objectForKey:@"PENDING"] integerValue]==1))
                    {
                        [cust setPendingCustRemovalReq:[[customer objectForKey:@"PENDING"] integerValue]];
                    }
                    
                    if(([customer objectForKey:@"isPendingText"]!= nil) && !([[customer objectForKey:@"isPendingText"] isEqualToString:@"(null)"] ))
                    {
                        [cust setIsPendingText:[customer objectForKey:@"isPendingText"]];
                    }
                    
                    if([customer objectForKey:@"PENDING_BPA_ID"]!=nil && [[customer objectForKey:@"PENDING_BPA_ID"] count])
                    {
                        [cust setPendingCustBpaIds:[NSMutableArray arrayWithArray:[customer objectForKey:@"PENDING_BPA_ID"]]];
                    }
                    
                    if([customer objectForKey:@"pendingBpaTexts"]!=nil && ([[customer objectForKey:@"pendingBpaTexts"] count]>0))
                    {
                        [cust setPendingBpaTexts:[NSMutableArray arrayWithArray:[customer objectForKey:@"pendingBpaTexts"]]];
                    }
                    
                    if(![[NSString stringWithFormat:@"%d",[[customer objectForKey:@"BP_ID"] intValue]] isEqualToString:@"-1"])
                    {
                        [cust setCustBPID:[customer objectForKey:@"BP_ID"]];
                    }
                    //Bug 467: Show blank NPI, if received NPI is -5
                    if((![[NSString stringWithFormat:@"%d",[[customer objectForKey:@"NPI_NUM"] intValue]] isEqualToString:@"-1"]) && (![[NSString stringWithFormat:@"%d",[[customer objectForKey:@"NPI_NUM"] intValue]] isEqualToString:@"-5"]))
                    {
                        [cust setCustNPI:[customer objectForKey:@"NPI_NUM"]];
                    }
                    
                    if(![[NSString stringWithFormat:@"%d",[[customer objectForKey:@"PRIMARY_SPECIALTY_CD"] intValue]] isEqualToString:@"99"])
                    {
                        [cust setCustPrimarySpecialtyCode:[[customer objectForKey:@"PRIMARY_SPECIALTY_CD"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    }
                    
                    [cust setCustPrimarySpecialty:[[customer objectForKey:@"PRIMARY_SPECIALTY_NM"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    
                    if(![[NSString stringWithFormat:@"%d",[[customer objectForKey:@"SECONDARY_SPECIALTY_CD"] intValue]] isEqualToString:@"99"])
                    {
                        [cust setCustSecondarySpecialtyCode:[[customer objectForKey:@"SECONDARY_SPECIALTY_CD"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    }
                    
                    [cust setCustSecondarySpecialty:[[customer objectForKey:@"SECONDARY_SPECIALTY_NM"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];

                    if([customer objectForKey:@"PFSNL_DGNTN_CD"] !=nil && [[customer objectForKey:@"PFSNL_DGNTN_CD"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length){
                        [cust setCustProfessionalDesignation:[[customer objectForKey:@"PFSNL_DGNTN_CD"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    }

                    if([customer objectForKey:@"PFSNL_DGNTN_NM"] !=nil && [[customer objectForKey:@"PFSNL_DGNTN_NM"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length){
                        [cust setCustProfessionalDesignationName:[[customer objectForKey:@"PFSNL_DGNTN_NM"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    }

                    [cust setCustType:[[customer objectForKey:@"BP_CLSFN_CD"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    [cust setCustValidationStatus:[customer objectForKey:@"VALDN_STA_CD"]];
                    
                    
                    
                    //Address array Parsing
                    NSMutableArray* addressArray=[[NSMutableArray alloc]init];
                    NSArray *addressLineOneArray = [customer objectForKey:@"ADDR_LINE_1"];
                    NSArray *addressLineTwoArray = [customer objectForKey:@"ADDR_LINE_2"];
                    
                    NSArray * city_id= [customer objectForKey:@"CITY_CD"];
                    NSArray * state_id= [customer objectForKey:@"STATE_CD"];
                    NSArray * zip_info= [customer objectForKey:@"ZIP_CD"];
                    NSArray * addr_usage_type= [customer objectForKey:@"ADDR_USAG_TYPE_CD"];
                    NSArray *bpa_id=[customer objectForKey:@"BPA_ID"];
                    NSArray *approvalFlag = [customer objectForKey:@"APPROVAL_FLG"];
                    NSArray * targetId = [customer objectForKey:@"TARGET_ID"];
                    
                    NSString *approvedFlg = @"NA";
                    if([approvalFlag containsObject:approvedFlg])
                    {
                        [cust setApprovalFlag:@"N"];
                    }

                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSDictionary *searchParamState = [defaults objectForKey:@"searchParamState"];
                    // there are five quicksearch types: BP Id, NPI, Individual Name, Organization Name
                    NSString *quickSearchType = [defaults objectForKey:@"quickSearchType"];
                    
                    if([quickSearchType isEqualToString:INDV_NAME_QUICK_SEARCH] || [quickSearchType isEqualToString:INDV_REMOVE_SEARCH] || [quickSearchType isEqualToString:INDV_ADVANCED_SEARCH])
                    { // prepare an address arress pertaining to the Sate selected while searching
                        
                        for (int i=0; i<[state_id count]; i++)
                        {
                            if(([[[[customer objectForKey:@"BPA_ACTV_FLAG"] objectAtIndex:i] lowercaseString] isEqualToString:@"y"]  || [quickSearchType isEqualToString:INDV_REMOVE_SEARCH]))
                            {
                                //Check for Empty address usage type only for solr search result
                                if([quickSearchType isEqualToString:INDV_REMOVE_SEARCH] || (([addr_usage_type objectAtIndex:i] != [NSNull null]) && [[addr_usage_type objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length !=0))
                                {
                                    //Filter only address for given State
                                    //[bldg][Space][Street][space][Suite]
                                    //Note: If Suite is NULL then remove [space] after [Street]
                                    if([quickSearchType isEqualToString:INDV_REMOVE_SEARCH] || [[[state_id objectAtIndex:i] lowercaseString] isEqualToString:[[searchParamState objectForKey:STATE_KEY] lowercaseString]])
                                    {
                                        if([quickSearchType isEqualToString:INDV_REMOVE_SEARCH] || ![searchParamState objectForKey:CITY_KEY] || [[[city_id objectAtIndex:i] lowercaseString] isEqualToString:[[searchParamState objectForKey:CITY_KEY] lowercaseString]])
                                        {
                                            
                                            if([quickSearchType isEqualToString:INDV_REMOVE_SEARCH] || ![searchParamState objectForKey:ZIP_KEY] || [[[zip_info objectAtIndex:i] lowercaseString] isEqualToString:[[searchParamState objectForKey:ZIP_KEY] lowercaseString]])
                                            {
                                                if([quickSearchType isEqualToString:INDV_REMOVE_SEARCH] || ![searchParamState objectForKey:ADDRESS_USAGE_KEY] || [[[addr_usage_type objectAtIndex:i]componentsSeparatedByString:@","] containsObject:[searchParamState objectForKey:ADDRESS_USAGE_KEY]])
                                                {
                                                    AddressObject * addressObj=[[AddressObject alloc]init];
                                                    //Set Address Line One
                                                    if([addressLineOneArray objectAtIndex:i]!=nil  && [addressLineOneArray objectAtIndex:i]!=[NSNull null] && [[addressLineOneArray objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
                                                    {
                                                        [addressObj setAddressLineOne:[addressLineOneArray objectAtIndex:i]];
                                                    }
                                                    
                                                    //Set Address Line Two
                                                    if([addressLineTwoArray objectAtIndex:i]!=nil  && [addressLineTwoArray objectAtIndex:i]!=[NSNull null] && [[addressLineTwoArray objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
                                                    {
                                                        [addressObj setAddressLineTwo:[addressLineTwoArray objectAtIndex:i]];
                                                    }
                                                    
                                                    //Set City
                                                    if([city_id objectAtIndex:i]!=nil  && [city_id objectAtIndex:i]!=[NSNull null] && ![[city_id objectAtIndex:i] isEqualToString:@" "])
                                                    {
                                                        [addressObj setCity:[city_id objectAtIndex:i]];
                                                    }
                                                    
                                                    //Set State
                                                    if([state_id objectAtIndex:i]!=nil  && [state_id objectAtIndex:i]!=[NSNull null] && ![[state_id objectAtIndex:i] isEqualToString:@" "])
                                                    {
                                                        [addressObj setState:[state_id objectAtIndex:i]];
                                                    }
                                                    
                                                    //Set Zip
                                                    if([zip_info objectAtIndex:i]!=nil  && [zip_info objectAtIndex:i]!=[NSNull null] && ![[zip_info objectAtIndex:i] isEqualToString:@" "])
                                                    {
                                                        [addressObj setZip:[zip_info objectAtIndex:i]];
                                                    }
                                                    
                                                    //Set BPaid
                                                    if([bpa_id objectAtIndex:i]!=nil && ![[NSString stringWithFormat:@"%d",[[bpa_id objectAtIndex:i] intValue]] isEqualToString:@"-1"])
                                                    {
                                                        [addressObj setBPA_ID:[bpa_id objectAtIndex:i]];
                                                    }
                                                    
                                                    //Set APPROVAL FLAG
                                                    if([approvalFlag objectAtIndex:i]!=nil)
                                                    {
                                                        [addressObj setAddressApprovalFlag:[approvalFlag objectAtIndex:i]];
                                                    }
                                                    
                                                    //set Target ID
                                                    if([targetId objectAtIndex:i]!=nil)
                                                    {
                                                        [addressObj setTargetId:[targetId objectAtIndex:i]];
                                                    }
                                                    
                                                    //Set Addr usage Type
                                                    if([addr_usage_type objectAtIndex:i]!=nil  && [addr_usage_type objectAtIndex:i]!=[NSNull null]  && ![[addr_usage_type objectAtIndex:i] isEqualToString:@" "])
                                                    {
                                                        [addressObj setAddr_usage_type:[addr_usage_type objectAtIndex:i]];
                                                    }
                                                    
                                                    [addressArray addObject:addressObj];
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else // BP Id, NPI
                    {
                        for (int i=0; i<[state_id count]; i++)
                        {
                            if([[[[customer objectForKey:@"BPA_ACTV_FLAG"] objectAtIndex:i] lowercaseString] isEqualToString:@"y"])
                            {
                                //Check for Empty address usage type
                                if(([addr_usage_type objectAtIndex:i] != [NSNull null]) && [[addr_usage_type objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length !=0)
                                {
                                    AddressObject * addressObj=[[AddressObject alloc]init];
                                    
                                    //Set Address Line One
                                    if([addressLineOneArray objectAtIndex:i]!=nil  && [addressLineOneArray objectAtIndex:i]!=[NSNull null] && [[addressLineOneArray objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
                                    {
                                        [addressObj setAddressLineOne:[addressLineOneArray objectAtIndex:i]];
                                    }
                                    
                                    //Set Address Line Two
                                    if([addressLineTwoArray objectAtIndex:i]!=nil  && [addressLineTwoArray objectAtIndex:i]!=[NSNull null] && [[addressLineTwoArray objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
                                    {
                                        [addressObj setAddressLineTwo:[addressLineTwoArray objectAtIndex:i]];
                                    }
                                    
                                    //Set City
                                    if([city_id objectAtIndex:i]!=nil && [city_id objectAtIndex:i]!=[NSNull null] && ![[city_id objectAtIndex:i] isEqualToString:@" "])
                                    {
                                        [addressObj setCity:[city_id objectAtIndex:i]];
                                    }
                                    
                                    
                                    //Set State
                                    if([state_id objectAtIndex:i]!=nil && [state_id objectAtIndex:i]!=[NSNull null] && ![[state_id objectAtIndex:i] isEqualToString:@" "])
                                    {
                                        [addressObj setState:[state_id objectAtIndex:i]];
                                    }
                                    
                                    //Set Zip
                                    if([zip_info objectAtIndex:i]!=nil && [zip_info objectAtIndex:i]!=[NSNull null] && ![[zip_info objectAtIndex:i] isEqualToString:@" "])
                                    {
                                        [addressObj setZip:[zip_info objectAtIndex:i]];
                                    }
                                    
                                    //Set BPaid
                                    if([bpa_id objectAtIndex:i]!=nil && ![[NSString stringWithFormat:@"%d",[[bpa_id objectAtIndex:i] intValue]] isEqualToString:@"-1"])
                                    {
                                        [addressObj setBPA_ID:[bpa_id objectAtIndex:i]];
                                    }
                                    
                                    //Set Addr usage Type
                                    if([addr_usage_type objectAtIndex:i]!=nil && [addr_usage_type objectAtIndex:i]!=[NSNull null] && ![[addr_usage_type objectAtIndex:i] isEqualToString:@" "])
                                    {
                                        [addressObj setAddr_usage_type:[addr_usage_type objectAtIndex:i]];
                                    }
                                    
                                    [addressArray addObject:addressObj];
                                }
                            }
                        }
                    }
                    
                    [cust setCustAddress:addressArray];
                    [searchedCustomerArray addObject:cust];
                }
                
            }
            else
            {
                //Error
                NSString * reasonCode=[statusObj objectForKey:@"reasonCode"];
                ErrorLog(@"Error - parseJsonSearchIndividual  Parsing json  : %@",reasonCode);
            }
        }
        else
        {
            ErrorLog(@"Error - parseJsonSearchIndividual  Parsing json ");
        }
    }
    @catch (NSException *exception) {
        ErrorLog(@"Error - parseJsonSearchIndividual  Parsing json  : %@",exception);
        
    }
    
    return searchedCustomerArray;
}

+(NSArray *)parseJsonSearchOrganization:(NSArray *)jsonDataArrayOfObjects
{
    NSMutableArray * searchedOrgArray=[[NSMutableArray alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    @try {
        if(jsonDataArrayOfObjects!=nil && [jsonDataArrayOfObjects count]>0)
        {
            NSDictionary *   statusObj=[jsonDataArrayOfObjects objectAtIndex:0];
            
            NSString *status = [[statusObj objectForKey:@"status"] lowercaseString];
            
            if([status isEqualToString:LOGOUT_KEY])
            {
                [Utilities displayErrorAlertWithTitle:SESSION_EXPIRED andErrorMessage:[statusObj objectForKey:@"reasonCode"] withDelegate:nil];
                return nil;
            }
            else if(![status isEqualToString:@"failure"])
            {
                for(NSDictionary * org in jsonDataArrayOfObjects)
                {
                    OrganizationObject* orgObj=[[OrganizationObject alloc]init];
                    [orgObj setOrgName:[[org objectForKey:@"BP_FULL_NM"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];//Currently using full name , however response too have first name and last name
                //For "Add to terriotary" set isHoUser flag based on HO User for Organization.
                    if ([[defaults objectForKey:HO_USER] isEqualToString:@"Y"]) {
                        [orgObj setIsHoUser:@"Y"];
                    }
                    else
                        [orgObj setIsHoUser:@"N"];
                    
                    if(![[NSString stringWithFormat:@"%d",[[org objectForKey:@"BP_ID"] intValue]] isEqualToString:@"-1"])
                    {
                        [orgObj setOrgBPID:[org objectForKey:@"BP_ID"]];
                    }
                    
                    [orgObj setOrgBPClassification:[[org objectForKey:@"BP_SUB_CLSFN_CD"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    [orgObj setOrgValidationStatus:[org objectForKey:@"VALDN_STA_CD"]];
                    [orgObj setOrgType:[[org objectForKey:@"BP_CLSFN_CD"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    
                    //Address array Parsing
                    NSMutableArray* addressArray=[[NSMutableArray alloc]init];
                    NSArray *addressLineOneArray = [org objectForKey:@"ADDR_LINE_1"];
                    NSArray *addressLineTwoArray = [org objectForKey:@"ADDR_LINE_2"];
                    NSArray *building_id=[org objectForKey:@"BLDG_NM"];
                    NSArray *suite_id=[org objectForKey:@"SUTE_NM"];
                    
                    NSArray * city_id= [org objectForKey:@"CITY_CD"];
                    NSArray * state_id= [org objectForKey:@"STATE_CD"];
                    NSArray * zip_info= [org objectForKey:@"ZIP_CD"];
                    NSArray * addr_usage_type= [org objectForKey:@"ADDR_USAG_TYPE_CD"];
                    NSArray * bpa_id=[org objectForKey:@"BPA_ID"];
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSDictionary *searchParamState = [defaults objectForKey:@"searchParamState"];
                    
                    // there are five quicksearch types: BP Id, NPI, Individual Name, Organization Name
                    NSString *quickSearchType = [defaults objectForKey:@"quickSearchType"];
                    
                    if([quickSearchType isEqualToString:ORG_NAME_QUICK_SEARCH] || [quickSearchType isEqualToString:ORG_REMOVE_SEARCH] || [quickSearchType isEqualToString:ORG_ADVANCED_SEARCH])
                    { // prepare an address arress pertaining to the Sate selected while searching
                        
                        for (int i=0; i<[state_id count]; i++)
                        {
                            if(([[[[org objectForKey:@"BPA_ACTV_FLAG"] objectAtIndex:i] lowercaseString] isEqualToString:@"y"] || [quickSearchType isEqualToString:ORG_REMOVE_SEARCH]))
                            {
                                //Check for Empty address usage type only for the solr search result
                                if([quickSearchType isEqualToString:ORG_REMOVE_SEARCH] || (([addr_usage_type objectAtIndex:i] != [NSNull null]) && [[addr_usage_type objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length !=0))
                                {
                                    //Filter only address for given State
                                    if([quickSearchType isEqualToString:ORG_REMOVE_SEARCH] || [[[state_id objectAtIndex:i] lowercaseString] isEqualToString:[[searchParamState objectForKey:STATE_KEY] lowercaseString]])
                                    {
                                        if([quickSearchType isEqualToString:ORG_REMOVE_SEARCH] || ![searchParamState objectForKey:CITY_KEY] || [[[city_id objectAtIndex:i] lowercaseString] isEqualToString:[[searchParamState objectForKey:CITY_KEY] lowercaseString]])
                                        {
                                            if([quickSearchType isEqualToString:ORG_REMOVE_SEARCH] || ![searchParamState objectForKey:ZIP_KEY] || [[[zip_info objectAtIndex:i] lowercaseString] isEqualToString:[[searchParamState objectForKey:ZIP_KEY] lowercaseString]])
                                            {
                                                if([quickSearchType isEqualToString:ORG_REMOVE_SEARCH] || ![searchParamState objectForKey:STREET_KEY] || [[[addressLineOneArray objectAtIndex:i] lowercaseString] hasPrefix:[[searchParamState objectForKey:STREET_KEY] lowercaseString]])
                                                    
                                                    
                                                {
                                                    if([quickSearchType isEqualToString:ORG_REMOVE_SEARCH] || ![searchParamState objectForKey:BUILDING_KEY] || [[[building_id objectAtIndex:i] lowercaseString] hasPrefix:[[searchParamState objectForKey:BUILDING_KEY] lowercaseString]])
                                                    {
                                                        if([quickSearchType isEqualToString:ORG_REMOVE_SEARCH] || ![searchParamState objectForKey:SUITE_KEY] || [[[suite_id objectAtIndex:i] lowercaseString] hasPrefix:[[searchParamState objectForKey:SUITE_KEY] lowercaseString]])
                                                            
                                                        {
                                                            AddressObject * addressObj=[[AddressObject alloc]init];
                                                            
                                                            //Set Address Line One
                                                            if([addressLineOneArray objectAtIndex:i]!=nil  && [addressLineOneArray objectAtIndex:i]!=[NSNull null] && [[addressLineOneArray objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
                                                            {
                                                                [addressObj setAddressLineOne:[addressLineOneArray objectAtIndex:i]];
                                                            }
                                                            
                                                            //Set Address Line Two
                                                            if([addressLineTwoArray objectAtIndex:i]!=nil  && [addressLineTwoArray objectAtIndex:i]!=[NSNull null] && [[addressLineTwoArray objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
                                                            {
                                                                [addressObj setAddressLineTwo:[addressLineTwoArray objectAtIndex:i]];
                                                            }
                                                            
                                                            //Set City
                                                            if([city_id objectAtIndex:i]!=nil  && [city_id objectAtIndex:i]!=[NSNull null]  && [[city_id objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
                                                            {
                                                                [addressObj setCity:[city_id objectAtIndex:i]];
                                                            }
                                                            
                                                            //Set State
                                                            if([state_id objectAtIndex:i]!=nil  && [state_id objectAtIndex:i]!=[NSNull null]  && [[state_id objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
                                                            {
                                                                [addressObj setState:[state_id objectAtIndex:i]];
                                                            }
                                                            
                                                            //Set Zip
                                                            if([zip_info objectAtIndex:i]!=nil   && [zip_info objectAtIndex:i]!=[NSNull null]  && [[zip_info objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
                                                            {
                                                                [addressObj setZip:[zip_info objectAtIndex:i]];
                                                            }
                                                            
                                                            //Set BPaid
                                                            if([bpa_id objectAtIndex:i]!=nil && ![[NSString stringWithFormat:@"%d",[[bpa_id objectAtIndex:i] intValue]] isEqualToString:@"-1"])
                                                            {
                                                                [addressObj setBPA_ID:[bpa_id objectAtIndex:i]];
                                                            }
                                                            
                                                            //Set Addr usage Type
                                                            if([addr_usage_type objectAtIndex:i]!=nil  && [addr_usage_type objectAtIndex:i]!=[NSNull null]  && [[addr_usage_type objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
                                                            {
                                                                [addressObj setAddr_usage_type:[addr_usage_type objectAtIndex:i]];
                                                            }
                                                            
                                                            [addressArray addObject:addressObj];
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else //  BP Id, NPI
                    {
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        NSString *quickSearchType = [defaults objectForKey:@"quickSearchType"];
                        //for (int i=0; i<[state_id count]; i++)
                        for (int i=0; i<[state_id count]; i++)
                        {
                            if(([[[[org objectForKey:@"BPA_ACTV_FLAG"] objectAtIndex:i] lowercaseString] isEqualToString:@"y"] || [quickSearchType isEqualToString:ORG_REMOVE_SEARCH]))
                            {
                                //Check for Empty address usage type
                                if(([addr_usage_type objectAtIndex:i] != [NSNull null]) && [[addr_usage_type objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length !=0)
                                {
                                    AddressObject * addressObj=[[AddressObject alloc]init];
                                    
                                    //Set Address Line One
                                    if([addressLineOneArray objectAtIndex:i]!=nil  && [addressLineOneArray objectAtIndex:i]!=[NSNull null] && [[addressLineOneArray objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
                                    {
                                        [addressObj setAddressLineOne:[addressLineOneArray objectAtIndex:i]];
                                    }
                                    
                                    //Set Address Line Two
                                    if([addressLineTwoArray objectAtIndex:i]!=nil  && [addressLineTwoArray objectAtIndex:i]!=[NSNull null] && [[addressLineTwoArray objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
                                    {
                                        [addressObj setAddressLineTwo:[addressLineTwoArray objectAtIndex:i]];
                                    }
                                    
                                    //Set City
                                    if([city_id objectAtIndex:i]!=nil  && [city_id objectAtIndex:i]!=[NSNull null]  && [[city_id objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
                                    {
                                        [addressObj setCity:[city_id objectAtIndex:i]];
                                    }
                                    
                                    //Set State
                                    if([state_id objectAtIndex:i]!=nil  && [state_id objectAtIndex:i]!=[NSNull null]  && [[state_id objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
                                    {
                                        [addressObj setState:[state_id objectAtIndex:i]];
                                    }
                                    
                                    //Set Zip
                                    if([zip_info objectAtIndex:i]!=nil   && [zip_info objectAtIndex:i]!=[NSNull null]  && [[zip_info objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
                                    {
                                        [addressObj setZip:[zip_info objectAtIndex:i]];
                                    }
                                    
                                    //Set BPaid
                                    if([bpa_id objectAtIndex:i]!=nil && ![[NSString stringWithFormat:@"%d",[[bpa_id objectAtIndex:i] intValue]] isEqualToString:@"-1"])
                                    {
                                        [addressObj setBPA_ID:[bpa_id objectAtIndex:i]];
                                    }
                                    
                                    //Set Addr usage Type
                                    if([addr_usage_type objectAtIndex:i]!=nil  && [addr_usage_type objectAtIndex:i]!=[NSNull null]  && [[addr_usage_type objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
                                    {
                                        [addressObj setAddr_usage_type:[addr_usage_type objectAtIndex:i]];
                                    }
                                    
                                    [addressArray addObject:addressObj];
                                }
                            }
                        }
                    }
                    
                    [orgObj setOrgAddress:addressArray];
                    [searchedOrgArray addObject:orgObj];
                }
            }
            else
            {
                //Error
                NSString * reasonCode=[statusObj objectForKey:@"reasonCode"];
                ErrorLog(@"Error - parseJsonSearchOrganization  Parsing json  : %@",reasonCode);
            }
        }
        else
        {
            ErrorLog(@"Error - parseJsonSearchOrganization  Parsing json ");
        }
    }
    @catch (NSException *exception) {
        ErrorLog(@"Error - parseJsonSearchOrganization  Parsing json  : %@",exception);
        return nil;
    }
    
    return searchedOrgArray;
}

+(NSDictionary*)parseJsonGetState:(NSDictionary *)jsonDataObject
{
    @try {
        Boolean  statusObj=(Boolean)[jsonDataObject objectForKey:@"status"];
        //Status object is equal to failure in case of error and is not equal to nil...else in sucess it is nil
        if(!statusObj && jsonDataObject!=nil && [jsonDataObject objectForKey:@"states"] && ![[jsonDataObject objectForKey:@"states"] isEqual:[NSNull null]])
        {
            //Extract State City and ZIP
            NSMutableArray *stateIdsArray = [[NSMutableArray alloc] init];
            NSMutableArray *stateNamesArray = [[NSMutableArray alloc] init];
            NSMutableDictionary *stateCityDictionary = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *cityZipDictionary = [[NSMutableDictionary alloc] init];
            
            NSArray *statesArray = [jsonDataObject objectForKey:@"states"];
            if(!statesArray || statesArray.count==0)
            {
                return nil;
            }
            
            for (NSDictionary *stateInfo in statesArray) {
                [stateIdsArray addObject:[stateInfo objectForKey:@"stateId"]];
                [stateNamesArray addObject:[stateInfo objectForKey:@"stateName"]];
                
                NSMutableArray *cityIDsArray = [[NSMutableArray alloc] init];
                NSMutableArray *cityNamesArray = [[NSMutableArray alloc] init];
                
                NSArray *citiesArray = [stateInfo objectForKey:@"cities"];
                if(!citiesArray)
                {
                    return nil;
                }
                
                for (NSDictionary *cityInfo in citiesArray) {
                    [cityIDsArray addObject:[cityInfo objectForKey:@"cityId"]];
                    [cityNamesArray addObject:[cityInfo objectForKey:@"cityName"]];
                    
                    NSMutableArray *zipCodesArray = [[NSMutableArray alloc] init];
                    
                    if([cityInfo objectForKey:@"zip"])
                    {
                        [zipCodesArray addObjectsFromArray:[cityInfo objectForKey:@"zip"]];
                    }
                    else
                    {
                        return nil;
                    }
                    
                    [cityZipDictionary setObject:zipCodesArray forKey:[cityInfo objectForKey:@"cityId"]];
                }
                
                [stateCityDictionary setObject:[NSDictionary dictionaryWithObjectsAndKeys:cityIDsArray, @"cityId", cityNamesArray, @"cityName", nil] forKey:[stateInfo objectForKey:@"stateId"]];
            }
            
            NSMutableDictionary *zipLovDictionary = [[NSMutableDictionary alloc] init];
            [zipLovDictionary setObject:stateIdsArray forKey:@"stateIds"];
            [zipLovDictionary setObject:stateNamesArray forKey:@"stateNames"];
            [zipLovDictionary setObject:stateCityDictionary forKey:@"stateCities"];
            [zipLovDictionary setObject:cityZipDictionary forKey:@"cityZips"];
            
            if([jsonDataObject objectForKey:@"nextUpdateDate"])
                [zipLovDictionary setObject:[jsonDataObject objectForKey:@"nextUpdateDate"] forKey:@"nextUpdateDate"];
            
            DebugLog(@"Next ZIP Update Date: %@", [jsonDataObject objectForKey:@"nextUpdateDate"]);
            return zipLovDictionary;
        }
        else
        {
            return nil;
        }
    }
    @catch (NSException * exception) {
        ErrorLog(@"Error - parseJsonGetState  Parsing json  : %@",exception);
    }
    return nil;
}

+(BOOL)parseJsonAndCheckStatus:(NSDictionary *)jsonDataObject
{
    BOOL status=FALSE;
    @try {
        
        NSString *statusObj = [[jsonDataObject objectForKey:@"status"] lowercaseString];
        
        if([statusObj isEqualToString:LOGOUT_KEY])
        {
            [Utilities displayErrorAlertWithTitle:SESSION_EXPIRED andErrorMessage:[jsonDataObject objectForKey:@"reasonCode"] withDelegate:nil];
            status = FALSE;
        }
        else if(![[statusObj lowercaseString] isEqualToString:@"failure"])
        {
            status=TRUE;
        }
        else
        {
            ErrorLog(@"Error - parseJsonAndCheckStatus  Parsing json  : %@",[jsonDataObject objectForKey:@"reasonCode"]);
        }
    }
    @catch (NSException *exception) {
        ErrorLog(@"Error - parseJsonAndCheckStatus  Parsing json  : %@",exception);
    }
    return status;
}

+(NSArray *)parseJsonGetRequests:(NSArray *)jsonDataArrayOfObjects
{
    NSMutableArray * searchedReqArray=[[NSMutableArray alloc]init];
    @try {
        if(jsonDataArrayOfObjects!=nil && [jsonDataArrayOfObjects count]>0)
        {
            NSDictionary *   statusObj=[jsonDataArrayOfObjects objectAtIndex:0];
            
            NSString *status = [[statusObj objectForKey:@"status"] lowercaseString];
            
            if([status isEqualToString:LOGOUT_KEY])
            {
                [Utilities displayErrorAlertWithTitle:SESSION_EXPIRED andErrorMessage:[statusObj objectForKey:@"reasonCode"] withDelegate:nil];
                return nil;
            }
            else if(![status isEqualToString:@"failure"])
            {
                for(NSDictionary * req in jsonDataArrayOfObjects)
                {
                    RequestObject *reqObj=[[RequestObject alloc]init];
                    if([req objectForKey:@"requestor"] && [[req objectForKey:@"requestor"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                    {
                        [reqObj setRequesterType:[[req objectForKey:@"requestor"] lowercaseString]];
                    }
                    
                    if([req objectForKey:@"status"] && [[req objectForKey:@"status"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                    {
                        [reqObj setRequestStatus:[req objectForKey:@"status"]];
                    }
                    
                    if([req objectForKey:@"requestType"] && [[NSString stringWithFormat:@"%@", [req objectForKey:@"requestType"]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                    {
                        [reqObj setRequestType:[NSString stringWithFormat:@"%@", [req objectForKey:@"requestType"]]];
                    }
                    
                    if([req objectForKey:@"ticketNo"] && [[NSString stringWithFormat:@"%@", [req objectForKey:@"ticketNo"]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                    {
                        [reqObj setTicketNo:[NSString stringWithFormat:@"%@", [req objectForKey:@"ticketNo"]]];
                    }
                    if([req objectForKey:@"ticketId"] && [[NSString stringWithFormat:@"%@", [req objectForKey:@"ticketId"]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                    {
                        [reqObj setTicketId:[NSString stringWithFormat:@"%@", [req objectForKey:@"ticketId"]]];
                    }
                    
                    if([req objectForKey:@"resolutionDescription"] && [[NSString stringWithFormat:@"%@", [req objectForKey:@"resolutionDescription"]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                    {
                        [reqObj setResolutionDescription:[NSString stringWithFormat:@"%@", [req objectForKey:@"resolutionDescription"]]];
                    }
                    
                    if([req objectForKey:@"reason"] && [[NSString stringWithFormat:@"%@", [req objectForKey:@"reason"]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                    {
                        [reqObj setReason:[NSString stringWithFormat:@"%@", [req objectForKey:@"reason"]]];
                    }
                   
                    if ([[req objectForKey:@"removalReason"] length]>0 && !([[req objectForKey:@"removalReason"] isEqualToString:@"(null)"])) {
                        [reqObj setRequestDetails:[NSString stringWithFormat:@"%@", [req objectForKey:@"removalReason"]]];
                    }
                    else
                    {
                        [reqObj setRequestDetails:[NSString stringWithFormat:@""]];
                    }
                    
                    //Check Cust type if Individual
                    //Set CustomerInfo
                    NSDictionary * customer=[req objectForKey:@"customer"];
                    if([[req objectForKey:@"custType"] isEqualToString:@"INDV"])
                    {
                        CustomerObject * cust=[[CustomerObject alloc]init];
                        if([customer objectForKey:@"title"] && [[customer objectForKey:@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                        {
                            [cust setCustTitle:[customer objectForKey:@"title"]];
                        }
                        
                        if([customer objectForKey:@"fname"] && [[customer objectForKey:@"fname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                        {
                            [cust setCustFirstName:[customer objectForKey:@"fname"]];
                        }
                        
                        if([customer objectForKey:@"mname"] && [[customer objectForKey:@"mname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                        {
                            [cust setCustMiddleName:[customer objectForKey:@"mname"]];
                        }
                        
                        if([customer objectForKey:@"lname"] && [[customer objectForKey:@"lname"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                        {
                            [cust setCustLastName:[customer objectForKey:@"lname"]];
                        }
                        
                        if([customer objectForKey:@"custSfxTxt"] && [[customer objectForKey:@"custSfxTxt"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                        {
                            [cust setCustSuffix:[customer objectForKey:@"custSfxTxt"]];
                        }
                        
                        if([customer objectForKey:@"bpId"])
                        {
                            [cust setCustBPID:[NSString stringWithFormat:@"%@", [customer objectForKey:@"bpId"]]];
                        }
                        else
                        {
                            [cust setCustBPID:@""];
                        }
                        //Bug 467: Show blank NPI, if received NPI is -5
                        if((![[NSString stringWithFormat:@"%d",[[customer objectForKey:@"npi"] intValue]] isEqualToString:@"-1"]) && (![[NSString stringWithFormat:@"%d",[[customer objectForKey:@"npi"] intValue]] isEqualToString:@"-5"]))
                        {
                            [cust setCustNPI:[customer objectForKey:@"npi"]];
                        }
                        
                        if(![[NSString stringWithFormat:@"%d",[[customer objectForKey:@"primarySpec"] intValue]] isEqualToString:@"99"])
                        {
                            [cust setCustPrimarySpecialtyCode:[customer objectForKey:@"primarySpec"]];
                        }
                        
                        [cust setCustPrimarySpecialty:[customer objectForKey:@"priSpecNm"]];
                        
                        if(![[NSString stringWithFormat:@"%d",[[customer objectForKey:@"secondaryspec"] intValue]] isEqualToString:@"99"])
                        {
                            [cust setCustSecondarySpecialtyCode:[customer objectForKey:@"secondaryspec"]];
                        }
                        if([req objectForKey:@"bpaToDealign"]!=nil){
                            [cust setBpaToDealign:[NSArray arrayWithArray:[req objectForKey:@"bpaToDealign"]]];
                            
                        }
                        
                   
                        [cust setCustSecondarySpecialty:[customer objectForKey:@"secSpecNm"]];
                        [cust setCustProfessionalDesignation:[customer objectForKey:@"profDesg"]];
                        [cust setCustType:[customer objectForKey:@"bpClassification"]];
                        
                        NSMutableArray *addressArray = [[NSMutableArray alloc] init];
                        
                        if([customer objectForKey:@"address"])
                        {
                            for(NSDictionary * obj in [customer objectForKey:@"address"])
                            {
                                AddressObject * addressObj=[[AddressObject alloc]init];
                                [addressObj setAddressLineOne:[obj objectForKey:@"addrLine1"]];
                                [addressObj setAddressLineTwo:[obj objectForKey:@"addrLine2"]];
                                [addressObj setStreet:[obj objectForKey:@"street"]];
                                [addressObj setState:[obj objectForKey:@"state"]];
                                [addressObj setBuilding:[obj objectForKey:@"building"]];
                                if(![[NSString stringWithFormat:@"%d",[[customer objectForKey:@"bpaId"] intValue]] isEqualToString:@"-1"])
                                {
                                    [addressObj setBPA_ID:[obj objectForKey:@"bpaId"]];
                                }
                                [addressObj setCity:[obj objectForKey:@"city"]];
                                [addressObj setSuite:[obj objectForKey:@"suite"]];
                                [addressObj setZip:[obj objectForKey:@"zip"]];
                                [addressObj setAddr_usage_type:[obj objectForKey:@"addrUsageType"]];
                                [addressObj setStatus:[obj objectForKey:@"status"]];
                                [addressObj setTicketId:[obj objectForKey:@"ticketId"]];
                                [addressArray addObject:addressObj];
                            }
                        }
                        
                        [cust setCustAddress:addressArray];
                        [reqObj setCustomerInfo:cust];
                        ///
                        
                        NSMutableArray *bpaDealignAddresses = [[NSMutableArray alloc] init];
                        NSMutableArray * dealignBPADict=[req objectForKey:@"dealignBPAStatus"];
                        if ([req objectForKey:@"dealignBPAStatus"] )
                        {
                            for(NSDictionary * obj in dealignBPADict)
                            {
                                DealignBPA *dealignBPAsObj= [[DealignBPA alloc] init];
                                if (!(([obj objectForKey:@"addressType"] == nil) || ([[obj objectForKey:@"addressType"] isEqualToString:@""]))) {
                                    [dealignBPAsObj setAddressType:[obj objectForKey:@"addressType"]];
                                }
                                else
                                    [dealignBPAsObj setAddressType:@""];
                                
                                if (!([obj objectForKey:@"addrLine1"] == nil) || !([[obj objectForKey:@"addrLine1"] isEqualToString:@""]) || !([[obj objectForKey:@"addrLine1"] isEqualToString:@"(null)"])) {
                                    [dealignBPAsObj setAddressLine1:[obj objectForKey:@"addrLine1"]];
                                } else {
                                    [dealignBPAsObj setAddressLine1:@""];
                                }
                                
                                if (([obj objectForKey:@"state"] == nil) || ([[obj objectForKey:@"state"] isEqualToString:@""]) || !([[obj objectForKey:@"state"] isEqualToString:@"(null)"]) ) {
                                    [dealignBPAsObj setAddressState:[obj objectForKey:@"state"]];
                                } else {
                                    [dealignBPAsObj setAddressState:@""];
                                }
                                
                                if (([obj objectForKey:@"city"] == nil) || ([[obj objectForKey:@"city"] isEqualToString:@""]) || !([[obj objectForKey:@"city"] isEqualToString:@"(null)"]) ) {
                                    [dealignBPAsObj setAddressCity:[obj objectForKey:@"city"]];
                                } else {
                                    [dealignBPAsObj setAddressCity:@""];
                                }
                                
                                if (([obj objectForKey:@"zip"] == nil) || ([[obj objectForKey:@"zip"] isEqualToString:@""]) || !([[obj objectForKey:@"zip"] isEqualToString:@"(null)"]) ) {
                                    [dealignBPAsObj setAddressZip:[obj objectForKey:@"zip"]];
                                } else {
                                    [dealignBPAsObj setAddressZip:@""];
                                }
                                
                                
                                if (!(([[obj objectForKey:@"bpaId"] stringValue] == nil) || ([[[obj objectForKey:@"bpaId"] stringValue] isEqualToString:@""]))) {
                                    [dealignBPAsObj setBpaId:[NSString stringWithFormat:@"%@", [obj objectForKey:@"bpaId"]]];
                                    
                                }
                                else
                                    [dealignBPAsObj setBpaId:@""];
                                
                                if (!(([obj objectForKey:@"status"]== nil) || ([[obj objectForKey:@"status"] isEqualToString:@""]))) {
                                    [dealignBPAsObj setStatus:[obj objectForKey:@"status"]];
                                    
                                }
                                else
                                    [dealignBPAsObj setStatus:@""];
                                
                                NSString *string = [NSString stringWithFormat:@"%@",[obj objectForKey:@"ticketId"]];
                                if (string != nil || ![string isEqualToString:@""] || ![string isEqualToString:@"<null>"] || [string rangeOfString:@"null"].location == NSNotFound)
                                {
                                    [dealignBPAsObj setTicketId:string];
                                }
                                else
                                    [dealignBPAsObj setTicketId:@""];
                                
                                if([string isEqualToString:@"<null>"]){
                                    [dealignBPAsObj setTicketId:@""];
                                }
                                [bpaDealignAddresses addObject:dealignBPAsObj];
                            }
                           
                        }
                        [reqObj setDealignedBPAInfoArray:bpaDealignAddresses];
                        
                    }
                    //else Set org Info
                    else //org
                    {
                        OrganizationObject * orgObj=[[OrganizationObject alloc]init];
                        [orgObj setOrgName:[customer objectForKey:@"orgName"]];
                        
                        if([customer objectForKey:@"bpId"])
                        {
                            [orgObj setOrgBPID:[NSString stringWithFormat:@"%@", [customer objectForKey:@"bpId"]]];
                        }
                        else
                        {
                            [orgObj setOrgBPID:@""];
                        }
                        
                        [orgObj setOrgBPClassification:[customer objectForKey:@"bpSubCLssification"]];  ////TODO : verify withe server team
                        [orgObj setOrgValidationStatus:[customer objectForKey:@"orgValidationStatus"]];
                        [orgObj setOrgType:[customer objectForKey:@"bpClassification"]]; //TODO : verify withe server team
                        
                        NSMutableArray *addressArray = [[NSMutableArray alloc] init];
                        
                        if([customer objectForKey:@"address"])
                        {
                            for(NSDictionary * obj in [customer objectForKey:@"address"])
                            {
                                AddressObject * addressObj=[[AddressObject alloc]init];
                                [addressObj setAddressLineOne:[obj objectForKey:@"addrLine1"]];
                                [addressObj setAddressLineTwo:[obj objectForKey:@"addrLine2"]];
                                [addressObj setStreet:[obj objectForKey:@"street"]];
                                [addressObj setState:[obj objectForKey:@"state"]];
                                [addressObj setBuilding:[obj objectForKey:@"building"]];
                                if(![[NSString stringWithFormat:@"%d",[[customer objectForKey:@"bpaId"] intValue]] isEqualToString:@"-1"])
                                {
                                    [addressObj setBPA_ID:[obj objectForKey:@"bpaId"]];
                                }
                                [addressObj setCity:[obj objectForKey:@"city"]];
                                [addressObj setSuite:[obj objectForKey:@"suite"]];
                                [addressObj setZip:[obj objectForKey:@"zip"]];
                                [addressObj setAddr_usage_type:[obj objectForKey:@"addrUsageType"]];
                                [addressArray addObject:addressObj];
                            }
                        }
                        
                        [orgObj setOrgAddress:addressArray];
                        [reqObj setOrganizationInfo:orgObj];
                    }
                    
                                       //Set req status history
                    NSArray * histArray=[req objectForKey:@"reqHistList"];
                    NSMutableArray * historyObjectArray=[[NSMutableArray alloc]init];
                    for(NSDictionary * hist in histArray)
                    {
                        RequestStatusHistoryObject* histObj=[[RequestStatusHistoryObject alloc]init];
                       
                        [histObj setActionDate:[ NSString stringWithFormat:@"%@ (CST)",[hist objectForKey:@"actionDate"]]];
                        [histObj setStatus:[hist objectForKey:@"status"]];
                        [histObj setRequestType:[req objectForKey:@"requestType"]];
                        [historyObjectArray addObject:histObj];
                    }
                    [reqObj setRequestStatusHistory:historyObjectArray];
                    [searchedReqArray addObject:reqObj];
                }
            }
            else
            {
                //Error
                NSString * reasonCode=[statusObj objectForKey:@"reasonCode"];
                ErrorLog(@"Error - parseJsonSearchRequests  Parsing json  : %@",reasonCode);
                
            }
        }
        else
        {
            ErrorLog(@"Error - parseJsonSearchRequests  Parsing json ");
            
        }
    }
    @catch (NSException *exception) {
        ErrorLog(@"Error - parseJsonSearchRequests  Parsing json  : %@",exception);
    }
    
    return searchedReqArray;
}

+(NSArray *)parseJsonMapLatAndLon:(NSDictionary *)jsonDataObject
{
    NSMutableArray * latLonArray=[[NSMutableArray alloc]init];
    NSString * status=[jsonDataObject objectForKey:@"status"];
    if([status isEqualToString:@"ZERO_RESULTS"])
    {
        return nil;
    }
    else  if([status isEqualToString:@"OK"])
    {
        NSArray * result=[jsonDataObject objectForKey:@"results"];
        //There may be many results based on the address so we are showing only first address lat and long
        NSDictionary * result1=[result objectAtIndex:0];
        NSDictionary * geometry=[result1  objectForKey:@"geometry"];
        NSDictionary * location=[geometry objectForKey:@"location"];
        
        if([location objectForKey:@"lat"]!=nil)
        {
            [latLonArray addObject:[location objectForKey:@"lat"]];
        }
        if([location objectForKey:@"lng"]!=nil)
        {
            [latLonArray addObject:[location objectForKey:@"lng"]];
        }
    }
    return latLonArray;
}

+(NSArray*)parseJsonGetRecents:(NSDictionary *)jsonDataObject
{
    NSMutableArray *recentsData =[[NSMutableArray alloc] init];
    @try {
        if(jsonDataObject != nil && jsonDataObject.count>0)
        {
            NSString *status = [[jsonDataObject objectForKey:@"status"] lowercaseString];
            
            if(![status isEqualToString:@"failure"])
            {
                NSArray *recents = [jsonDataObject objectForKey:@"messages"];
                for (NSString *msgString in recents) {
                    if(msgString)
                    {
                        [recentsData addObject:[NSString stringWithFormat:@"%@", msgString]];
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        ErrorLog(@"Error - parseJsonGetRecents  Parsing json  : %@",exception);
    }
    
    return recentsData;
}
#pragma mark -

#pragma mark App View Handlers
+(void)displayErrorAlertWithTitle:(NSString *)title andErrorMessage:(NSString *)errorMessage withDelegate:(id)delegate
{
    UIAlertView *alertView;
    
    if([title isEqualToString:SESSION_EXPIRED])
    {
        AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        alertView = [[UIAlertView alloc] initWithTitle:title message:errorMessage delegate:appDelegate cancelButtonTitle:OK_STRING otherButtonTitles:nil, nil];
    }
    else if(delegate && ([title rangeOfString:RETRY_STRING].location != NSNotFound))
    {
        title = [title stringByReplacingOccurrencesOfString:RETRY_STRING withString:@""];
        alertView = [[UIAlertView alloc] initWithTitle:title message:errorMessage delegate:delegate cancelButtonTitle:RETRY_STRING otherButtonTitles:nil, nil];
    }
    else
    {
        alertView = [[UIAlertView alloc] initWithTitle:title message:errorMessage delegate:(delegate ? delegate : self) cancelButtonTitle:OK_STRING otherButtonTitles:nil, nil];
    }
    
    [alertView show];
}

+(void)addSpinnerOnView:(UIView *)view withMessage:(NSString *)messageStringOrNil
{
    if([view viewWithTag:100])
    {
        return;
    }
    
    UIView* spinnerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,view.frame.size.width,view.frame.size.height)];
    
    [spinnerView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
    spinnerView.tag=100;
    
    //Add Activity Indicator
    UIActivityIndicatorView* spinner=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinnerView addSubview:spinner];
    spinner.center=spinnerView.center;
    
    //Add Message label
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, 50)];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setTextColor:[UIColor whiteColor]];
    [messageLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:17.0]];
    [messageLabel setText:messageStringOrNil];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [spinnerView addSubview:messageLabel];
    [messageLabel setCenter:CGPointMake(spinnerView.center.x, spinnerView.center.y+50)];
    
    [view addSubview:spinnerView];
    [spinner startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=TRUE;
}

+(void)removeSpinnerFromView:(UIView *)view
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=FALSE;
    //Remove Spinner
    for(UIView * subview in view.subviews)
    {
        if(subview.tag==100)
        {
            [subview removeFromSuperview];
            break;
        }
    }
}

+(BOOL)changeSelectedTerritoryTo:(NSString *)newTerritory
{
    BOOL isTerritoryChanged = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * loggedInUser=[defaults objectForKey:@"LoggedInUser"];
    for(NSString * terrId in [[loggedInUser objectForKey:@"TerritoriesAndRoles"] allKeys])
    {
        if([newTerritory isEqualToString:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"TerritoryName"]] && ![newTerritory isEqualToString:[defaults objectForKey:@"SelectedTerritoryName"]])
        {
            [defaults setObject:terrId forKey:@"SelectedTerritoryId"];
            [defaults setObject:newTerritory forKey:@"SelectedTerritoryName"];
            //Set Role Id for role - Can be changed in future
            [defaults setObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"RoleId"] forKey:@"Role"];
            [defaults setObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"teamId"] forKey:@"SelectedTeamId"];
            [defaults setObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"TargetFlag"] forKey:@"TargetFlag"];
            
            //Excluded address usage type
            if([[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"excludedAddrUsgType"])
            {
                [defaults setObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"excludedAddrUsgType"] forKey:@"SelectedRoleExcludedAddrUsgType"];
            }
            else
            {
                [defaults removeObjectForKey:@"SelectedRoleExcludedAddrUsgType"];
            }
            
            //Inclusion bp classification
            if([[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"includedBpClassificationType"])
            {
                [defaults setObject:[[[loggedInUser objectForKey:@"TerritoriesAndRoles"] objectForKey:terrId] objectForKey:@"includedBpClassificationType"] forKey:@"SelectedRoleIncludedBpClassificationType"];
            }
            else
            {
                [defaults removeObjectForKey:@"SelectedRoleIncludedBpClassificationType"];
            }
            
            //User roles
            if([[defaults objectForKey:@"Role"] isEqualToString:USER_ROLE_ID_MA] || [[defaults objectForKey:@"Role"] isEqualToString:USER_ROLE_ID_MSL])
            {
                [defaults setObject:USER_ROLE_MA_MSL forKey:USER_ROLES_KEY];
            }
            else
            {
                [defaults setObject:USER_ROLE_SALES_REP forKey:USER_ROLES_KEY];
            }
            
            isTerritoryChanged = YES;
            break;
        }
    }
    
    return isTerritoryChanged;
}
#pragma mark -

#pragma mark Database Handlers
+(BOOL)copyDatabaseFromResources
{
    //Copy database file 'CustMgrDB.db' from app resources to Application Support directory and exclude the file from iCloud backup
    
    BOOL success;
    NSFileManager *fileManager = [[NSFileManager defaultManager] init];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths objectAtIndex:0];
    NSString *databaseFolderPath = [applicationSupportDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundleIdentifier]]];
    NSString *databaseFilePath = [databaseFolderPath stringByAppendingPathComponent:@"CustMgrDB.db"];
    
    success = [fileManager fileExistsAtPath:databaseFilePath];
    
    if(success)
    {
        return TRUE;
    }
    else
    {
        [fileManager createDirectoryAtPath:databaseFolderPath withIntermediateDirectories:YES attributes:nil error:&error];
        
        //Add atrribute to directory to exclude its content from iCloud backup
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSURLIsExcludedFromBackupKey, nil];
        NSURL *dirUrl = [NSURL fileURLWithPath:databaseFolderPath isDirectory:YES];
        [dirUrl setResourceValues:attributeDict error:nil];
    }
    
    NSString *resourceDbFilePath = [[[NSBundle mainBundle] resourcePath]
                                      stringByAppendingPathComponent:@"CustMgrDB.db"];
    
    if([fileManager fileExistsAtPath:resourceDbFilePath])
    {
        [fileManager copyItemAtPath:resourceDbFilePath toPath:databaseFilePath
                              error:&error];
        
        if(error==nil)
        {
            DebugLog(@"Database from Resources copied to Application Support directory successfully");
            return TRUE;
        }
        else
        {
            ErrorLog(@"Error while copying database from Resources to Application Support directory");
        }
    }
    
    return FALSE;
}

+(BOOL)copyDatabaseFrom:(NSString *)sourcePath to:(NSString *)destinationPath
{
    BOOL success;
    NSFileManager *fileManager = [[NSFileManager defaultManager] init];
    NSError *error;

    success = [fileManager fileExistsAtPath:sourcePath];
    
    if (success)
    {
        if(destinationPath)     //If destinaltion path != nil then copy file from source to destination
        {
            //Remove already existing file from Destination path
            if([fileManager fileExistsAtPath:destinationPath])
            {
                [fileManager removeItemAtPath:destinationPath error:nil];
            }
            
            [fileManager copyItemAtPath:sourcePath toPath:destinationPath
                                  error:&error];
            
            if(error==nil)
            {
                DebugLog(@"Database Copied from %@ to : %@", [sourcePath lastPathComponent], [destinationPath lastPathComponent]);
                return TRUE;
            }
            else
            {
                ErrorLog(@"Error while copying database from %@ to : %@", [sourcePath lastPathComponent], [destinationPath lastPathComponent]);
            }
        }
        else    //If destinaltion path == nil then remove file from Source
        {
            [fileManager removeItemAtPath:sourcePath error:nil];
            DebugLog(@"File removed from location:%@", [sourcePath lastPathComponent]);
            return TRUE;
        }
    }
    
    return FALSE;
}
#pragma mark -

#pragma mark Google Maps Digital Signature
/**
 Google Toolbox for MAC
 files: GTMStringEncoding.h,
 GTMStringEncoding.m
 GTMDefines.h
 SVN Loc: http://google-toolbox-for-mac.googlecode.com/svn/trunk/
 **/
//Using above helpers from Google Toolbox for Mac for encryption of Binary data to modified Base64 NSString and vice versa to generate digital signature to be used with Geocoding API in case Google Maps Business License
+(NSString*)getSignatureForUrl:(NSString *)url usingPrivateKey:(NSString *)privateKey
{
    NSString *signature = @"";
    @autoreleasepool {
        
        //Get binary data from URL to be signed
        NSData *urlData = [url dataUsingEncoding:NSASCIIStringEncoding];
        
        //URL-safe Base64 coder/decoder.
        GTMStringEncoding *gtmStringEncoding = [GTMStringEncoding rfc4648Base64WebsafeStringEncoding];
        
        //Decode private key using Base64 format before using
        NSData *decodedKeyData = [gtmStringEncoding decode:privateKey];
        
        //Generate signature with URL and private key using HMAC algorithm
        unsigned char msgAuthCode[CC_SHA1_DIGEST_LENGTH];
        CCHmac(kCCHmacAlgSHA1, [decodedKeyData bytes], [decodedKeyData length], [urlData bytes], [urlData length], &msgAuthCode);
        NSData *signatureData = [[NSData alloc] initWithBytes:msgAuthCode length:CC_SHA1_DIGEST_LENGTH];
        
        //Encode signature to Base64 format
        signature = [gtmStringEncoding encode:signatureData];
    }
    
    return signature;
}
#pragma mark -

@end
