//
//  Constants.h
//  CustomerManagerSystemiPad
//
//  Created by Ravi Kumar on 26/06/13.
//  Copyright (c) 2013 Persistent. All rights reserved.
//

#ifndef CustomerManagerSystemiPad_Constants_h
#define CustomerManagerSystemiPad_Constants_h

//--------------------------------------------------------------------------------------------------------
#pragma mark - Server Communication

//Live App 1 means it is Live App and will hit webserivce else it will show dummy data
#define iSLiveApp 1  // live
//#define iSLiveApp 0    //Static

//Bypass SSO flow if set to 0
#define isSSOEnabled 1
//#define isSSOEnabled 0

#define SERVER_DOMAIN  @"$erver_dom@in"

#if TEST_BUILD
#define SERVER_DOMAIN_URL   @"https://nexus.test.zsservices.com"            //DEV ENV //Debug
//#define SERVER_DOMAIN_URL   @"https://nexus.intgstaging.zsservices.com"            //DEV ENV
#elif INTG_STAGING_BUILD
#define SERVER_DOMAIN_URL   @"https://nexus.intgstaging.zsservices.com"     //ZS QA ENV //Intgstaging
#elif STAGING_BUILD
#define SERVER_DOMAIN_URL   @"https://nexus.staging.zsservices.com"         //Staging ENV //Pre-Production
#elif PRODUCTION_BUILD
#define SERVER_DOMAIN_URL   @"https://nexus.zsservices.com"                 //Production ENV // Release
#endif

//Urls
#define COMMON_SERVER_URL @""SERVER_DOMAIN"/nexus-ws/CMService/requests"
#define COMMON_SERVER_SSO_URL @""SERVER_DOMAIN"/nexus-ws/CMService/sso"
#define SSO_DEFAULT_URL @"https://fed-staging.zsservices.com:443/sp/startSSO.ping?PartnerIdpId=bms2zsa&TargetResource=https://nexus.staging.zsservices.com"     //Not used in app. Just for the reference

#define SSO_URL @""SERVER_DOMAIN"/nexus-ws/CMService/sso/redirectURL"
#define GET_USER_ROLES @""SERVER_DOMAIN"/nexus-ws/CMService/sso/authenticate?"
//
//#define GET_USER_ROLES @""SERVER_DOMAIN"/nexus-ws/CMService/sso/authenticateWithoutSSO?"
//

#define SEARCH_INDIVIDUAL_URL  @"searchIndividual?"
#define SEARCH_INDIVIDUAL_FOR_AR  @"searchIndividualForAR?"
#define SEARCH_BP_URL   @"searchBP?"
#define SEARCH_ORGANIZATION_URL @"searchOrganization?"
#define STATE_LIST_URL @"getStates?date="
#define ORG_TYPES_URL @"getOrgTypes?date="
#define ADD_NEW_ADDRESS_URL @"addAddress"
#define ALIGN_TO_TERRITORY_URL @"alignToTerritory"
#define CHANGE_TARGET_STATUS_URL @"changeTargetStatus"
#define SEARCH_MD_URL @"searchMD"
#define ADD_INDIVIDUAL_URL @"addNewIndividual"
#define ADD_ORGANIZATION @"addNewOrganization"
#define SEARCH_INDIVIDUAL_ALIGNMENTS_URL @"searchIndividualInAlignments?"
#define GET_TARGETS @"getTargets?"
#define SEARCH_ORGANIZATION_ALIGNMENTS_URL @"searchOrganizationInAlignments?"
#define REMOVE_ADDRESS_URL @"removeAddress?"
#define SHOW_DUPLICATE_ADDRES_URL   @"getAllActiveAddressOfBp?"
#define SHOW_CDF_FLAG_URL   @"showCDFForMLP?"
#define VIEW_DUPLICATE_ADDRESSES_OF_BP_URL  @"getDuplicateAddressesOfBP?"
#define AFFILIATE_MLP_URL   @"affiliateMLP?"

#define REMOVE_CUSTOMER_URL @"removeCustomer?"
#define REQUESTS_DETAILS_URL @"getRequest?"
#define WITHDRAW_REQUEST_URL @"withdrawRequest"
#define WITHDRAW_ALIGNMENT_REQUEST_URL @"withdrawAlignmentReq"
#define REMOVE_ADDRESS_REQUEST_URL  @"changeAddressRemovalStatus"
#define LOGOUT_URL  @"logout"   //SSO path format
#define RECENTS_URL @"getRecentChanges?"
#define GET_STATES  @"getStates?"

//Google maps license details
#define GOOGLE_MAPS_API_DEMAIN              @"https://maps.googleapis.com"
#define GOOGLE_MAPS_GEOCODE_API_ABS_PATH    @"/maps/api/geocode/json?"
#define GOOGLE_MAPS_CLIENT_ID               @"gme-zsassociates1"
#define GOOGLE_MAPS_CRYPTO_KEY              @"Zj8RvQzxfdmelDv5TkPo-iQm_Jc="
#define GOOGLE_MAPS_FREE_USAGE_API_KEY      @"AIzaSyBkx-ePt5MwczhYn6DLHO4E1ftu-SrkVgU"
#define GOOGLE_MAPS_BUSINESS_USAGE_API_KEY  @""

//--------------------------------------------------------------------------------------------------------
#pragma mark - Custom Table View UI Constants

// Custom Table Componenets
#define TEXTFIELD_TYPE  @"textFieldType"
#define TEXTFIELD_VALUE @"textFieldValue"
#define ACCESSORY      @"accessory"
#define REQUIRED_TEXTFIELD @"requireTextField"
#define ACCESSORY_STATE_VALUE   @"accessoryStateValue"
#define SEARCH_PARAMETER_VALIDATION @"searchParameterValidation"
#define A_STRING            @"A"
#define R_STRING            @"R"
#define STATUS_PENDING      @"Status: Pending"
#define STATUS_COMPLETED      @"Status: Completed"
#define NOT_AVAILABLE       @"Not Available"
#define APPROVE_ADDRESS     1999
#define REJECT_ADDRESS      2999
#define WITHDRAW_TARGET     3999
#define NOT_FOUND           -100
#define ACCESSORY_STATE_SELECTED    1
#define ACCESSORY_STATE_UNSELECTED  0
#define REQUIRED_SECTION    @"requiredSection"

#define SPECIAL_FEATURE_REQUIRED_FIELDS     @"specialFeatureRequiredFields"
#define SPECIAL_FEATURE_FOOTER_TEXT         @"specialFeatureFooterText"
#define SEARCH_FORM_FIELDS_SEQUENCE         @"searchFormFieldsSequence"

//Keys
#define BPID_KEY            @"Master ID #"
#define BPAID_KEY           @"Master Address ID"
#define ORG_BPID_KEY        @"Master ID #"
//commenting here for check
//#define ORG_BPID_KEY        @"Organization Master ID #"
#define NPI_KEY             @"NPI #"
#define FIRST_NAME_KEY      @"First Name"
#define LAST_NAME_KEY       @"Last Name"
#define MIDDLE_NAME_KEY     @"Middle Name"
#define SUFFIX_KEY          @"Suffix"
#define STATE_KEY           @"State"
#define BUILDING_KEY        @"Building Number"
#define SUITE_KEY           @"Suite Number"

#define ORG_NAME_KEY        @"Organization Name"
#define ORG_TYPE_KEY        @"Organization Type"
#define REQ_STATUS_KEY      @"Status"
#define RESOLUTION_DESC_KEY      @"Resolution Description"
#define CITY_KEY            @"City"
#define ZIP_KEY             @"ZIP"
#define CHANGE_TERRITORY    @"Change territory"
#define REQ_STAGE_KEY       @"Stage of Request"
#define REQ_TYPE_KEY        @"Request Type"
#define REQUESTOR_KEY       @"Requestor"
#define PRIMARY_SPECIALTY_KEY @"Primary Specialty"
#define REMOVE_CUSTOMER_REASONS_KEY @"Remove Customer Reasons"
#define PROF_DESGN_KEY      @"Professional Designation"
#define INDV_TYPE_KEY       @"Individual Type"
#define TARGET_SEARCH_INDV_TYPE_KEY       @"Individual Type"
#define STREET_KEY          @"Address Line 1"            //Street
#define ADDRESS_USAGE_KEY   @"Address Usage Type"
#define BP_CLASSIFICATION_KEY   @"BP Classification"
#define REQ_CREATION_DATE_KEY   @"Create Date"
#define REP_TARGET_VALUE_KEY    @"Rep Target Value"
#define REQ_TICKET_NUMBER_KEY   @"Ticket #"
#define REQUEST_TYPE_KEY    @"Request Type"
#define NAME_KEY        @"Name"
#define IDS_KEY         @"IDs"
#define ADDRESS_KEY     @"Address"
#define OTHER_FIELDS_KEY    @"Other Fields"
#define PROFILE_KEY     @"Profile"
#define ADDRESS_USAGE_TYPE_OFF_KEY  @"OFF"
#define SEARCH_FOR_KEY      @"Search For"
#define NEW_ADDRESS_KEY     @"New Address"
#define APPROVER_NAME_KEY   @"Approver Name"
#define ACTION_DATE_KEY     @"Action Date"
#define APPROVAL_STATUS_KEY @"Status"
#define TERRITTORY          @"Territory Name"
#define SELECTED_TERRITTORY_NAME    @"SelectedTerritoryName"
#define SELECTED_TEAM_NAME    @"SelectedTeamName"

//Added for HO user
#define HO_USER             @"isHoUser"
#define BU_KEY              @"BU"
#define TEAM_KEY            @"Team"
#define TERRIOTARY_KEY      @"Terriotary"
#define SELECTED_BU_INDEX     @"tempSelectedBuIndex"
#define SELECTED_TEAM_INDEX   @"tempSelectedTeamIndex"
#define SELECTED_TERR_INDEX   @"tempSelectedTerrIndex"
#define REQUEST_MESSAGE_KEY     @"RequestTabMessageForHOUser"
#define REMOVE_MESSAGE_KEY     @"RemoveTabMessageForHOUser"
#define SEARCH_MESSAGE_KEY      @"SearchTabMessageForHOUser"
#define TARGET_MESSAGE_KEY      @"TargetTabMessageForHOUser"


//Added for ON/Off
#define TERRIOTARY_ONOFF_KEY            @"terriotaryOnOffFlag"
#define ADD_ONOFF_ERROR_KEY             @"addOnOffErrorMsg"
#define REMOVE_ONOFF_ERROR_KEY          @"removeOnOffErrorMsg"
#define ADD_REMOVE_USER_DEFAULT_KEY     @"addRemoveOnOffDefault"
#define REMOVE_ORG_KEY                  @"RemOrg"
#define REMOVE_INDV_KEY                 @"RemIndv"
#define ADD_ORG_KEY                     @"AddOrg"
#define ADD_INDV_KEY                    @"AddIndv"
#define SEARCH_ERROR_MESSAGE_KEY        @"No results found. Please modify your search criteria. Add Functionality has been disabled for your team."


#define MASTER_ADDRESS_ID_STRING        @"Master Address ID"
#define ADDRESS_DETAILS_STRING          @"Address Type"
#define STATUS_STRING                   @"Status"
#define REQUEST_TICKET_ID_STRING        @"Request Ticket ID"

#define DUPLICATE_ADDRESS_SCREEN                @"Duplicate Address Screen"
#define DUPLICATE_ADDRESSES_REMOVAL_SCREEN      @"Select Additional Addresses for Removal"
#define VIEW_DUPLICATE_ADDRESS_SCREEN           @"View Duplicate Address Screen"
#define MLP_SCREEN                              @"MLP Screen"
#define ALIGN_NEW_ADDRESS                       @"Align New Address"
#define CDF_FLAG_SCREEN_TITLE                   @"Select MD for Affiliation"

#define TABLE_FOOTER_TEXT_ADD_INDIVIDUAL   @"Note: All new customers are subject to Master ID verification and business rules validation. Eligible Non-Prescribers will be added to your InterACT system within 24 - 48 hours. Prescribers may take up to 90 days, depending on the third party validation."

#define TABLE_FOOTER_TEXT_ADD_ORGANIZATION  @"Note: All new customers are subject to Master ID verification and business rules validation. Eligible GRPs and LLCs will be added to your InterACT system within 24 - 48 hours."

//---------------------------------------------------------------------------------------------------------
#pragma mark - User Action Constants
//Quick Search Types
#define BP_ID_QUICK_SEARCH      @"BP ID Search"
#define NPI_QUICK_SEARCH        @"NPI Search"

#define INDV_NAME_QUICK_SEARCH  @"Individual Name Search"
#define ORG_NAME_QUICK_SEARCH   @"Organization Name Search"

#define INDV_REMOVE_SEARCH  @"indvRemoveSearch"
#define ORG_REMOVE_SEARCH   @"orgRemoveSearch"

#define INDV_ADVANCED_SEARCH  @"indvAdvancedSearch"
#define ORG_ADVANCED_SEARCH   @"orgAdvancedSearch"

//User action type
#define USER_ACTION_TYPE        @"userActionType"
#define USER_ACTION_TAB        @"userActionTab"
#define USER_ACTION_TYPE_SEARCH @"userActionTypeSearch"
#define USER_ACTION_TYPE_ADD    @"userActionTypeAdd"
#define USER_ACTION_TYPE_REMOVE @"userActionTypeRemove"
#define USER_ACTION_TAB_TARGET    @"userActionTabTarget"

//---------------------------------------------------------------------------------------------------------
#pragma mark - UI String Constants

//Strings displayed on UI
#define INDIVIDUALS_STRING     @"Individuals"
#define ORGANIZATIONS_STRING    @"Organizations"
#define WELCOME_STRING          @"Welcome "
#define QUICK_SEARCH_TITLE_STRING     @"Search for Customers"
#define SEARCH_STRING       @"Search"
#define SEARCHING_FOR_MASTER_ID_STRING      @"Searching for Master ID"
#define SEARCHING_FOR_NPI_STRING            @"Searching for NPI"
#define ORG_NAME_STRING    @"Org Name"
#define INDV_QUICK_SEARCH_NAME_CRITERIA_STRING   @"First Name, Last Name and State"
#define ORG_QUICK_SEARCH_NAME_CRITERIA_STRING    @"Org Name and State"
#define SEARCH_CUSTOMERS_TAB_TITLE_STRING   @"Search Results"
#define ADDRESS_TYPE_STRING   @"Address Type"
#define SEARCH_TAB_REFINE_SEARCH_TITLE_STRING  @"Refine Search"
#define SEARCH_TAB_CREATE_AFFILIATION_STRING    @"Create Affiliation"
#define ADD_NEW_ADDRESS_TITLE_STRING    @"Add New Address"
#define ADD_NEW_INDV_TITLE_STRING     @"Add an Individual"
#define ADD_NEW_ORG_TITLE_STRING       @"Add an Organization"
#define SELECT_DUPLICATE_ADDRESS_TITLE_STRING        @"Select Duplicate Address"
#define ADVANCE_SEARCH_TITLE_STRING     @"Advanced Search"
#define REMOVE_CUSTOMER_TAB_TITLE_STRING    @"Remove"
#define APPROVE_CUSTOMER_TAB_TITLE_STRING    @"Approve Target Addresses"
#define APPROVE_CUSTOMER_TAB_BOTTOM_STRING    @"Review"
#define REMOVE_TAB_REFINE_SEARCH_TITLE_STRING     @"Remove"
#define APPROVE_TAB_REFINE_SEARCH_TITLE_STRING     @"Approve"
#define REASON_FOR_REMOVAL_POPOVER_TITLE_STRING     @"Select Reason for Customer Removal"
#define REASON_FOR_ADDRESS_REMOVAL_POPOVER_TITLE_STRING @"Select Reason for Address Removal"
#define REQUESTS_TAB_TITLE_STRING       @"Requests"
#define ADDRESS_STRING     @"Address"
#define STATUS_STRING     @"Status"
#define REQUESTOR_STRING  @"Requester"
#define TICKET_NUMBER_STRING  @"Ticket No"
#define REASON_FOR_REMOVAL_STRING     @"Reason for Removal"
#define REQUEST_DETAILS_STRING        @"Request Details"
#define REQUEST_TAB_REFINE_SEARCH_TITLE_STRING      @"Search for Requests"
#define LOGIN_SCREEN_TITLE_STRING       @"Login Screen"
#define LOGIN_STRING   @"Login"
#define SEARCH_CUSTOMERS_TAB_NAME_STRING    @"Search"
#define SELECT_TERRITORY_STRING     @"Select Territory"
#define PLEASE_SELECT_TERRITORY_STRING  @"Please select a territory"
#define LOAD_NEXT_XXX_TARGETS               @"Load next %3d targets for review"
#define TOP_50_RESULTS_STRING       @" Top 50 results are displayed."
#define TOP_XXX_RESULTS_STRING      @"Top %3d results are displayed."
#define SEARCH_MESSAGE_STRING       @"If the customer you are looking for is not listed, please use the Search button to find the customer."
#define LOAD_XXX_TARGETS            @"If the customer you are looking for is not listed, please click on \"Load next %3d targets for review\" at the bottom of the list."
#define LOAD_ONE_TARGET            @"If the customer you are looking for is not listed, please click on \"Load next 1 target for review\" at the bottom of the list."

#define TOP_50_SERACH_RESULTS   @"Top 50 results are displayed.\nIf the customer you are searching is not listed, please refine your search parameters."

#define MD_DETAIL_INFO_POPUP_TITLE  @"Affiliated MD Status"
#define MD_DETAIL_INFO_POPUP_DESCRIPTION    @"Cannot be detailed - no restrictions apply"
#define ADD_NEW_ADDRESS_SUCCESS_STRING  @"Your request to add a new address has been successfully received. To check the status of your request, please go to the 'Requests' tab."
#define ADD_NEW_CUSTOMER_SUCCESS_STRING @"Your request to add a new customer has been successfully received. To check the status of your request, please go to the 'Requests' tab."

#define NO_ALIGNED_ADDRESS_MSG  @"This HCP might be removed because there are no other aligned addresses in your territory. To avoid losing this customer, click the 'Add an Address' button and select another address."
#define NO_ALIGNED_REMOVAL_ADDRESS_MSG @"This HCP will be removed because there are no other aligned addresses in your territory."
#define NO_REMOVAL_ADDRESS_MSG  @"The selected address has been successfully removed."
#define INDV_NAME_STRING    @"Individual Name"
#define ORGANIZATION_NAME_STRING     @"Organization Name"
#define ACTION_DATE_STRING  @"Action Date"
#define WITHDRAW_STRING     @"Withdraw"
#define CANCEL_ACTIONS_STRING     @"Use this button to cancel all selections made for this customer."
#define WITHDRAW_REQUEST_ALERT_MSG_STRING   @"Do you want to withdraw the request?"
#define WITHDRAW_ADDRESS_REQUEST_ALERT_MSG_STRING   @"Withdraw address removal"

#define APPROVAL_STRING     @"A"
#define REJECTION_STRING    @"R"
#define WITHDRAWAL_STRING   @"W"

#define APPROVE_STRING      @"Approve"
#define ALIGN_APPROVE_STRING      @"Align and Approve"
#define APPROVE_REQUEST_ALERT_MSG_STRING    @"Approve address removal"
#define REJECT_STRING       @"Reject"
#define REJECT_REQUEST_ALERT_MSG_STRING     @"Reject address removal"

#define HCP_ALERT_MSG_STRING    @"This HCP has no other aligned address in your territory. If you and all other approvers approve this request, this customer will be removed from your territory. To avoid losing this customer and also to approve the address removal request, we recommend aligning a new address within your territory for this customer by clicking on  the Align and Approve option."

#define HCP_MSG_STRING    @"This HCP might be removed because there are no other aligned addresses in your territory.  To avoid losing this customer, you can align another address by clicking the Approve button and then choosing Align and Approve."

#define APPROVE_STATUS_MSG_STRING    @"This HCP is yet to be reviewed. Please approve or reject the addresse shown for this HCP. Your approval or rejection will be recorded into the system."


#define HCP_ALERT_TITLE         @"No Aligned Addresses"

#define CONFIRM_AFFILIATION_ALERT_TITLE     @"Confirm Affiliation"
#define CONFIRM_WITHDRAW_TITLE              @"Confirm Withdraw Action"
#define CONFIRM_AFFILLIATION_ALERT_MSG      @"Please confirm the selected MLP to MD affiliation"
#define REMOVE_CUSTOMER_ADDRESS_ALERT_TITLE     @"Remove Address"
#define REMOVE_CUSTOMER_ADDRESS_ALERT_MSG       @"Do you want to remove this address?"
#define REMOVE_CUSTOMER_ALERT_MSG       @"Customer removal request on behalf of territory will be submitted to CMEH. Please confirm."
#define CONFIRM_DUPLICATE_ADDRESSES_SELECTED_MSG    @"Are you sure you want to mark the selected addresses as duplicate."
#define ADDRESS_REMOVAL_STRING          @"Address Removal"
#define ADDRESS_REMOVAL_MESSAGE         @"The customer might be removed from your territory as you have selected all addresses for removal.  Please click OK to proceed."


#define ADDRESS_REMOVAL_ALL @"The customer would be removed from your territory as you have selected all addresses for removal. Please confirm"
#define ORGANISATION_REMOVAL_STRING     @"Do you want to remove this organisation?"
#define CONFIRM_DUPLICATE_ADDRESSES_SELECTED_TITLE  @"Address Removal"
//#define ADDRESS_REMOVAL_STRING                      @"Address Removal"
#define TABLE_HEADER_FOR_DUPLICATE          @"Addresses marked as duplicates will only be sent to BMS' customer master for review. If present in your CTU, they will not be removed as part of this request."

#define SELECT_ONE_DUPLICATE_ADDRESS    @"Please select at least one duplicate address."
#define ADDRESS_REMOVAL_STRING          @"Please click OK to submit the request for verification."
#define REMOVE_ADDRESS_TABLE_HEADER     @"Use ‘Select ALL’ Option, if HCP moved out of your territory."

#define ADD_STRING          @"Add"
#define REMOVE_STRING          @"Remove"
#define ALL_STRING          @"All"

#define ADD_CUSTOMER_STRING  @"Add Customer"
#define ADD_ADDRESS_STRING  @"Add Address"
#define ALIGN_CUSTOMER_STRING @"Align Customer"
#define REMOVE_CUSTOMER_STRING   @"Remove Customer"
#define REMOVE_ADDRESS_STRING   @"Remove Address"
#define ALL_STRING  @"All"

#define MOVED_OUT_OF_TERRITORY_STRING @"Moved out of territory"
#define MOOT_STRING         @"MOOT"

#define SSO_AUTHENTICATION_STRING   @"SSO Authentication"
#define LOADING_STRING  @"Loading..."
#define LOGGING_IN_STRING   @"Logging in..."
#define RETRY_STRING    @"Retry"
#define OK_STRING   @"OK"
#define YES_STRING  @"Yes"
#define NO_STRING   @"No"
#define LOGOUT_STRING   @"Logout"
#define ARE_YOU_SURE_YOU_WANT_TO_LOGOUT_STRING     @"Are you sure you want to logout?"
#define ABOUT_MAPS_STRING   @"About Maps"
#define CANCEL_STRING   @"Cancel"
#define CONFIRM_STRING  @"Confirm"

#define ZIP_DATABASE_STRING   @"ZIP Database"
#define PLEASE_WAIT_FETCHING_USER_ROLES_STRING     @"Please wait... Fetching user roles..."
#define PLEASE_WAIT_UPDATING_DATABASE_STRING     @"Please wait... Updating database..."
#define UPDATING_DATABASE_STRING    @"Updating Database"

#define ALL_ALIGNED_ADDRESSES_HAVE_BEEN_REMOVED_STRING     @"All aligned addresses have been removed."

#define SESSION_EXPIRED @"Session Expired"
#define REQUEST_STATUS_PENDING  @"Pending"
#define PLEASE_SELECT_STATE @"Please select State"
#define PLEASE_SELECT_CITY_OR_STATE   @"Please select City or State"
//#define RETRY_STRING    @"Retry"
#define NOTE_REMOVE_SINGLE_ADDRESS  @"Removing the single address entry will result in removing the customer"

#define PRODUCT_STRING @"Product"
#define MLP_STATUS_STRING   @"MLP Status"


#define REQUEST_TYPE_WITHDRAW   @"WithdrawRemoveAddress"
#define REQUEST_TYPE_ALIGN_NEW_ADDRESS   @"AlignNewAddress"
#define REQUEST_TYPE_APPROVE    @"ApproveRemoveAddress"
#define REQUEST_TYPE_REJECT     @"RejectRemoveAddress"

//--------------------------------------------------------------------------------------------------------
#pragma mark - Error/Success String Constants

//Error or success messages displayed on UI
#define ERROR_NO_RECENT_CHANGES     @"No recent changes found."
#define ERROR_REQUEST_COULD_NOT_COMPLETE_TRY_AGAIN      @"Your request could not be completed at this time, please try again later."
#define ERROR_PROVIDE_ALL_REQUIRED_FIELDS   @"Please provide all the required fields."
#define ERROR_ENTER_ONLY_LETTERS      @"Please enter only letters. No numbers or special characters."
#define ERROR_SEARCH_FORM_NO_FIELD_ENTERED  @"State and any other input field are required."
#define ERROR_SEARCH_FORM_ONLY_STATE_IS_ENTERED     @"Along with the 'State', please provide at least one more search criteria."
#define ERROR_ZIP_IS_NUMERIC  @"ZIP is a numeric value. No letters, spaces or special characters.  "
#define ERROR_ZIP_MUST_CONTAIN_5_DIGITS     @"ZIP must contain 5 digits.  "
#define ERROR_PROVIDE_VALID_ZIP     @"Please provide a valid ZIP for selected State and/or City. "
#define ERROR_ALL_IDS_ARE_NUMERIC   @"All IDs are numeric only. No letters, spaces or special characters.  "
#define ERROR_PLEASE_PROVIDE_AT_LEAST_2_LETTERS   @"Please provide at least 2 letters for the"
#define ERROR_SUFFIX_IS_ALPHA_NUMERIC  @"Please enter only numbers and letters for Suffix . No special characters.  "
#define ERROR_CONTAINS_ONLY_LETTERS_AND_NUMBERS     @"can only contain letters(A-Z) and numbers(0-9). "
#define ERROR_CONTAINS_ONLY_LETTERS_NUMBERS_SPACE_AND_DASH     @"can only contain letters(A-Z), numbers(0-9) along with spaces and dash(-)."
#define ERROR_ADDRESS_LINE_1_CONTAINS_LETTERS_NUMBERS_SPACE_DASH_AMPERSAND       @"Address Line 1 can only contain letters(A-Z), numbers(0-9) along with spaces, dash(-) and ampersand(&). "
#define ERROR_TICKET_NUMBER_IS_NUMERIC  @"Ticket Number is a numeric field. No letters, spaces or special characters.  "
#define ERROR_PROVIDE_MASTER_OR_NPI_ID  @"Please provide a Master ID or NPI ID."
#define ERROR_PROVIDE_MASTER_ID  @"Please enter a valid Master ID"
#define ERROR_PROVIDE_VALID_MASTER_OR_NPI_ID      @"Master ID and NPI ID are numbers. Please provide at least one valid value."
#define ERROR_PROVIDE_VALID_MASTER_ID   @"Master ID is a number. Please provide a valid value."
#define ERROR_PROVIDE_VALID_NPI_ID  @"NPI ID is a number. Please provide a valid value."
#define ERROR_MASTER_ID_DOES_NOT_EXIST     @"Selected Master ID does not exist. Please select another ID."
#define ERROR_NPI_DOES_NOT_EXIST    @"Selected NPI does not exist. Please select another ID."
#define ERROR_ID_DOES_NOT_EXIST     @"Selected ID does not exist. Please select another ID."
#define ERROR_MINIMUM_2_CHAR_FOR_FIRST_AND_LAST_NAMES   @"Please provide at least 2 letters for the First and Last names."
#define ERROR_MINIMUM_2_CHAR_FOR_FIRST_NAME     @"Please provide at least 2 letters for the First name."
#define ERROR_MINIMUM_2_CHAR_FOR_LAST_NAME      @"Please provide at least 2 letters for the Last name."
#define ERROR_MINIMUM_2_CHAR_FOR_ORG_NAME       @"Please provide at least 2 letters for the Organization name."
#define ERROR_PENDING_CUST_VALIDATION       @"The customer is pending validation from source"
#define ERROR_ADD_ADDRESS_FAILED        @"Address add failed. Please try again."
#define ERROR_ADD_TO_TERRITORY_FAILED   @"Add to territory failed. Please try again."
#define ERROR_ADD_CUSTOMER_FAILED       @"Customer add failed. Please try again."
#define ERROR_NO_RESULTS_FOUND_TRY_AGAIN    @"No results found. Please modify your search criteria and try again."
#define ERROR_NO_RESULTS_FOUND_MODIFY_SEARCH_OR_ADD_NEW_CUSTOMER @"No results found. Please modify your search criteria or to add a new customer, please select the “Add New Customer” button."
#define ERROR_REMOVE_CUSTOMER_FAILED        @"Request to remove customer failed. Please try again."
#define ERROR_UNABLE_TO_LOAD_REQUESTS       @"Unable to load requests at this time. Please try again later."

#define ERROR_SSO_AUTHENTICATION_FAILED_NO_TOKEN    @"SSO Authentication failed, Token not received"
#define ERROR_SSO_AUTHENTICATION_FAILED     @"Authentication failed"

#define ERROR_DATABASE_CANT_BE_COPIED  @"Database cannot be copied successfully. \nDo you want to retry?"
#define ERROR_DATABASE_CANT_BE_UPDATED  @"Database updation failed. \nDo you want to retry?"
#define ERROR_PROVIDE_VALID_USERNAME_AND_PASSWORD   @"Please provide a valid Username and Password"
#define ERROR_USER_CAN_NOT_BE_VERIFIED_CONTACT_HELP_DESK    @"User cannot be verified at this time. Please try again or contact the Help Desk for further assistance."
#define ERROR_DO_YOU_WANT_TO_RETRY  @"Do you want to retry?"
#define ERROR_UNKNOWN_PLEASE_RETRY  @"Unknown error occurred. Please try again."

#define ERROR_NO_ZIP_FOUND      @"No ZIP found"
#define ERROR_NO_CITY_FOUND     @"No City found"
#define ERROR_NO_STATE_FOUND    @"No State found"
#define ERROR_NO_BU_FOUND    @"No Business unit found"
#define ERROR_NO_TEAM_FOUND    @"No Team found"
#define ERROR_NO_TERR_FOUND    @"No Territory found"
#define ERROR_NO_SELECTION_AVAILABLE    @"No selection available"

//--------------------------------------------------------------------------------------------------------
#pragma mark - Miscellaneous

//Strings used as KEY
#define INDIVIDUALS_KEY @"Individuals"
#define ORGANIZATIONS_KEY    @"Organizations"
#define LOGOUT_KEY  @"session"

#define CONNECTION_TIMEOUT  60*3 //180.0 //Sec
#define MAX_SEARCH_RESULT_COUNT   50
#define ONE_HUNDRED_RECORDS   100
#define TWO_HUNDRED_RECORDS   200
#define THEME_COLOR [UIColor colorWithRed:0.0/255.0 green:87.0/255.0 blue:156.0/255.0 alpha:1.0]
#define ERROR_LABEL_TAG 1012
#define CLEAR_VIEW_ERROR_LABEL  @"ClearViewErrorLabel"
#define CLEAR_CELL_ERROR_LABEL  @"ClearCellErrorLabel"
#define ERROR_NO_INTERNET_CONNECTION_RETRY  @"Check your Internet connection and try again."
#define ERROR_REQUEST_TIMED_OUT_TRY_AGAIN   @"Request timed out. Please try again."

#define TEXT_INPUT_MIN_CHAR_LIMIT   2

#define DATE_FORMATTER_STYLE    NSDateFormatterFullStyle

//User Roles LOV
#define USER_ROLES_KEY       @"userRolesKey"
#define USER_ROLE_MA_MSL     @"userRoleMAMSL"
#define USER_ROLE_SALES_REP  @"userRoleSalesRep"

#define USER_ROLE_ID_MSL    @"008"
#define USER_ROLE_ID_MA    @"011"

//--------------------------------------------------------------------------------------------------------
#pragma mark - Logger
//Logger
//DEBUG: defined for Debug builds in build settings
//ERRORLOGS: defined for Release builds in build settings

//For release build, print only error logs which capture error, exceptions and thread's lifecycle
//ERROR LOGS
#if (ERRORLOGS || DEBUG)
#define ErrorLog(...) NSLog(@"%@", [NSString stringWithFormat:__VA_ARGS__])
#else
#define ErrorLog(...) do { } while (0)
#endif

//For debug build, print all logs
//DEBUG is defined in build settings
//DEBUG LOGS
#if DEBUG
#define DebugLog(...) NSLog(@"%@", [NSString stringWithFormat:__VA_ARGS__])
#else
#define DebugLog(...) do { } while (0)
#endif

//--------------------------------------------------------------------------------------------------------


#pragma mark - Devices Versions Supported

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define iOS7_0 @"7.0"

//---------------------------------------------------------------------------------------------------------
#endif
