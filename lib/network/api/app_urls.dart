// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import '../../utils/utils.dart';

class AppUrls {
  AppUrls._();

  static const int ITEM_COUNT = 20;

  static String BASE_URL = Flavor.I.get(Keys.base);

  static String DVR_BASE_URL = Flavor.I.get(Keys.dvr);

  static const AI_BASE_URL = 'https://ai.cronysoft.com:444/';

  static const GENERATE_DVR_STREAM = 'Media/ReceiptVideo';
  static const GENERATE_DVR_STREAM_FOR_DEVICE = 'Media/ReceiptVideoForDevice';
  static const STOP_DVR_STREAM = 'Media/DiscardReceiptVideo';

  static const AI_QUERY = 'queryData/';
  static const AI_UPDATE_QUERY = 'updateData/';

  // Authenticate
  static const REQUEST_TRAINING = 'Account/SaveTrainingDemo';
  static const FILE_COMPLAINT = 'Trainings/FileComplaint';
  static const GET_LOGIN_ANIMATION = 'Account/GetLottieAssetByPriority';
  static const POST_LOGIN_USER = 'Account/Authenticate';
  static const VERIFY_OTP = 'Account/VerifyOTPByEmail';
  static const GET_REVOKE_ID = 'Account/RevokeByID';
  static const GET_REVOKE_TOKEN = 'Account/RevokeByToken';
  static const GET_SESSIONS = 'Account/UsersSessionList';
  static const GET_MEETING_INFO = 'Account/GetMeetingInformation';

  static const GET_ACTIVITY_INFO = 'Account/HitTest';
  static const UPDATE_PRESENCE = 'Account/UserPresense';
  static const MENU_CHANGE = 'Account/MenuChange';
  static const REFRESH_TOKEN = 'Account/RefreshToken';

  static const EMP_MISMATCH_LIST = 'Account/GetEmployeeMismatchInfos';
  static const EMP_MISMATCH_DETAILS = 'Account/GetEmployeeMismatchDetail';
  static const EMP_MISMATCH_MERGE = 'Account/MergeEmployeeMisMatch';
  static const SAVE_MISMATCH_EMP_DETAILS =
      'Account/SaveUpdateEmployeeMisMatchDetails';

  static const GET_COLUMNS = 'Global/GetUserColumnSettingsByAccessId';
  static const SET_COLUMNS = 'Global/SaveUserColumnSettings';
  static const SEND_TO_POS_BULK = 'Global/SendToPOSBulk';
  static const SEND_TO_QUEUE_BULK = 'SendToPOS/SendToQueueBulk';

  static const GET_APP_SETTINGS = 'Global/GetUserAppSettingsByAccessId';
  static const SET_APP_SETTINGS = 'Global/SaveUserAppSettings';

  static const POST_REGISTER_USER_BY_EMAIL = 'Account/Registration';
  static const POST_FORGET_PASS = 'Account/ForgetPassword';
  static const GET_SWITCH_ACCOUNT = 'Account/ChangeDefaultStore';
  static const USER_REGISTRATION_BY_TOKEN = 'Account/UserRegistrationByToken';
  static const ADD_USER_TO_STORE = 'Account/AddUserToStore';
  static const GET_ATTENDANCES = 'Account/attendances';
  static const GET_LATEST_ATTENDANCES = 'Account/GetLatestAttendanceActivities';
  static const CHECK_PIN_STATUS = 'Account/check-pin';

  // Profile
  static const GET_USER_QR_CODE = 'Account/CreateUserAuthInvitationCode';
  static const GET_USER_ROLES = 'UserAccess/GetUserLevels';
  static const POST_CHANGE_PASS = 'Account/ChangePassword';
  static const VERIFY_PASSWORD = 'Account/VerifyPassword';
  static const UPDATE_PIN = 'Account/UpdatePin';
  static const VERIFY_PIN = 'Account/VerifyPin';
  static const RESET_PIN = 'Account/ResetPin';
  static const RESET_PASSWORD = 'Account/ResetPassword';
  static const REGISTER_FACE =
      'https://cronyfacelive.azurewebsites.net/AddFace';
  static const POST_CHANGE_PIN = 'Global/UpdateDataByKeyValue';
  static const GET_STATES = 'Global/GetStates';
  static const GET_FILE_TYPES = 'GlobalImport/GetAllTemplates';
  static const POST_UPDATE_PROFILE = 'Account/UpdateUserDetails';

  static const GET_PREFERRED_LANGUAGES = 'Account/GetPreferredLanguages';
  static const UPDATE_PREFERRED_LANGUAGES =
      'Account/UpdateUserPreferredLanguage';

  static const VALIDATE_NEW_QR = 'Account/ValidRequestQR';
  static const AUTHORIZE_NEW_QR = 'Account/SetRequestQR';

  // PLU Group
  static const GET_PLU_DATA = 'Plugroups/GetList';
  static const GET_PLU_DROPDOWN = 'PluGroups/GetDropdownList';
  static const GET_ITEMS_LIST = 'Items/GetShortList';
  static const GET_ITEM_MOVEMENT_SUMMARY =
      "Items/GetItemsMovementSummaryByItemIds";
  static const GET_ITEM_MOVEMENT_DETAIL =
      "Items/GetItemsMovementDetailByItemId";
  static const GET_ITEM_SHELF_LIST = 'Global/GetShelfCodesForDropdown';
  static const SCAN_BY_BARCODE = 'Items/ScanByBarcode';
  static const SAVE_PLU_GROUP = 'Plugroups/SaveWithItemsList';
  static const DELETE_PLU_GROUP = 'Plugroups/Delete';
  static const PLU_DETAILS = 'Plugroups/GetDetailsWithItemsListByID';
  static const GET_IMAGES = 'Global/GetImagesFromLibrary';
  static const PLU_GROUPS_SUMMARY = 'Plugroups/PLUGroupsSummary';
  static const UPLOAD_IMAGE = 'Global/UploadImage';
  static const PLU_DELETE_MULTIPLE_GROUPS = 'Plugroups/DeleteMultiple';
  static const SEND_TO_POS_PLU_GROUP = 'Plugroups/SendToPOS';
  static const COMPARE_PLU_GROUPS = 'Plugroups/GetDropdownList';

  static const GET_PLU_GROUPS_PROMO = 'Global/GetPromoPluGroupsForDropdown';
  static const SET_PLU_GROUPS_PROMO = 'PLUGroups/RunImport';

  // Screen status
  static const CREATE_TICKET = 'Tickets/Create';
  static const WRITE_FEEDBACK = 'Global/WriteFeedBack';
  static const GET_ACCESS_BY_CATEGORY =
      'UserAccess/GetUserAccessControlListByCategory';
  static const GET_ACCESS_BY_ROLE =
      'UserAccess/GetUserAccessControlListByLevelID';

  static const GET_ACCESS_BY_GROUP = 'UserAccess/GetUserGroupAccessList';
  static const SET_USER_ACCESS_GROUP_CONTROL =
      'UserAccess/UpdateUserGroupAccessType';

  static const SAVE_USER_LEVEL = 'UserAccess/SaveUserLevel';
  static const DELETE_USER_LEVEL = 'UserAccess/DeleteUserLevel';
  static const SET_USER_ACCESS_CONTROL = 'UserAccess/SetUserAccessControl';
  static const SET_USER_MULTI_ACCESS_CONTROL =
      'UserAccess/SetUserAccessControlBulk';
  static const CLONE_USER_BY_LEVEL = 'UserAccess/CloneLevelByID';
  static const UPDATE_SUBSCRIPTION = 'UserAccess/UpdateSubscriptionStatus';
  static const GET_RATING = 'Global/GetRatting';
  static const SET_RATING = 'Global/CreateRatting';
  static const TUTORIALS = 'WebTutorials/GetList';
  static const GET_TUTORIAL_BY_ID = 'WebTutorials/GetSourceByID';
  static const GET_LOGS = 'Global/GetLogs';

  // Department
  static const GET_DEPARTMENTS_LIST = 'Departments/GetList';
  static const GET_DEPARTMENTS_LIST_V2 = 'Departments/GetListVer2';
  static const GET_DEPARTMENTS_DROPDOWN = 'Departments/GetDropdownList';
  static const GET_DEPARTMENT_SUMMARY = 'Departments/Summary';
  static const DELETE_DEPARTMENT = 'Departments/Delete';
  static const SAVE_DEPARTMENT = 'Departments/Save';
  static const GET_DEPARTMENT_DETAIL = 'Departments/GetDetails';
  static const GET_MEMBER_OF_GROUPS = 'MainDepartments/GetDropdownList';
  static const DEPARTMENT_SEND_TO_POS = 'Departments/SendToPOS';
  static const GET_DEPARTMENT_OVERVIEW = 'Departments/GetDepartmentOverview';
  static const COMPARE_DEPARTMENTS = 'Departments/GetCompare';
  static const DEPT_GET_INVENTORY = 'Departments/GetInventory';
  static const DEPT_GET_ITEM_INVENTORY = 'Departments/GetItemInventorybyDept';
  static const DEPT_GET_NACS = 'Global/GetDepartmentNacsForDropdown';

  // Department 2
  static const GET_DEPARTMENTS_2_LIST = 'SubDepartments/GetList';
  static const GET_DEPARTMENTS_2_DROPDOWN = 'Subdepartments/GetDropdownList';
  static const DELETE_DEPARTMENT_2 = 'SubDepartments/Delete';
  static const SAVE_DEPARTMENT_2 = 'SubDepartments/Save';
  static const GET_DEPARTMENT_2_DETAIL = 'SubDepartments/GetDetails';

  // Inventory Department
  static const GET_INV_DEPT_DROPDOWN =
      'Global/GetInventoryDepartmentsForDropdown';
  static const GET_INV_DEPT = 'InventoryDepartment/get-all';
  static const SAVE_INV_DEPT = 'InventoryDepartment/insert-update';
  static const DELETE_INV_DEPT = 'InventoryDepartment/delete';

  // Expense Category
  static const GET_EXPENSE_CATEGORIES = 'Category/get-all';
  static const GET_EXPENSE_CATEGORIES_DROPDOWN = 'Checks/GetCheckCategory';
  static const SAVE_EXPENSE_CATEGORY = 'Category/insert-update';
  static const DELETE_EXPENSE_CATEGORY = 'Category/delete';
  static const GET_ACCOUNTS_DROPDOWN = 'Category/chart-of-account-ddl';
  static const GET_MAIN_CAT_DROPDOWN = 'Category/main-categories';

  // Merchants
  static const GET_MERCHANTS = 'Merchant/get-all';
  static const SAVE_MERCHANT = 'Merchant/insert-update';
  static const DELETE_MERCHANT = 'Merchant/delete';
  static const SET_DEFAULT_MERCHANT = 'Merchant/UpdateDefaultMerchant';
  static const GET_MERCHANT_DEFAULT_BANK = 'Merchant/GetDefaultMerchantBank';

  // Altria Details
  static const GET_LIST_DATA = 'ListData/get-all';
  static const GET_DETAIL_ID = 'ListData/get-by-id';
  static const DELETE_LIST_DATA_ITEM = 'ListData/delete';
  static const SAVE_LIST_DATA_ITEM = 'ListData/insert-update';

  // Kitchen Printer
  static const GET_KITCHEN_PRINTER_LIST = '${_KITCHEN_PRINTER}get-all';
  static const DELETE_KITCHEN_PRINTER_ITEM = 'delete';
  static const SAVE_KITCHEN_PRINTER_ITEM = '${_KITCHEN_PRINTER}insert-update';

  // Item  Schedule
  static const GET_ITEM_SCHEDULE_LIST = '${_ITEM_SCHEDULE}get';
  static const GET_ITEM_SCHEDULE_DROPDOWN = '${_ITEM_SCHEDULE}dropdown';
  static const GET_ITEM_SCHEDULE_DETAILS = '${_ITEM_SCHEDULE}details';
  static const DELETE_ITEM_SCHEDULE_ITEM = '${_ITEM_SCHEDULE}delete';
  static const SAVE_ITEM_SCHEDULE_ITEM = '${_ITEM_SCHEDULE}insert-update';

  // Sales Tax
  static const GET_SALES_TAX_LIST = '${_SALES_TAX}GetAll';
  static const GET_SALES_TAX_DETAILS = '${_SALES_TAX}GetById';
  static const SAVE_SALES_TAX = '${_SALES_TAX}SaveUpdate';
  static const PAY_SALES_TAX = '${_SALES_TAX}Pay';

  // Import Module
  static const DESIGN_MAP = 'ImportingTool/ReadFileForDesign';
  static const SAVE_IMPORT = 'GlobalImport/SaveGlobalImport';
  static const UPDATE_IMPORT = 'GlobalImport/UpdateGlobalImport';
  static const GET_TEMPLATE = 'GlobalImport/GetTemplateById';
  static const DELETE_TEMPLATE = 'GlobalImport/DeleteGlobalImport';
  static const Read_File_For_Preview = 'ImportingTool/ReadFileForPreview';
  static const SAVE_IMPORT_ITEMS = 'ImportingTool/SaveImportData';
  // static const SAVE_IMPORT_ITEMS = 'ImportingTool/SaveImportItems';
  // static const SAVE_IMPORT_PURCHASEORDER =
  //     'ImportingTool/SaveImportPurchaseOrder';
  // Store Settings
  static const GET_STORE_DETAILS = 'StoresSetup/GetStoreDetails';
  static const SET_STORE_DETAILS = 'StoresSetup/SetStoreDetails';
  static const SET_BANK_DETAILS = 'StoresSetup/SetPlaidInformation';
  static const GET_TAX_LIST = 'Tax/GetList';
  static const GET_TERMS_AND_POLICY = 'Account/GetTermsAndPolicy';

  // Send to Pos
  static const GET_SEND_TO_POS_STORES =
      'Global/GetCorporateStoresByUserForDropdown';
  static const GET_SEND_TO_POS = 'StoresSetup/GetSendToStoreSettings';
  static const SAVE_SEND_TO_POS = 'StoresSetup/SaveSendToStoreSettings';

  // DVR Settings
  static const GET_DVR_SETTING = 'StoresSetup/GetRtspSettingForReceipts';
  static const GET_DVR_TYPE_DROP_DOWN = 'Global/GetDvrTypesForDropdown';
  static const UPDATE_DVR_SETTING = 'StoresSetup/SaveRtspSettingForReceipts';

  static const GET_TAX_DROPDOWN = 'Tax/GetDropdownList';
  static const GET_LABEL_DESIGN_BY_ID = 'Items/GetLabelDesignByID';
  static const STORE_PUSH_TO_POS = 'StoresSetup/PushAllToPOS';
  static const CLEAN_UP_ITEMS = 'StoresSetup/CleanupItems';
  static const CREATE_UPDATE_TAX_INFO = 'Tax/Save';
  static const DELETE_TAX_INFO = 'Tax/Delete';

  static const GET_REMOTE_PRINTERS = 'StoresSetup/RegisteredUSBPrinters';

  // Store Documents
  static const Get_Subcategory_List_By_Screen_ID =
      'Documents/GetSubcategoryListByScreenID';
  static const GET_LIST_BY_SCREEN_ID = 'Documents/GetListByScreenID';
  static const UPLOAD_DOCUMENT = 'Documents/UploadDocument';
  static const DELETE_STORE_DOCUMENT = 'Documents/DeleteDocument';
  static const GET_STORE_DOCUMENTS = 'Documents/GetStoreDocuments';
  static const READ_DOCUMENT = 'Documents/ReadByID';
  static const CONVERT_WORD_TO_PDF = 'Global/ConvertDocument';
  static const GET_Employee_DOCUMENTS = 'Documents/GetEmployeeDocuments';

  // Smart Search
  static const GET_GLOBAL_SEARCH_DATA = 'Global/GlobalSearch';

  // Send mail
  static const SEND_EMAIL = 'Global/SendEmail';

  // Dashboard
  static const GET_DASHBOARD_CARDS = 'Dashboards/GetCardsData';
  static const GET_DASHBOARD_RECEIPTS = 'Dashboards/GetLiveReceipts';
  static const GET_MONTHLY_REPORT_GRAPH = 'Dashboards/GetWeekWiseReportByMonth';
  static const GET_CLOCK_IN_INFO = 'Dashboards/GetClockInEmployees';
  static const GET_DASHBOARD_HOURLY_SALES = 'Dashboards/GetHourlySales';
  static const GET_GAS_SALES = 'Dashboards/GetGasList';
  static const GET_GRADE_SALES = 'Dashboards/grade-sales';
  static const GET_INVOICES_HOLD = 'Dashboards/GetItemHoldList';
  static const GET_HOLD_DETAILS = 'Dashboards/ItemHoldDetails';
  static const GET_DASHBOARD_COMPARISON = 'Dashboards/comparision';
  static const GET_HLS_VIDEO = 'hls/start';

  // Vendors
  static const GET_VENDORS = 'Vendors/GetList';
  static const GET_VENDORS_DROPDOWN = 'Vendors/GetDropdownList';
  static const GET_VENDOR_DETAILS = 'Vendors/GetDetails';
  static const DELETE_VENDOR = 'Vendors/Delete';
  static const SAVE_VENDOR = 'Vendors/Save';
  static const SEND_TO_POS_VENDOR = 'Vendors/SendToPOS';
  static const GET_VENDOR_SUMMARY = 'Vendors/Summary';
  static const GET_VENDOR_OVERVIEW = 'Vendors/GetVendorOverview';
  static const COMPARE_VENDORS = 'Vendors/GetCompare';
  static const SALES_BY_ITEM_HISTORY = 'Items/GetSaleByItemHistory';
  static const GET_EDI_FORMATS = 'Global/GetEDIFormatsForDropdown';

  static const GET_VENDOR_INVENTORY_CARDS =
      'Vendors/GetInventoryCardsDataForDashboard';
  static const GET_VENDOR_MARGIN = 'Vendors/GetMarginsForDashboard';
  static const GET_VENDOR_SALES_VS_PURCHASE =
      'Vendors/GetSalesVsPurchasesQtyGraphForDashboard';
  static const GET_VENDOR_VS_SALE_COMPARISON =
      'Vendors/GetSalePurcComparisonForDashboard';
  static const GET_VENDOR_MARGINS_BY_VENDORS =
      "Vendors/GetMarginsByVendorsForDashboard";

  static const GET_EXPENSE_PLANNER_DATA = 'ExpensePlanner/GetAllExpensePlanner';
  static const GET_EXPENSE_DATA_PLANNER =
      'ExpensePlanner/GetExpenseListForPlanner';
  static const GET_BUDGET_LIST_PLANNER =
      'ExpensePlanner/GetBudgetListForPlanner';
  static const GET_BUDGET_OVERVIEW_GRAPH = 'ExpensePlanner/BudgetOverviewGraph';
  static const GET_EXPENSE_PLANNER_CATEGORIES =
      "ExpensePlanner/GetCategoryList";
  static const GET_STORE_HOURS_DATA = "ExpensePlanner/GetStoreHourlyValue";
  static const SAVE_EXPENSE_PLANNER_DATA = 'ExpensePlanner/SaveExpensePlanner';
  static const UPDATE_EXPENSE_PLANNER_DATA =
      'ExpensePlanner/UpdateExpensePlanner';
  static const BULK_UPDATE_EXPENSE_PLANNER_DATA =
      "ExpensePlanner/SaveBulkExpensePlanner";
  static const SAVE_STORE_HOURS_DATA = "ExpensePlanner/SaveStoreHoursValue";
  static const DELETE_EXPENSE_PLANNER_DATA =
      'ExpensePlanner/DeleteExpensePlanner';

  // Mix & Match
  static const GET_MIX_AND_MATCH = 'MixNMatch/GetList';
  static const GET_MIX_AND_MATCH_DROPDOWN = 'MixNMatch/GetDropdownList';
  static const GET_MIX_AND_MATCH_DETAILS = 'MixNMatch/GetDetails';
  static const DELETE_MIX_AND_MATCH = 'MixNMatch/Delete';
  static const SAVE_MIX_AND_MATCH = 'MixNMatch/Save';
  static const MULTI_DELETE_MIX_AND_MATCH = 'MixNMatch/DeleteMultiple';
  static const SEND_TO_POS_MIX_AND_MATCH = 'MixNMatch/SendToPOS';
  static const GET_MIX_MATCH_SUMMARY = 'MixNMatch/Summary';
  static const GET_PROMOS_DROPDOWN = 'Global/GetPromoPackagesForDropdown';
  static const IMPORT_PROMO = 'MixNMatch/RunImport';

  static const GET_COMBO_DEALS = 'MixNMatch/GetComboDeals';
  static const SAVE_COMBO_DEALS = 'MixNMatch/SaveUpdateComboDeal';
  static const DELETE_COMBO_DEALS = 'MixNMatch/DeleteCombos';

  // User Invitation
  static const GET_USER_INVITATION_LIST = 'Account/GetUsersInvitationList';
  static const CREATE_USER_INVITATION =
      'Account/UpdateTempDataByInvitationCode';
  static const DELETE_USER_INVITATION_MULTIPLE =
      'Account/DeleteTempDataMultiple';

  // Shell Location
  static const SHELL_LOCATION = 'items/UpdateItemShelf';

  // Employee Listing
  static const EMPLOYEE_LISTING = 'Account/GetEmployeesListOfCurrentStore';

  // TODO : REMOVE NOT USED
  static const CHANGE_USER_LEVEL = 'Account/ChangeUserLevel';
  static const LOOKUP_EMPLOYEE_EMAIL = 'Account/LookupEmployeeByEmailAddress';
  static const ADD_EMPLOYEE_EMAIL = 'Account/AddEmployeeByEmailAddress';
  static const ADD_EMPLOYEE_BY_USERNAME = 'Account/SaveUpdateUser';
  static const EMPLOYEE_SEND_POS = 'Account/SendToPOS';
  static const DELETE_EMPLOYEE_FROM_CURRENT_STORE =
      'Account/DeleteEmployeFromCurrentStore';
  static const GET_USER_GROUPS = 'Account/GetUserGroups';
  static const GET_EMPLOYEE_DETAIL_BY_ID =
      'Account/GetEmployeesDetailsByUserID';
  static const UPDATE_EMPLOYEE_DETAIL_USER_ID =
      'Account/UpdateEmployeesDetailsByUserID';
  static const UPDATE_EMPLOYEE_IMAGE = 'Account/upload-employee-photo';
  static const GET_EMPLOYEE_OVERVIEW_BY_ID = 'Account/GetEmployeeOverviewByID';
  static const GET_FED_TAX = 'W4/W4Function';
  static const GET_EMPLOYEE_STORES = 'Account/GetEmployeeStores';

  // Advance Payroll
  static const GET_ADVANCE_PAY_ROLL_DATA = 'Account/GetAdvancePayroll';
  static const ADVANCE_PAY_ROLL_DATA = 'Account/AdvancePayRollData';
  static const GET_TENDER_TYPE = 'Account/GetTenderType';
  static const GET_TRANSACTION_TYPE = 'Account/GetTransactionType';
  static const SAVE_ADVANCE_PAYROLL = 'Account/SaveAdvancePayroll';

  // Store Setup
  static const GET_ALL_STORE_SERVICE = 'StoreServices/GetAllStoreServices';
  static const GET_ALL_STORE_INFO = 'StoresSetup/store-info';
  static const GET_ALL_TANKS = 'Tank/all';
  static const GET_ALL_STORE_DEPT = 'POSDepts/GetAllPOSDepts';
  static const GET_ALL_STORE_TAX = 'POSTax/GetAllPOSTax';
  static const SAVE_TANKS = 'Tank/insert-or-update';
  static const SAVE_GRADE = 'FuelGradeMixing/fuel-setup-grades';
  static const GET_GRADE = 'FuelGradeMixing/get-grades';
  static const GET_GAS_TYPE = 'FuelGradeMixing/get-gas-types';
  static const DELETE_TANKS = 'Tank/delete';
  static const TANK_DROP_DOWN = 'Tank/tank-dropdown-list';
  static const SAVE_STORE_SETUP_SETTING = 'StoresSetup/UpdateStoreSetup';

  // Esl Tags
  static const GET_ESL_TAGS_LIST = 'ESLTags/GetList';
  static const REMOVED_ESL_TAG_FROM_ITEM = 'ESLTags/RemoveESLTagFromItem';
  static const ASSIGNED_ESL_TAG_TO_ITEM = 'ESLTags/AssignESLTagToItem';

  // Bulk Scan
  static const BULK_SCAN_ACTION = 'items/BulkScan';
  static const BULK_SCAN_Items_Summary = 'Items/Summary';
  static const BULK_SCAN_ITEMS_LISTING = 'Items/ItemsListing';
  static const BULK_SCAN_ITEMS_DEPT = 'Items/GetItemCountsByDepartments';
  static const BULK_SCAN_DELETE_MULTIPLE_ITEMS = 'Items/DeleteMultipleItems';
  static const UPDATE_ITEM_FIELD = 'Items/UpdateItemField';
  static const UPDATE_ITEM_QUICK_PRICE = 'Items/UpdateQuickPriceChange';

  static const ITEM_LOTS_GET_LIST = 'ItemLots/GetList';
  static const ITEM_LOTS_SAVE = 'ItemLots/Save';
  static const TPR_FILE_TEMPLATE_LIST = 'Items/TPRFileTemplateList';
  static const TPR_File_Read_By_Template_ID = 'Items/TPRFileReadByTemplateID';
  static const TPR_SAVE = 'Items/TPRSave';
  static const GET_ITEM_LABEL_DETAILS = 'Items/GetItemLabels';
  static const COMPARE_ITEMS = 'Items/GetCompare';
  static const GET_ITEM_BY_STORES = 'Corporate/GetOtherStoresItemByItemSno';
  static const SET_ITEM_BY_STORES = 'Corporate/UpdateOtherStoresItem';

  static const GET_CORP_DASHBOARD = 'Corporate/GetStoresWiseData';

  static const GET_STORE_SALES_BY_ITEM = 'Corporate/sales-by-item-in-each-store';

  // Sync Stores
  static const GET_STORES_BY_KEY =
      'Corporate/GetPendingCountsForSendToStoreByKey';
  static const SYNC_STORES_BY_KEY = 'Corporate/ApplySyncToStores';

  // Reports
  static const GET_REPORT = 'Reports/GetReport';

  // Items
  static const GET_ITEM_DETAILS = 'Items/GetItemDetails';
  static const IS_ITEM_EXIST = 'Items/is-item-exist';
  static const POST_SAVE_ITEM = 'Items/SaveItem_v2';
  static const GET_BARCODE_EXIST = 'Items/IsBarcodeExist';

  // TODO : REMOVE Not USED
  static const GET_INVENTORY = 'Items/GetInventoryGroupsDropdown';
  static const GET_TAG_ALONG_ITEM = 'Items/GetTagAlongItemsDropdown';
  static const GET_KITCHEN_PRINTER = 'Items/GetKitchenPrinterDropdown';
  static const GET_REBATE_GROUP = 'Items/GetRebateGroupsDropdown';
  static const GET_MANUFACTURER = 'Items/GetManufacturerDropdown';
  static const GET_SMART_MENU = 'Items/GetSmartMenusDropdown';

  static const DELETE_SUBSTITUTE = 'Items/DeleteItemSubstitute';
  static const DELETE_COMPOSITE = 'Items/DeleteItemComposite';

  static const GET_ADDON_GROUPS = 'ItemsAddonGroups/GetList';
  static const GET_ADDON_ITEMS = 'ItemsAddonGroups/GetItemList';
  static const POST_SAVE_ADDON = 'ItemsAddonGroups/Save';
  static const GET_ADDONS = 'ItemsAddonGroups/GetGroupsListByItemID';

  static const GET_ITEM_SEND_POS = 'Items/SendToPOS';
  static const GET_DELETE_ITEM = 'Items/DeleteItem';

  static const GET_RETRIEVE_GROUPS = 'Items/GetScanGroupsWithItemsList';
  static const ITEMS_OVERVIEW = 'Items/ItemsOverview';
  static const SALES_BY_ITEM_ID = 'Items/SalesByItemID';
  static const PURCHASES_BY_ITEM_ID = 'Items/PurchasesByItemID';
  static const COMPARISON_BY_ITEM_ID = 'Items/ComparisonByItemID';
  static const Logs_By_Item_ID = 'Items/LogsByItemID';
  static const GET_DEAL_LIST = 'Items/DealDropDown';
  static const GET_ALL_DROP_DOWN = 'ListData/get-all-dropdown';

  // Tool Box
  static const GET_DB_INTEGRITY_STATUS = 'Tools/DatabaseIntegrity';
  static const GET_DATA_ENTRY_ISSUES = 'Tools/GetDataEntryIssues';
  static const GET_DEVICE_LIST = 'Tools/GetDeviceList';
  static const GET_NOTIFICATIONS = 'Global/GetNotifications';

  // Support Tickets
  static const GET_SUPPORT_TICKETS = 'Tickets/GetList';
  static const GET_SUB_CATEGORY_DROP_DOWN =
      'Tickets/GetSubcategoryListDropdown';
  static const CREATE_TICKET_V2 = 'Tickets/Create_v2';
  static const DELETE_TICKET = 'Tickets/DeleteTicket';
  static const GET_NOTES_BY_TICKET = 'Tickets/GetNotesByTicket';
  static const ADD_TICKET_NOTE = 'Tickets/AddTicketNote';

  // Live Receipts
  static const GET_LIVE_RECEIPTS = 'Dashboards/LiveReceipt';
  static const GET_LIVE_RECEIPT_DETAIL_BY_ID = 'Dashboards/ReceiptDetails';
  static const GET_RECEIPTS = 'Dashboards/GetReceipts';

  // Live Receipts
  static const GET_PAYMENT_TYPE = 'Reports/get-payment-types';
  static const GET_FIND_RECEIPTS = 'Reports/get-all-receipts';

  // Registers
  static const GET_REGISTERS_LIST = 'Registers/GetList';
  static const GET_REGISTER_SUMMARY = 'Registers/GetSummaryList';
  static const GET_GENERAL_POS_SETTING = 'POSSettings/get';
  static const SAVE_GENERAL_POS_SETTING = 'POSSettings/update';
  static const ADD_REGISTER = 'Registers/insert';
  //pos template

  static const GET_POS_TEMPLATE = 'POSMenuTemplateV2/GetPOSTemplateForDropDown';
  static const SAVE_POS_TEMPLATE = 'POSMenuTemplateV2/CreatePOSTemplate';
  static const SAVE_POS_MENU_BUTTON = 'POSMenuTemplateV2/SavePOSButtonDetail';
  static const DELETE_POS_MENU_BUTTON = 'POSMenuTemplateV2/DeletePOSButton';
  static const SAVE_POS_MENU_TEMPLATE =
      'POSMenuTemplateV2/CreatePOSMenuTemplate';

  static const GET_BANKS_LISTING = 'BankSetup/GetList';
  static const GET_BANKS_DROPDOWN = 'BankSetup/GetBanksDropdown';
  static const ADD_EDIT_BANK = 'BankSetup/Save';
  static const DELETE_BANK = 'BankSetup/Delete';
  static const BANK_DETAILS = 'BankSetup/GetDetails';
  static const GET_BANK_BOOK_BALANCE = 'BankSetup/GetBookAndBankBalance';

  // Check Book
  static const CHECK_BOOK_LIST = 'Checks/CheckBook';
  static const PAYEE_NAMES = 'Checks/GetDailyBookVendors';
  static const UPDATE_CHECK_FIELD = 'Checks/UpdateByFieldName';
  static const CHECK_RECONCILE_LIST = 'Checks/GetCheckReconcile';
  static const CHECK_VERIFICATION_LIST = 'Checks/CheckBookVerifications';
  static const BANK_ADJUSTMENT_LIST = 'Checks/GetBankBalance';
  static const BANK_TRANSFER = 'Checks/BankTransfer';
  static const BANK_ADJUST = 'Checks/BankAdjust';
  static const BANK_BALANCE_LOGS = 'Checks/GetBankBalanceLogsByDate';
  static const WRITE_CHECK = 'Checks/NewCheck';
  static const GET_PAYROLL_CHECKS = 'Checks/GetPayrollChecks';
  static const GET_CHECKS_AND_DEPOSITS = 'Checks/CheckAndDepositSummary_v2';
  static const MANUAL_SALES_REPORT = "Reports/GetDeptManualSalesSummary";
  static const MANUAL_SALES_REPORT_DETAIL = "Reports/GetDeptManualSalesDetails";
  static const TAX_AUDIT_REPORT_BOOK = "Reports/GetTaxReportByBook";
  static const TAX_AUDIT_REPORT_POS = "Reports/GetTaxReportByPOS";
  static const CASHIER_AUDIT_REPORT = "Reports/GetCashierAuditSummary";
  static const CASHIER_AUDIT_REPORT_DETAIL = "Reports/GetCashierAuditDetail";
  static const SALE_PURCHASE_BY_CATEGORY = "Reports/SalePurchaseByCategory";
  static const SALE_PURCHASE_DETAIL_BY_CATEGORY =
      "Reports/SalePurchaseDetailByCategory";
  static const SUB_DEPARTMENT_REPORT = "Reports/SubDepartmentReport";
  static const SUB_DEPARTMENT_DETAIL_REPORT =
      "Reports/SubDepartmentDetailReport";
  static const MAIN_DEPARTMENT_REPORT = "Reports/MainDepartmentReport";
  static const MAIN_DEPARTMENT_DETAIL_REPORT =
      "Reports/MainDepartmentDetailReport";

  static const GET_TIME_CLOCK_HOURS = 'Checks/GenerateListFromHoursByDates';
  static const GET_PAYROLL_CHECKS_SUMMARY = 'Checks/Summary';
  static const GET_CHECK_DETAILS = 'Checks/CheckPreview';
  static const GET_DEFAULT_CATEGORY = 'Checks/GetDefaultCategory';
  static const GET_NEXT_CHECK_NO = 'Checks/GetNewCheckNumberByBank';
  static const DELETE_CHECKS = 'Checks/ChecksDeleteByIds';
  static const UPDATE_CHECK = 'Checks/UpdateChecks';
  static const EDIT_CHECK = 'Checks/UpdateCheckBook';
  static const CHECK_LOGS = 'Checks/GetLogs';
  static const PRINT_CHECKS = 'Checks/PrintChecks';

  // Shop
  static const GET_SHOP_SUBCATEGORIES = 'CronyStore/service-sub-types';
  static const GET_SHOP_PRODUCTS = 'CronyStore/get-all';
  static const GET_SHOP_CART_ITEMS = "Shop/view-cart";
  static const SHOP_ADD_TO_CART = "Shop/add-to-cart";
  static const SHOP_DELETE_CART_ITEMS = "Shop/delete-cart-items";
  static const SHOP_CHECKOUT = "Shop/checkout";
  static const SHOP_CALCULATE_TAX = 'Shop/calculate-tax';

  // Schedule
  static const GET_USER_DEPARTMENTS = 'EmployeeSchedule/GetUserDepartments';
  static const SAVE_WORKING_DEPARTMENT = 'Departments/SaveUserDepartment';
  static const SYNC_USER_DEPARTMENT = 'Departments/SyncDepartment';
  static const GET_EMP_SCHEDULES = 'EmployeeSchedule/GetEmployeesSchedules';
  static const GET_EMP_SCHEDULES_BY_ID =
      'EmployeeSchedule/GetEmployeeSchedulesByUserId';
  static const POST_SAVE_SCHEDULE = 'EmployeeSchedule/Save';
  static const DELETE_SCHEDULES = 'EmployeeSchedule/DeleteSchedule';
  static const TRANSFER_SCHEDULES = 'EmployeeSchedule/TransferToOtherEmployee';
  static const REQUEST_SCHEDULE_CHANGE =
      'EmployeeSchedule/RequestScheduleChange';
  static const POST_CLONE_SCHEDULE = 'EmployeeSchedule/CloneSchedule';
  static const POST_CLONE_SCHEDULE_BY_EMP =
      'EmployeeSchedule/CloneScheduleByEmployee';
  static const POST_CLONE_BY_SCHEDULES = 'EmployeeSchedule/CloneBySchedules';

  // Purchase Order
  static const GET_PO_LIST = 'PurchaseOrders/GetVendorsPurchaseList';
  static const GET_AVAILABLE_PO = 'Global/GetPurchaseOrdersForDropdown';
  static const GET_AVAILABLE_CHECKS = 'Checks/GetAvailableChecks';

  static const GET_PO_DETAIL = 'PurchaseOrders/GetVendorsPurchaseDetailByID';

  static const CREATE_PURCHASE_ORDER = 'PurchaseOrders/CreatePO';

  static const CREATE_PO_READ_EDI = 'PurchaseOrders/ReadEDIFileWithVendor';
  static const CREATE_PO_WITH_EDI = 'PurchaseOrders/CreatePOwithEDI';
  static const CREATE_PO_GET_AUTO_GENERATE_FIELDS_DATA =
      'PurchaseOrders/GetVendorGenerateOrderDetailsByVendorID';
  static const CREATE_PO_AUTO_GENERATE_PREVIEW = 'PurchaseOrders/PreviewOrder';
  static const CREATE_PO_AUTO_GENERATE = 'PurchaseOrders/GenerateOrder';
  static const CREATE_PO_EXTERNAl = 'PurchaseOrders/CreateCustomOrder';

  static const UPDATE_PURCHASE_ORDER_BY_ID =
      'PurchaseOrders/UpdatePurchaseOrderByID';

  static const GET_MANUAL_ENTRIES_BY_PURCHASE_ORDER =
      'PurchaseOrders/GetManualEntriesByPurchaseOrder';
  static const SAVE_MANUAL_ENTRIES =
      'PurchaseOrders/SaveManualEntriesByPurchaseOrder';
  static const ADD_PURCHASE_DETAIL_ENTRY = 'PurchaseOrders/AddDetailEntry';
  static const UPDATE_PO_ENTRY_DETAIL_BY_ID =
      'PurchaseOrders/UpdatePurchaseDetailByID';
  static const UPDATE_PURCHASE_ENTRY_BY_ID =
      'PurchaseOrders/UpdatePurchaseEntryByID';

  static const GET_SAME_PLU_ENTRIES =
      'PurchaseOrders/GetPluItemsByItemIDAndPluID';
  static const SAVE_SAME_PLU_ENTRIES =
      'PurchaseOrders/SetPriceAndCostByPluIDAndItemID';

  static const GET_SAME_INVENTORY_ENTRIES =
      'PurchaseOrders/GetInventoryGroupItems';
  static const SAVE_SAME_INVENTORY_ENTRIES =
      'PurchaseOrders/SetPriceAndCostByInventoryGroupIdAndItemID';

  static const GET_INVOICE_TEMPLATES = 'ImportingTool/GetInvoiceModalList';
  static const GET_TEMPLATE_DETAILS = 'ImportingTool/GetAIInvoiceById';
  static const READ_RECEIPT = 'ImportingTool/ReadDataFromImage';
  static const FETCH_ITEM_DETAILS = 'ImportingTool/GetItemByCodeandName';

  // static const GET_VENDOR_LIST = 'Vendors/GetList';
  static const GET_PO_Summary = 'PurchaseOrders/Summary';
  static const DELETE_PO = 'PurchaseOrders/DeletePurchaseOrder';
  static const DELETE_MULTIPLE_PO = 'PurchaseOrders/DeleteMultiple';
  static const DELETE_PO_ORDER_DETAIL =
      'PurchaseOrders/DeletePurchaseOrderDetail';

  static const DELETE_MULTIPLE_PO_DETAILS =
      'PurchaseOrders/DeleteMultipleDetail';

  static const COMMIT_PURCHASE_ORDER = 'PurchaseOrders/CommitPurchaseOrder';

  static const REOPEN_PURCHASE_ORDER = 'PurchaseOrders/ReopenPurchaseOrder';

  static const GET_PO_INFO_SUMMARY = 'PurchaseOrders/PoInfoSummary';
  static const GET_PO_INFO_NEW_ITEMS = 'PurchaseOrders/PoInfoNewItems';
  static const GET_PO_INFO_COST_CHANGE = 'PurchaseOrders/PoInfoCostChange';
  static const GET_PO_INFO_RETAIL_CHANGE = 'PurchaseOrders/PoInfoRetailChange';
  static const GET_PO_ITEMS_FOR_PRINTING = 'PurchaseOrders/PoInfoItemsForPrint';
  static const GET_PO_LOGS = 'PurchaseOrders/GetLogsByPO';
  static const GET_PO_INFO_REBATE_ITEMS =
      'PurchaseOrders/GetRebateItemsForPoInfo';

  static const GET_PO_REPORT_SUMMARY = 'PurchaseOrders/PoReportSummary';

  static const GET_PO_BY_VENDORS = 'PurchaseOrders/PoReportByVendors';
  static const GET_PO_BY_VENDOR = 'PurchaseOrders/PoByVendor';
  static const GET_PO_ITEMS_BY_VENDOR = 'PurchaseOrders/PoItemsByVendor';

  static const GET_PO_BY_DEPARTMENTS = 'PurchaseOrders/PoReportByDepartments';
  static const GET_PO_ITEM_BY_DEPARTMENT = 'PurchaseOrders/PoItemsByDepartment';
  static const GET_PO_BY_ITEM = 'PurchaseOrders/PoByItems';

  static const GET_PO_PAY_DUE_LIST = 'PurchaseOrders/PayDueList';
  static const GET_PO_PENDING_CHECKS = 'Checks/ChecksByVendor';
  static const PO_PAY_SAVE = 'PurchaseOrders/SaveVendorPayments';
  static const ASSIGN_CHECKS_TO_PO =
      'PurchaseOrders/AssignUnAssignChecksFromPO';
  static const ASSIGN_PO_TO_CHECK = 'PurchaseOrders/AssignUnAssignCheckToPOs';

  static const GET_PO_PAY_HISTORY = 'PurchaseOrders/PaymentHistories';
  static const GET_PO_CHECK_DETAILS = 'PurchaseOrders/PoCheckDetails';
  static const GET_BOTTLE_DEPOSITS = 'Items/GetItemsByBottleDepositDepartment';

  static const PO_SEND_INVOICE = 'PurchaseOrders/SendEmailOfScannedItems';
  static const PO_SAVE_INVOICE = 'PurchaseOrders/AddBulkItemsToPO';

  static const POST_CURRENT_EMP_SCHEDULE =
      'EmployeeSchedule/GetCurrentEmployeeSchedules';

  // Lottery
  static const GET_TICKET_ORDERS = 'Loteries/GetOrdersList';
  static const GET_LOTTERY_DETAILS = 'Loteries/GetOrderDetails';
  static const GET_LOTTERY_SUMMARY_BY_WEEK = 'Loteries/LotterySummaryByWeek';
  static const GET_LOTTERY_DETAILS_SUMMARY = 'Loteries/GetLotteryOrderSummary';
  static const ADD_TICKET_TO_ORDER = 'Loteries/OrderAddDetail';
  static const SAVE_NEW_LOTTERY = 'Loteries/SaveLotteryGame';
  static const SAVE_TICKET_ORDER = 'Loteries/OrderSave';
  static const UPDATE_TICKET_DETAILS = 'Loteries/UpdateOrderDetails';
  static const COMMIT_TICKET_ORDER = 'Loteries/CommitOrder';
  static const REOPEN_TICKET_ORDER = 'Loteries/ReopenConfirmedStock';
  static const DELETE_TICKET_ORDER = 'Loteries/OrderDelete';
  static const DELETE_MULTIPLE_TICKET_ORDER = 'Loteries/DeleteMultiple';

  static const UPDATE_LOTTERY_BY_BARCODE =
      'Loteries/UpdateLotteryDetailsByBarcode';

  static const GET_REVENUE_BY_TYPE = "Loteries/GetRevenueByTypeForDashboard";
  static const GET_TOTAL_VS_SOLD_AMOUNT =
      "Loteries/GetTotalVsSoldTicketAmountsForDashboard";
  static const GET_SOLD_VS_SETTLE_AMOUNT =
      "Loteries/GetSoldVsSettled_ForDashboard";

  static const GET_SOLD_TICKET_BY_PRICE =
      "Loteries/GetSoldTicketsByPriceForDashboard";
  static const GET_TOP_PERFORM_BY_PRICE =
      "Loteries/GetTopPerformByPriceForDashboard";
  static const GET_LOTTERY_SUMMARY =
      "Loteries/GetSummaryByDailyReportForDashboard";

  static const GET_LOTTERY_STOCKS = 'Loteries/GetStocks';
  static const GET_LOTTERY_STOCKS_DETAILS = 'Loteries/GetLotteryStockDetails';

  static const SET_LOTTERY_STATUS = 'Loteries/SetStockActiveOrSettle';
  static const SET_LOTTERY_STATUS_TO_SETTLE =
      'Loteries/UpdateLotteryStatusToSettle';
  static const LOTTERY_BULK_ACTIVATE = 'Loteries/ActivateBulk';

  static const GET_DAILY_ENTRIES_DAY = 'Loteries/EntriesByDay';
  static const GET_DAILY_ENTRIES_MONTH = 'Loteries/EntriesByMonth';
  static const GET_DAILY_LOTTERIES = 'Loteries/GetLotteryList';
  static const SCAN_DAILY_ENTRY = 'Loteries/LotteryScan';
  static const BULK_SCAN_DAILY_ENTRY = 'Loteries/LotteryBulkScan';
  static const SCAN_LOTTERY_BY_BARCODE = 'Loteries/GetStockByBarcode';
  static const GET_DAILY_ENTRY_DETAILS =
      'Loteries/GetLotteryStockDetailsByDateAndType';
  static const SKIP_ALL_DAY = 'Loteries/SkipDay';
  static const CLOSE_DAY = 'Loteries/CloseDay';
  static const EDIT_BOX_END = 'Loteries/UpdateEntryEndNo';

  static const GET_DAILY_RETURNS = 'Loteries/LotteryReturnsList';
  static const SCAN_DAILY_RETURN = 'Loteries/LotteryReturnAdd';
  static const ROLLBACK_DAILY_RETURN = 'Loteries/DailyReturnRollback';

  static const LOTERIES_SUMMARY = 'Loteries/Summary';
  static const LOTTERY_SUMMARY = 'Loteries/LotterySummary';
  static const LOTTERY_UPDATE_BY_FIELD_NAME = 'Loteries/UpdateByFieldName';

  static const GET_LOTTERY_SETTINGS = 'Loteries/GetGlobalSettings';
  static const SET_LOTTERY_SETTINGS = 'Loteries/SetGlobalSettings';
  static const GET_WEIGHT_SCALE_LISTING = 'WeightScale/get';
  static const SET_WEIGHT_SCALE = 'WeightScale/create-update';
  static const DELETE_WEIGHT_SCALE = 'WeightScale/delete';

  // Whitelist Ips
  static const GET_WHITELIST_IPS = 'Account/GetStoreIPList';
  static const DELETE_WHITELIST_IP = 'Account/DeleteIpList';
  static const SAVE_WHITELIST_IP = 'Account/SaveIpList';

  // Time Clock
  static const GET_TIME_CLOCK_USERS = 'TimeClock/GetSummaryList';
  static const TIME_CLOCK_REPORT = 'TimeClock/report-clockin-clockout';
  static const GET_EMPLOYEES = 'TimeClock/EmployeeDropDown';
  static const GET_USER_ENTRIES = 'TimeClock/GetList';
  static const GET_MY_ENTRIES = 'TimeClock/GetCurrentEmployeeList';
  static const SAVE_NEW_ENTRY = 'TimeClock/Save';
  static const DELETE_ENTRY = 'TimeClock/Delete';
  static const VERIFY_ENTRY = 'TimeClock/verifyentries';
  static const DISPUTE_ENTRY = 'Timeclock/add-dispute';
  static const REFRESH_TIME_CLOCK = 'TimeClock/time-clock-status';
  static const VERIFIED_ENTRIES_COUNT =
      'TimeClock/GetUnVerifiedEntriesCountCurrentEmployee';

  static const GEN_DEVICE_PIN = 'Timeclock/generate-device-pin';

  // Interactive dashboard
  static const SALES_DASHBOARD_SUMMARY = 'SalesDashboard/GetSales';
  static const SALES_DASHBOARD_ALL_SALES = 'SalesDashboard/GetAllSales';
  static const GET_TRANSACTION_DATA = 'SalesDashboard/GetTransactionData';
  static const GET_RETURNS_DATA = 'SalesDashboard/GetReturnsData';
  static const GET_ADJUSTMENT_DATA = 'SalesDashboard/GetAdjustmentData';
  static const DELETE_ADJUSTMENT_DELETE = 'Items/DeleteInventoryAdjust';
  static const GET_VOIDS_DATA = 'SalesDashboard/GetVoidsData';
  static const GET_DEPARTMENT_SALES = 'SalesDashboard/GetDepartmentSales';
  static const Get_Single_Department_Sales_Data =
      'SalesDashboard/GetsingleDepartmentSalesData';
  static const GET_CHANGE_PRICE_DATA = 'SalesDashboard/GetchangePriceData';
  static const GET_SINGLE_EMPLOYEE_VOIDS_DATA =
      'SalesDashboard/GetsingleEmployeeVoidsData';
  static const GET_EMPLOYEE_WISE_VOIDS_DATA =
      'SalesDashboard/GetEmployeeWiseVoidsData';

  // Item Report Apis
  static const GET_ITEM_SALES = 'SalesDashboard/GetsummarySalesData';
  static const GET_ITEM_VOIDS = 'SalesDashboard/GetsummaryVoidData';
  static const GET_ITEM_RETURNS = 'SalesDashboard/GetReturnsDataByItem';
  static const GET_ITEM_ADJUSTMENTS = 'SalesDashboard/GetAdjustmentDataByItem';
  static const GET_ITEM_PRICE_CHANGE =
      'SalesDashboard/GetChangePriceDataByItem';

  // Petty Cash
  static const GET_PETTY_CASH_LIST = 'PettyCash/GetList';
  static const GET_PETTY_CASH_CATEGORY = 'PettyCash/GetCategory';
  // static const GET_PETTY_CASH_AMOUNT_TYPE = 'PettyCash/GetAmountType';
  static const PETTY_CASH_DELETE = 'PettyCash/Delete';
  static const PETTY_CASH_SAVE = 'PettyCash/Save';
  static const GET_USER_LOGS = 'TimeClock/GetLogs';

  // Customers
  static const GET_CUSTOMERS_LIST = '${_CUSTOMER}GetCustomersList';
  static const GET_ALL_CUSTOMERS_DROP_DOWN_LIST =
      '${_CUSTOMER}Customers_GetAll';
  static const DELETE_CUSTOMERS = '${_CUSTOMER}customerDelete';
  static const UNBLOCK_CUSTOMERS = '${_CUSTOMER}unblock-customer';

  static const GET_CUSTOMERS_DETAIL = '${_CUSTOMER}GetListCustomerbyID';
  static const GET_PRICE_TEMPLATE = '${_CUSTOMER}GetPriceTemplate';

  static const GET_ACCOUNT_TYPE = '${_CUSTOMER}GetAccountType';
  static const SAVE_CUSTOMERS = '${_CUSTOMER}Save';
  static const GET_DUE_HISTORY = '${_CUSTOMER}GetDueHistory';
  static const SAVE_PRICE_TEMPLATE = '${_CUSTOMER}SavePriceTemplate';
  static const GET_ALL_DUES = '${_CUSTOMER}get-all-dues';
  static const SAVE_PAY_DUES = '${_CUSTOMER}pay-dues';
  static const SAVE_CUSTOMER_CREDIT_MEMO = '${_CUSTOMER}save-credit-memo';
  static const GET_CUSTOMER_CREDIT_MEMO = '${_CUSTOMER}get-credit-memos';
  static const DELETE_CUSTOMER_CREDIT_MEMO = '${_CUSTOMER}delete-credit-memo';

  static const GET_CUSTOMER_DASHBOARD_SUMMARY =
      '${_CUSTOMER}GetCardsDataForDashboard';
  static const GET_CUSTOMER_BY_LOYALTY_POINT =
      '${_CUSTOMER}GetTop5ByLoyaltyPointsForDashboard';
  static const GET_RETENTION_BY_MONTH =
      '${_CUSTOMER}GetRetentionByMonthForDashboard';
  static const GET_CUSTOMER_RETENTION =
      '${_CUSTOMER}GetRetentionVsNewCustomersForDashboard';
  static const GET_ONE_TIME_CUSTOMER_BY_MONTH =
      '${_CUSTOMER}GetOneTimeCustomerByMonthForDashboard';
  static const GET_CUSTOMER_DUE_REPORT =
      '${_CUSTOMER}GetPaidVsDueByMonthForDashboard';
  static const GET_PROFITS_BY_MONTH =
      '${_CUSTOMER}GetProfitsByMonthForDashboard';
  static const GET_CUSTOMER_LOYALTY_LIST =
      '${_CUSTOMER}GetLoyaltyListForDashboard';
  static const GET_CUSTOMER_DUE_LIST = '${_CUSTOMER}GetDueListForDashboard';
  static const GET_CUSTOMER_REPORT_LIST =
      '${_CUSTOMER}GetReportListForDashboard';

  // Sub End Point
  static const _ATM_DASHBOARD = "ATM/";
  static const _CUSTOMER_PRICING = "CustomerPricing/";
  static const _CUSTOMER_ESTIMATE = "CustomerEstimate/";
  static const _CUSTOMER = "Customer/";
  static const _STORE_TRANSFER = "StoreTransfer/";
  static const _PAYROLL_DASHBOARD = "PayRollDashboard/";
  static const _REPORT = "Reports/";
  static const _DAILY_BOOK = "DailyBook/";
  static const _BANK_RECONCILIATION = "BankReconcilation/";
  static const _PLAID_INTEGRATION = "PlaidIntegration/";
  static const _DEPARTMENTS = "Departments/";
  static const _PROFIT_LOSS = "ProfitLoss/";
  static const _CHECK_CASHING = "CheckCashing/";
  static const _GLOBAL = "Global/";
  static const _SUBSCRIPTION_PACKAGE = "SubscriptionPackages/";
  static const _SUBSCRIPTION_ENROLLED = "SubscriptionEnrolled/";
  static const _MERCHANT_APPLICATION = "MerchantApplication/";
  static const _MERCHANT_ACCOUNT_CHANGE = "MerchantAccountChange/";
  static const _MERCHANT_TAX_ID_CHANGE = "MerchantNameChange/";
  static const _PAYMENT = "Payments/";
  static const _REPORT_CENTER = "ReportCenter/";
  static const _REPORTS = "Reports/";
  static const _GAS_FEE_CATEGORY = "GasFeeCategory/";
  static const _MONEY_ORDER_SETUP = "MoneyService/";
  static const _SALES_TAX = "SaleTax/";
  static const _KITCHEN_PRINTER = "KitchenPrinter/";
  static const _ITEM_SCHEDULE = "ItemSchedule/";

  // Daily Task Module
  static const GET_DAILY_TASK_LIST = '${_REPORT}GetDailyTasks';

  // Customer Pricing
  static const GET_CUSTOMERS_TEMPLATE_LIST =
      '${_CUSTOMER_PRICING}get-price-templates';
  static const GET_CUSTOMERS_PRICING_LIST = '${_CUSTOMER_PRICING}pricing-list';
  static const GET_ITEM_BY_TEMPLATE_ID_LIST =
      '${_CUSTOMER_PRICING}items-by-template-id';
  static const SAVE_CUSTOMERS_PRICING_TEMPLATE =
      '${_CUSTOMER_PRICING}save-edit-price-template';
  static const CREATE_CUSTOMERS_PRICING_TEMPLATE =
      '${_CUSTOMER_PRICING}add-update-customer-pricing';
  static const DELETE_CUSTOMERS_PRICING_TEMPLATE =
      '${_CUSTOMER_PRICING}delete-template';
  static const DELETE_CUSTOMERS_PRICING_TEMPLATE_ITEM =
      '${_CUSTOMER_PRICING}delete-pricing';

  // Customer Estimate
  static const GET_CUSTOMERS_ESTIMATE_LIST =
      '${_CUSTOMER_ESTIMATE}get-all-estimates';
  static const GET_CUSTOMERS_RETURN_ESTIMATE_LIST =
      '${_CUSTOMER_ESTIMATE}get-by-customer-id';
  static const GET_ALL_CUSTOMERS_LIST =
      '${_CUSTOMER_ESTIMATE}get-all-customers';
  static const GET_ESTIMATE_DETAILS_LIST =
      '${_CUSTOMER_ESTIMATE}get-estimates-details';
  static const CREATE_CUSTOMER_ESTIMATE = '${_CUSTOMER_ESTIMATE}save-update';
  static const COMMIT_CUSTOMER_ESTIMATE = '${_CUSTOMER_ESTIMATE}commit';
  static const COMMIT_RETURN_INVOICE = '${_CUSTOMER_ESTIMATE}commit-return';
  static const DELETE_CUSTOMER_ESTIMATE = '${_CUSTOMER_ESTIMATE}delete';
  static const DELETE_RETURN_INVOICE = '${_CUSTOMER_ESTIMATE}delete-return';
  static const REOPEN_INVOICE = '${_CUSTOMER_ESTIMATE}delete-return';
  static const DELETE_CUSTOMER_ESTIMATE_ITEM =
      '${_CUSTOMER_ESTIMATE}delete-items';
  static const EDIT_CUSTOMER_ESTIMATE_ITEM =
      '${_CUSTOMER_ESTIMATE}update-details';
  static const GET_ALCOHOL_TAG = '${_CUSTOMER_ESTIMATE}get-tag';
  static const SAVE_ALCOHOL_TAG = '${_CUSTOMER_ESTIMATE}save-update-tag';
  static const DELETE_ALCOHOL_TAG = '${_CUSTOMER_ESTIMATE}delete-tag';

  // State Alcohol Reporting
  static const GET_ALCOHOL_REPORTING_LIST = '${_CUSTOMER_ESTIMATE}report';

  // Store Transfer
  static const GET_TRANSFER_STORE_LIST =
      '${_STORE_TRANSFER}get-corporate-stores';
  static const GET_SCAN_GROUP_LIST = '${_STORE_TRANSFER}scanned-groups';
  static const GET_STORE_TRANSFER_INVOICE_LIST = '${_STORE_TRANSFER}listing';
  static const GET_STORE_TRANSFER_DETAILS = '${_STORE_TRANSFER}store-details';
  static const CREATE_STORE_TRANSFER = '${_STORE_TRANSFER}save-update';
  static const COMMIT_STORE_TRANSFER = '${_STORE_TRANSFER}commit';
  static const DELETE_STORE_TRANSFER = '${_STORE_TRANSFER}delete';
  static const RESEND_STORE_TRANSFER = '${_STORE_TRANSFER}resend';

  // PayRollDashboard OverView Module
  static const GET_PAYROLL_COUNT = '${_PAYROLL_DASHBOARD}counts';
  static const GET_TIME_OFF_GRAPH = '${_PAYROLL_DASHBOARD}time-off-graph';
  static const GET_PAYROLL_CHECK_OVERVIEW_GRAPH =
      '${_PAYROLL_DASHBOARD}pay-roll-check-overview';
  static const GET_PAYROLL_EXPENSE_GRAPH =
      '${_PAYROLL_DASHBOARD}pay-roll-expense';
  static const GET_EMPLOYEE_RATE_GRAPH = '${_PAYROLL_DASHBOARD}employee-rate';
  static const GET_OVERTIME_PER_DEPARTMENT_GRAPH =
      '${_PAYROLL_DASHBOARD}overtime-per-department';
  static const GET_OVERTIME_DISTRIBUTION_GRAPH =
      '${_PAYROLL_DASHBOARD}overtime-distribution-cost-graph';
  static const GET_TOTAL_PAYROLL_DETAILS =
      '${_PAYROLL_DASHBOARD}pay-roll-details';
  static const GET_EXPENSE_PAYROLL_DETAILS =
      '${_PAYROLL_DASHBOARD}pay-roll-expense-details';
  static const GET_DEPARTMENT_PAYROLL_DETAILS =
      '${_PAYROLL_DASHBOARD}pay-roll-dept-details';
  static const GET_OVERTIME_PER_DEPARTMENT_DETAILS =
      '${_PAYROLL_DASHBOARD}overtime-dept-details';
  static const GET_PAYROLL_BY_MAIN_DEPT =
      '${_PAYROLL_DASHBOARD}PayrollGraphByMainDepartment';
  static const GET_PAYROLL_OVERTIME_BY_MAIN_DEPT =
      '${_PAYROLL_DASHBOARD}PayrollOvertimeGraphByMainDepartment';
  static const GET_TOP_PAYROLL = '${_PAYROLL_DASHBOARD}PayrollGridData';
  static const GET_TOP_OVERTIME =
      '${_PAYROLL_DASHBOARD}OvertimePayrollGridData';

  // Atm Dashboard Module
  static const ATM_SUMMARY_COUNT = '${_ATM_DASHBOARD}counts';
  static const GET_ALL_ATM = '${_ATM_DASHBOARD}get-all';
  static const GET_ATM_TYPE = '${_ATM_DASHBOARD}get-atm-types';
  static const ADD_EDIT_ATM = '${_ATM_DASHBOARD}add-update';
  static const ACTIVE_DE_ACTIVE_ATM = '${_ATM_DASHBOARD}activate-de-activate';
  static const GET_TRANSACTION_OVERVIEW =
      '${_ATM_DASHBOARD}transaction-overview-graph';

  static const GET_FEE_PROFIT_OVERVIEW = '${_ATM_DASHBOARD}atm-fees-graph';
  static const GET_FEE_PROFIT_OVERVIEW_DETAILS =
      '${_ATM_DASHBOARD}fee-profit-details';
  static const GET_TRANSACTION_OVERVIEW_DETAIL =
      '${_ATM_DASHBOARD}transaction-overview-graph-details';
  static const GET_METRICS_DETAIL = '${_ATM_DASHBOARD}performance-metrics';
  static const GET_BUSIEST_DAY = '${_ATM_DASHBOARD}busiest-days';
  static const GET_ATM_TRANSACTION_HISTORY =
      '${_ATM_DASHBOARD}transaction-history';
  static const GET_ATM_VENDOR_DETAIL = '${_ATM_DASHBOARD}vendor-details';
  static const GET_ATM_VENDOR = '${_ATM_DASHBOARD}vendors';
  static const GET_ATM_DROPDOWN = '${_ATM_DASHBOARD}GetAllAtmForDropdown';

  // Scan Data Module
  static const _SCAN_DATA = "Altria/";
  static const GE_SCAN_LIST = '${_SCAN_DATA}scans';
  static const GET_AGENCIES_LIST = '${_SCAN_DATA}get-global-reporting-agencies';
  static const ADD_AGENCY = '${_SCAN_DATA}add-agency';
  static const GET_PRODUCT_LIST = '${_SCAN_DATA}products';
  static const ADD_SCAN_DATA_PRODUCT = '${_SCAN_DATA}add-products';
  static const DELETE_SCAN_DATA_PRODUCT = '${_SCAN_DATA}remove-products';
  static const GET_RETRIEVE_PRODUCT = '${_SCAN_DATA}retrieve-altria-products';
  static const GET_SYNC_ALTRIA_DATA =
      '${_SCAN_DATA}update-altria-entries-from-server';
  static const GET_PRODUCT_DETAILS = '${_SCAN_DATA}product-items';
  static const GET_REPORTING_SALES_LIST = '${_SCAN_DATA}reporting-sales';
  static const MSA_SALES_REPORT = '${_SCAN_DATA}generate-msa-report';
  static const ALTRIA_SALES_REPORT = '${_SCAN_DATA}generate-altria-report';
  static const CIRCANA_SALES_REPORT = '${_SCAN_DATA}generate-circana-report';
  static const GET_REPORTING_SALES_DETAILS =
      '${_SCAN_DATA}reporting-sales-details';
  static const GET_REPORTING_SALES_HISTORY = '${_SCAN_DATA}reporting-history';
  static const GET_SCAN_COMPANY_SUMMARY_COUNT = '${_SCAN_DATA}overview';
  static const GET_COMPANY_SUMMARY = '${_SCAN_DATA}summary';
  static const GET_SCAN_COMPANY_AMOUNT_OVERVIEW =
      '${_SCAN_DATA}amount-overview-graph';
  static const GET_SCAN_COMPANY_PROMO_OVERVIEW =
      '${_SCAN_DATA}promo-overview-graph';
  static const GET_COMPANY_SETTINGS = '${_SCAN_DATA}company-details';
  static const RETRIEVE_COMPANY_SETTINGS = 'StoresSetup/GetStoreBasicInfo';
  static const SAVE_COMPANY_SETTINGS = '${_SCAN_DATA}company-settings';
  static const SAVE_VALIDATE_SETTINGS = '${_SCAN_DATA}validate';
  static const UPDATE_PROMOTION_IMAGE = '${_SCAN_DATA}add-image';
  static const GET_PROMO_LIST = '${_SCAN_DATA}promos';
  static const SWITCH_REPRESENTATIVE = '${_SCAN_DATA}switch-representative';
  static const SWITCH_ACCOUNT = '${_SCAN_DATA}switch-account';
  static const GET_PROMO_ITEM_LIST = '${_SCAN_DATA}promo-details';
  static const ADD_PROMOTION = '${_SCAN_DATA}add-promotions';
  static const GET_PROMO_SUMMARY_COUNT = '${_SCAN_DATA}promo-overview';
  static const GET_DEALS_PROMOTION_LIST = '${_SCAN_DATA}deals-and-promotions';
  static const GET_PROFIT_SHARE_BY_ITEM =
      '${_SCAN_DATA}profit-share-by-item-graph';
  static const GET_PURCHASE_VS_MAX_RETAIL =
      '${_SCAN_DATA}price-vs-max-retail-graph';
  static const GET_SALES_PROFIT_OVERVIEW =
      '${_SCAN_DATA}sales-and-profit-overview-graph';
  static const GET_PROMOTION_REPORTING_SALES_LIST =
      '${_SCAN_DATA}promotions-reporting-sales';
  static const GET_PROMOTION_REPORTING_SALES_HISTORY_LIST =
      '${_SCAN_DATA}sales-history';
  static const DELETE_MULTI_PACK = 'MixNMatch/delete-multi-pack';

  // AgencyRepresentative Module
  static const _REPRESENTATIVE = "AgencyRepresentative/";
  static const GET_REPRESENTATIVE_LIST = '${_REPRESENTATIVE}dropdown';

  // Web Front
  static const GET_BANNERS_LIST = 'WebFront_V2/GetBannerDetails';
  static const SAVE_BANNERS_LIST = 'WebFront_V2/UpdateBannerList';
  static const GET_NEWS_LIST = "WebFront_V2/GetNewsDetails";
  static const SAVE_NEWS_LIST = 'WebFront_V2/UpdateNewsDetails';
  static const GET_EVENTS_LIST = "WebFront_V2/GetEventsDetails";
  static const SAVE_EVENTS_LIST = 'WebFront_V2/UpdateEventsDetails';
  static const GET_FEATURE_LIST = "WebFront_V2/GetFeaturesDetails";
  static const SAVE_FEATURE_LIST = 'WebFront_V2/UpdateFeaturesDetails';
  static const GET_ADVANCE_LIST = "WebFront_V2/GetAdvancedDetails";
  static const SAVE_ADVANCE_LIST = 'WebFront_V2/UpdateAdvancedDetails';
  static const GET_CONTACT_LIST = "WebFront_V2/GetContactDetails";
  static const SAVE_CONTACT_LIST = 'WebFront_V2/UpdateContactInfo';
  static const GET_ABOUT_DATA = "WebFront_V2/GetAboutDetails";
  static const SAVE_ABOUT_DATA = 'WebFront_V2/UpdateAboutInfo';
  static const SAVE_META_LIST = 'StoreSites/SaveMetasList';
  static const GET_BANNER_IMAGES = 'StoreSites/GetBannerImagesList';

  // Temperature Control
  static const GET_SENSORS = 'Temperature/GetSensors';
  static const GET_SENSORS_HISTORY = 'Temperature/GetHistory';
  static const UPDATE_DEVICE = 'Temperature/UpdateDevice';

  // Send To Pos
  static const LIST_PENDING = 'SendToPos/ListPendings';
  static const SEND_ALL_TO_POS = 'SendToPos/SendAllToPOS';
  static const SEND_TO_POS = 'SendToPos/SendToPOS';
  static const SEND_TO_POS_DELETE = 'SendToPos/SendTOPOSDelete';
  static const GET_LABEL_QUEUE = 'SendToPos/GetLabelQueues';
  static const DELETE_LABEL_QUEUE = 'SendToPos/DeleteLabelQueues';
  static const SEND_TO_POS_ALERTS = 'SendToPos/alerts';
  static const SEND_TO_POS_INLINE = 'Items/UpdateItemField';
  static const SEND_TO_POS_REPORT = 'SendToPos/GetCompletedSendToPosList';

  // Fuel Purchase
  static const GET_FUEL_DASHBOARD = 'FuelPurchase/dashboard';
  static const GET_FUEL_DASHBOARD_SALES = 'FuelPurchase/dashboard-sales';
  static const GET_TANK_LIST = 'Tank/TankListWithBalance';

  static const GET_TANK_SUMMARY = 'FuelPurchase/tank-summary';
  static const GET_TANK_PURCHASES = 'FuelPurchase/tank-purchases';
  static const GET_TANK_SALES = 'FuelPurchase/tank-sales';
  static const GET_TANK_REPORT = 'FuelPurchase/leakage-report';
  static const UPDATE_TANK_REPORT = 'FuelPurchase/update-report';

  static const GET_FUEL_SUMMARY = 'FuelPurchase/grade-summary';
  static const UPDATE_FUEL_PRICE = 'FuelPurchase/update-price';
  static const GET_FUEL_GRADE_PRICE_HISTORY =
      'FuelPurchase/grade-price-history';
  static const GET_FUEL_GRADE_COST_HISTORY = 'FuelPurchase/grade-cost-history';
  static const GET_FUEL_GRADE_PURCHASES = 'FuelPurchase/grade-purchases';
  static const GET_FUEL_GRADE_SALES = 'FuelPurchase/grade-sales';
  static const GET_FUEL_GRADE_LOGS = 'PluGroups/GetDropdownList';

  static const GET_FUEL_TYPES = 'FuelPurchase/fuel-types';
  static const GET_FUEL_LOAD_DETAIL = 'FuelPurchase/get-fuel-load';
  static const SAVE_FUEL_LOAD = 'FuelPurchase/load-fuel';
  static const COMMIT_FUEL_LOAD = 'FuelPurchase/commit-fuel';
  static const DELETE_FUEL_LOAD = 'FuelPurchase/delete-fuel-load';

  static const GET_FUEL_PURCHASES_SUMMARY = 'FuelPurchase/summary';
  static const GET_FUEL_PURCHASES = 'FuelPurchase/fuel-purchases';
  static const GET_FUEL_PURCHASE_DETAIL = 'FuelPurchase/fuel-purchase-details';
  static const SAVE_FUEL_PURCHASE = 'FuelPurchase/fuel-purchase-update';
  static const COMMIT_FUEL_PURCHASE = 'FuelPurchase/commit-purchase';
  static const REOPEN_FUEL_PURCHASE = 'FuelPurchase/reopen-po';

  static const GET_GAS_REPORT = 'FuelPurchase/profit-report';
  static const FUEL_PURCHASE_PROFIT = 'FuelPurchase/profit-report-data';
  static const FUEL_PROFIT_DETAILS = 'FuelPurchase/profit-report-detail';

  // What's New
  static const GET_WHATS_NEW = 'WebTutorials/WhatsNew';

  // Time Off Requests
  static const TIME_OFF_SUMMARY = 'TimeOffRequest/Summary';
  static const GET_TIME_OFF_REQUESTS = 'TimeOffRequest/GetAll';
  static const GET_TIME_OFF_BY_ID = 'TimeOffRequest/Get';
  static const TIME_OFF_SAVE = 'TimeOffRequest/SaveUpdate';
  static const TIME_OFF_UPDATE_STATUS = 'TimeOffRequest/UpdateStatusBulk';
  static const TIME_OFF_DELETE = 'TimeOffRequest/DeleteBulk';

  // Void Analysis
  static const VOIDS_BY_HOUR = 'Reports/GetVoidAnalystHourlyForClockGraph';
  static const VOIDS_BY_WEEK = 'Reports/GetVoidAnalystWeeklyForGraph';
  static const VOIDS_BY_EMPLOYEE = 'Reports/GetVoidAnalystForEmployeeGraph';
  static const VOIDS_BY_REGISTER = 'Reports/GetVoidAnalystForRegisterGraph';
  static const GET_VOIDS_BY_FILTER = 'Reports/GetVoidAnalystFilteredList';

  // TimeLine Overview
  static const GET_WEEK_TIMELINE_OVERVIEW =
      '${_REPORT}GetTimelineOverviewByWeek';
  static const GET_DAY_TIMELINE_OVERVIEW = '${_REPORT}GetTimelineOverviewByDay';
  static const GET_SOLD_ITEM = '${_REPORT}GetSoldItems';
  static const GET_PURCHASE_DETAILS = 'PurchaseOrders/GetForReport';
  static const GET_CHECK_PRINT = 'Checks/GetForReport';
  static const GET_BATCH_DETAILS = '${_REPORT}GetBatchList';
  static const GET_CASH_PAY_OUT = '${_REPORT}GetCashPayouts';
  static const GET_SAFE_DROPS = '${_REPORT}GetSafeDrops';
  static const GET_TIME_IN = 'TimeClock/GetListForReport';

  // Hourly Sales
  static const GET_HOURLY_SALES_GRAPH = 'Reports/GetHourlySalesForGraph';
  static const GET_DAILY_SALES_BY_HOUR = 'Reports/GetHourlySalesOfDayList';
  static const GET_DAILY_SALES_PIE_CHART =
      'Reports/GetHourlySalesShiftsAverageForGraph';
  static const GET_HOURLY_SALES_FILTERED = 'Reports/GetHourlySalesFilteredList';

  static const GET_ONLINE_ORDERS = 'OnlineOrder/GetAll';
  static const GET_ORDER_DETAILS = 'OnlineOrder/GetDetails';
  static const GET_LOYALTY_CUSTOMERS = 'Global/GetLoyaltyCustomersForDropdown';
  static const GET_ORDER_STATUSES = 'OnlineOrder/GetStatusesForDropdown';
  static const GET_ORDER_TIMELINE = 'OnlineOrder/GetLogs';
  static const ORDER_PRINT_RECEIPT = 'Global/GetLabelDesignByType';
  static const ORDER_UPDATE_NOTES = 'OnlineOrder/Update';
  static const ORDER_UPDATE_STATUS = 'OnlineOrder/UpdateStatus';
  static const CANCEL_ORDER = 'OnlineOrder/CancelOrder';

  static const LOTTERY_TV_GET_ALL = 'TVApp/LotteryTV/get-all';
  static const LOTTERY_TV_SUMMARY = 'TVApp/LotteryTV/GetSummary';
  static const LOTTERY_TV_ADD_EDIT = 'TVApp/LotteryTV/add-update';
  static const LOTTERY_TV_DELETE = 'TVApp/LotteryTV/delete';
  static const LOTTERY_TV_PREVIEW = 'TVApp/LotteryTV/GetById';

  // Label Design
  static const GET_FIELD_FOR_LABEL =
      'GlobalNewLabelSheet/GetFieldForLabelSheet';
  static const SAVE_LABEL_SHEET = 'GlobalNewLabelSheet/json-to-tspl';
  static const SAVE_SHEET_LABEL = 'GlobalNewLabelSheet/SaveLabelSheet';
  static const UPDATE_SHEET_LABEL = 'GlobalNewLabelSheet/UpdateLabelSheet';
  static const GET_TEMPLATE_FOR_LABEL = 'Items/GetLabelDesigns';
  static const GET_TEMPLATE_FOR_LABEL_SHEET =
      'GlobalNewLabelSheet/GetAllLabelSheet';
  static const DELETE_TEMPLATE_FOR_LABEL =
      'GlobalNewLabelSheet/delete-thermal-label';
  static const DELETE_TEMPLATE_FOR_LABEL_SHEET =
      'GlobalNewLabelSheet/DeleteLabelSheet';

  // Tv Animation
  static const TV_CATEGORY = 'AnimatedTV/GetCategoriesForDropdown';
  static const TV_TEMPLATES = 'AnimatedTV/GetAll';
  static const TV_TEMPLATES_DELETE = 'AnimatedTV/DeleteTemplates';
  static const TV_DELETE = 'AnimatedTV/DeleteTvs';
  static const TV_GALLERY = 'AnimatedTV/GetAllAssets';
  static const ASSIGNED_TV_TEMPLATES = 'AnimatedTV/GetAllTvs';
  static const TV_OPTIONS = 'AnimatedTV/GetTvsForDropdown';
  static const TV_TEMPLATE_TO_TV = 'AnimatedTV/AssignTemplateToTv';
  static const TV_UPLOAD_FILE = 'AnimatedTV/UploadFile';
  static const SAVE_TV_TEMPLATE = 'AnimatedTV/SaveUpdateAnimatedTVDesign';

  // Tv Menu V2
  static const TV_V2_TEMPLATES = 'AnimatedTV/V2/GetAll';
  static const TV_ASSIGNED_V2_TEMPLATES = 'AnimatedTV/V2/GetAllAssignedTvs';
  static const TV_V2_CATEGORY = 'AnimatedTV/V2/GetCategoriesForDropdown';
  static const TV_V2_OPTIONS = 'AnimatedTV/V2/GetTvsForDropdown';
  static const TV_TEMPLATE_TO_TV_2 =
      'AnimatedTV/V2/AssignTemplateToTv_ForBackOffice';
  static const TV_OPTIONS_2 = 'AnimatedTV/V2/GetTvsForDropdown';

  static const TV_V2_CATEGORY_ASSET =
      'AnimatedTV/GetAssetsCategoriesForDropdown';
  static const TV_V2_TEMPLATE_DROPDOWN = 'AnimatedTV/V2/templates-dropdown';
  static const TV_V2_ADD_TV = 'AnimatedTV/SaveUpdateTv';
  static const TV_V2_DELETE_TV = 'AnimatedTV/DeleteTvs';
  static const ASSIGNED_TV_V2__TEMPLATES = 'AnimatedTV/V2/GetAllTvs';
  static const SAVE_V2_TV_TEMPLATE = 'AnimatedTV/V2/SaveUpdateAnimatedTVDesign';
  // Daily Book
  static const GET_MONTHLY_ENTRY_LIST = '${_DAILY_BOOK}GetDailyBookByDate';
  static const GET_ENTRY_ACCOUNT_LIST = '${_DAILY_BOOK}GetAccountList';
  static const GET_DAILY_BOOK_REPORT = '${_DAILY_BOOK}GetDailyBookReport';
  static const SAVE_ENTRY = '${_DAILY_BOOK}SaveDailyBook';
  static const REFRESH_ENTRY = '${_DAILY_BOOK}RefreshDailyBook';
  static const REFRESH_OPENING_BALANCE = '${_DAILY_BOOK}RefreshOpeningBalance';
  static const GET_CLOSING_LIST = '${_DAILY_BOOK}GetClosings';
  static const DELETE_CLOSING = '${_DAILY_BOOK}DeleteClosings';
  static const COMMIT_ENTRY = '${_DAILY_BOOK}CommitDailyBook';
  static const UPDATE_ACCOUNT_CATEGORY = '${_DAILY_BOOK}UpdateAccountCategory';
  static const UPDATE_ACCOUNT_CATEGORY_SORTING =
      '${_DAILY_BOOK}UpdateCategoryOrder';
  static const GET_EMPLOYEE_DROPDOWN =
      '${_DAILY_BOOK}GetEmployeeListForDropdown';
  static const GET_VENDOR_DEFAULT_DETAIL = '${_DAILY_BOOK}GetVendorDetailsById';
  // Cash In
  static const GET_CASH_IN = '${_DAILY_BOOK}DailyInDetail';
  static const SAVE_CASH_IN = '${_DAILY_BOOK}SaveDailyInDetail';
  // Money From Bank In
  static const GET_MONEY_FROM_BANK = '${_DAILY_BOOK}GetBankDetail';
  static const SAVE_MONEY_FROM_BANK = '${_DAILY_BOOK}SaveBankDetail';
  // Cash Out
  static const GET_CASH_OUT = '${_DAILY_BOOK}DailyOutDetail';
  static const SAVE_CASH_OUT = '${_DAILY_BOOK}SaveDailyOutDetail';
  // Daily Sales
  static const GET_DAILY_SALES = '${_DAILY_BOOK}GetDailySalesDetail';
  static const GET_DAILY_REGULAR_SALES = '${_DAILY_BOOK}GetDepartmentSales';
  static const REFRESH_DAILY_SALES = '${_DAILY_BOOK}RefreshGasFuel';
  static const SAVE_DAILY_SALES = '${_DAILY_BOOK}SaveDailySalesDetail';
  // Daily CHECK
  static const GET_DAILY_REBATE = '${_DAILY_BOOK}GetIncomeRebateDetail';
  static const SAVE_DAILY_REBATE = '${_DAILY_BOOK}SaveIncomeRebateDetail';
  // FUEL SALES
  static const GET_DAILY_FUEL_SALES = '${_DAILY_BOOK}GetGasGallonsDetail';
  static const SAVE_DAILY_FUEL_SALES = '${_DAILY_BOOK}SaveGasGallonsDetail';
  static const UPDATE_DAILY_FUEL = '${_DAILY_BOOK}UpdateGasDetail';
  // LOTTO SALES
  static const GET_DAILY_LOTTO_SALES = '${_DAILY_BOOK}GetLottoSalesDetail';
  static const SAVE_DAILY_LOTTO_SALES = '${_DAILY_BOOK}SaveLottoSales';
  // MONEY ORDER
  static const GET_DAILY_MONEY_ORDER = '${_DAILY_BOOK}GetMoneyOrdersDetail';
  static const SAVE_DAILY_MONEY_ORDER = '${_DAILY_BOOK}SaveMoneyOrder';
  // PAY OUT DETAILS
  static const GET_DAILY_PAYOUT_DETAILS = '${_DAILY_BOOK}GetPayoutsDetail';
  static const SAVE_DAILY_PAYOUT_DETAILS = '${_DAILY_BOOK}SavePayoutsDetail';
  // PAY OUT DETAILS
  static const GET_DAILY_DEPOSIT_DETAILS = '${_DAILY_BOOK}GetDepositsDetail';
  static const SAVE_DAILY_DEPOSIT_DETAILS = '${_DAILY_BOOK}SaveDepositDetail';
  // CARD DETAILS
  static const GET_DAILY_CARD_DETAILS = '${_DAILY_BOOK}GetCardsDetail';
  static const SAVE_DAILY_CARD_DETAILS = '${_DAILY_BOOK}SaveCardsDetail';
  // LOAD ATM DETAILS

  static const GET_DAILY_ATM_DETAILS = '${_DAILY_BOOK}GetATMDetail';
  static const SAVE_DAILY_ATM_DETAILS = '${_DAILY_BOOK}SaveATMDetail';
  // GAS DEPOSIT DETAILS
  static const GET_MERCHANT_LIST = 'CardReconciliation/GetMerchants';
  static const GET_DAILY_GAS_DEPOSIT_DETAILS =
      '${_DAILY_BOOK}GetGasPOSCardsDetail';
  static const GET_DEFAULT_JOBBER_MERCHANT =
      '${_DAILY_BOOK}GetDefaultJobberMerchant';
  static const GET_DEFAULT_REGULAR_MERCHANT =
      '${_DAILY_BOOK}GetDefaultRegularMerchant';
  static const SAVE_DAILY_GAS_DEPOSIT_DETAILS =
      '${_DAILY_BOOK}SaveGasPOSCardsDetail';
  // Notes
  static const GET_DAILY_NOTE = '${_DAILY_BOOK}GetDailyNotes';
  static const SAVE_DAILY_NOTE = '${_DAILY_BOOK}SaveDailyNotes';
  static const DELETE_DAILY_NOTE = '${_DAILY_BOOK}DeleteDailyNotes';
  static const DAILY_BOOK_PROFIT_LOSS_REPORT = '${_DAILY_BOOK}IncomeStatement';

  // GAS QUICK ENTRY LIST
  static const GET_QUICK_ENTRY_LIST = '${_DAILY_BOOK}GetQuickBookList';
  static const GET_DEFAULT_VENDOR = '${_DAILY_BOOK}GetVendorDefaultValue';
  static const SAVE_QUICK_ENTRY_PURCHASE =
      '${_DAILY_BOOK}SaveQuickEntryPurchase';
  static const GET_QUICK_ENTRY_DAILY_ID = '${_DAILY_BOOK}GetDailyReportID';
  static const GET_RECOMMENDED_EXPENSES =
      'ExpensePlanner/GetExpenseListForQuickEntry';

  // Bank Reconciliation
  static const GET_RECONCILIATION_LIST =
      '${_BANK_RECONCILIATION}GetReconciliationList';
  static const DELETE_RECONCILIATION =
      '${_BANK_RECONCILIATION}DeleteReconciliationStatement';
  static const GET_RECONCILIATION_START_DATE =
      '${_BANK_RECONCILIATION}GetStartDate';
  static const GET_AUTO_PAYMENT_SERVICE =
      '${_BANK_RECONCILIATION}GetAutoPaymentServiceList';
  static const SAVE_AUTO_PAYMENT_SERVICE =
      '${_BANK_RECONCILIATION}SaveAutoPaymentService';
  static const ADD_RECONCILIATION =
      '${_BANK_RECONCILIATION}SaveReconciliationStatement';
  static const GET_RECONCILIATION_DETAIL =
      '${_BANK_RECONCILIATION}GetReconciliationGetByID';
  static const COMMIT_RECONCILIATION_DETAIL =
      '${_BANK_RECONCILIATION}CommitReconciliationEntry';
  static const GET_GAS_RECONCILIATION_DETAIL =
      '${_BANK_RECONCILIATION}GetGasDepositDetail';
  static const COMMIT_GAS_RECONCILIATION_DETAIL =
      '${_BANK_RECONCILIATION}SaveGasReconciliationDetails';
  static const REOPEN_GAS_RECONCILIATION =
      '${_BANK_RECONCILIATION}reopen-gas-reconcillation';
  static const REOPEN_ATM_RECONCILIATION =
      '${_BANK_RECONCILIATION}ReopenATMDetail';
  static const UPDATE_RECONCILIATION_DETAIL_FIELD =
      '${_BANK_RECONCILIATION}UpdateReconciliationDetail';
  static const GET_MERCHANT_RECONCILIATION_DETAIL =
      '${_BANK_RECONCILIATION}GetDepositsDetail';
  static const GET_MERCHANT_DEPOSIT_DETAIL =
      '${_BANK_RECONCILIATION}GetMerchantDepositDetail';
  static const COMMIT_MERCHANT_RECONCILIATION_DETAIL =
      '${_BANK_RECONCILIATION}SaveDailyDepositDetails';
  static const GET_COMPANY_LIST = '${_DEPARTMENTS}GetDepartmentByMainDept';
  static const GET_MONEY_TRANSFER_RECONCILIATION_DETAIL =
      '${_BANK_RECONCILIATION}GetDailyMODetail';
  static const COMMIT_MONEY_TRANSFER_RECONCILIATION_DETAIL =
      '${_BANK_RECONCILIATION}SaveDailyMODetails';
  static const GET_ATM_RECONCILIATION_DETAIL =
      '${_BANK_RECONCILIATION}GetATMDetail';
  static const COMMIT_ATM_RECONCILIATION_DETAIL =
      '${_BANK_RECONCILIATION}SaveDailyATMDetails';
  static const GET_RECONCILIATION_DEPOSIT_GAS_STATEMENT =
      '${_BANK_RECONCILIATION}GetGasPaymentStatement';
  static const GET_RECONCILIATION_DEPOSIT_MERCHANT_STATEMENT =
      '${_BANK_RECONCILIATION}GetMerchantDepositStatement';
  static const GET_LOTTERY_RECONCILIATION_STATEMENT =
      '${_BANK_RECONCILIATION}GetLotteryStatement';
  static const GET_ATM_RECONCILIATION_STATEMENT =
      '${_BANK_RECONCILIATION}GetATMStatementDetail';
  static const GET_RECONCILIATION_DEPOSIT_MONEY_TRANSFER_STATEMENT =
      '${_BANK_RECONCILIATION}GetMOStatementDetail';
  static const DELETE_RECONCILIATION_DEPOSIT_GAS_STATEMENT =
      '${_BANK_RECONCILIATION}DeleteGasStatement';
  static const DELETE_RECONCILIATION_ATM_STATEMENT =
      '${_BANK_RECONCILIATION}DeleteATMStatement';
  static const DELETE_LOTTERY_RECONCILIATION_STATEMENT =
      '${_BANK_RECONCILIATION}DeleteLotteryStatement';
  static const DELETE_RECONCILIATION_DEPOSIT_MERCHANT_STATEMENT =
      '${_BANK_RECONCILIATION}DeleteMerchantStatement';
  static const DELETE_RECONCILIATION_DEPOSIT_MONEY_TRANSFER_STATEMENT =
      '${_BANK_RECONCILIATION}DeleteMOStatement';
  static const GET_LOTTERY_RECONCILIATION =
      '${_BANK_RECONCILIATION}GetLotteryDetail';
  static const COMMIT_LOTTERY_RECONCILIATION =
      '${_BANK_RECONCILIATION}SaveLotteryDetails';
  static const CREDIT_CARD_RECONCILIATION =
      '${_BANK_RECONCILIATION}SaveCardReconciliation';
  static const GET_GAS_STATEMENT_SELECTED_VENDOR =
      '${_BANK_RECONCILIATION}GetGasDefaultVendor';
  static const GET_LOTTERY_STATEMENT_SELECTED_BANK =
      '${_BANK_RECONCILIATION}GetLotteryDefaultBank';
  static const GET_RECONCILIATION_DEPOSIT_STATEMENT = _BANK_RECONCILIATION;
  static const GET_RECONCILIATION_DEPOSIT_CHEQUE_STATEMENT =
      _BANK_RECONCILIATION;
  static const GET_BANK_STATEMENT =
      '${_BANK_RECONCILIATION}GetBankStatementReport';

  // Gas Fee Category
  static const GET_FEE_REBATE_CATEGORY =
      '${_GAS_FEE_CATEGORY}GetGasFeeCategoryForDropDown';
  static const ADD_FEE_REBATE_CATEGORY =
      '${_GAS_FEE_CATEGORY}SaveGasFeeCategory';

  // Plaid Integration
  static const GENERATE_PLAID_TOKEN = '${_PLAID_INTEGRATION}GenerateLinkToken';
  static const SYNC_TRANSACTION = '${_PLAID_INTEGRATION}SyncTransaction';
  static const SYNC_ACCOUNT = '${_PLAID_INTEGRATION}SyncAccounts';
  static const UN_LINK_ACCOUNT = '${_PLAID_INTEGRATION}UnlinkBankFromPlaid';
  static const PLAID_SYNC_DATA = '${_PLAID_INTEGRATION}SyncDefaultDate';
  static const GET_BANK_TRANSACTION = '${_PLAID_INTEGRATION}GetTransactionList';
  static const UPDATE_TRANSACTION_STATUS =
      '${_PLAID_INTEGRATION}UpdateTransactionStatus';
  static const GET_PLAID_CHECK = '${_PLAID_INTEGRATION}GetPlaidCheckDetail';
  static const GET_PLAID_DEPOSIT = '${_PLAID_INTEGRATION}GetPlaidDepositDetail';
  static const GET_MATCH_TRANSACTION =
      '${_PLAID_INTEGRATION}GetEntryDetailByID';
  static const MAP_PLAID_TRANSACTION =
      '${_PLAID_INTEGRATION}MapPlaidTransaction';

  // My Account subscription
  static const GET_SUBSCRIPTION_PACKAGE =
      '${_SUBSCRIPTION_PACKAGE}get-store-subscriptions';
  static const GET_EXPIRE_SUBSCRIPTION =
      '${_SUBSCRIPTION_PACKAGE}expired-notified';
  static const READ_EXPIRE_SUBSCRIPTION =
      '${_SUBSCRIPTION_PACKAGE}mark-expired-notified';

  //Service List
  static const GET_SERVICE_LIST = '${_MERCHANT_APPLICATION}get';
  static const ADD_MERCHANT_SERVICE = '${_MERCHANT_APPLICATION}create-update';
  static const GET_MERCHANT_SERVICE_DETAIL =
      '${_MERCHANT_APPLICATION}get-by-id';
  static const CANCEL_MERCHANT_SERVICE =
      '${_MERCHANT_APPLICATION}change-status';
  static const MCC_CODE = '${_MERCHANT_APPLICATION}mcc-codes';
  static const CREATE_MERCHANT_ACCOUNT_CHANGE =
      '${_MERCHANT_ACCOUNT_CHANGE}insert';
  static const CREATE_MERCHANT_TAX_ID_CHANGE =
      '${_MERCHANT_TAX_ID_CHANGE}insert';

  //Subscription Enroll
  static const GET_BILLING_HISTORY =
      '${_SUBSCRIPTION_ENROLLED}get-billing-history';
  static const BUY_SUBSCRIPTION = '${_SUBSCRIPTION_ENROLLED}insert';
  static const CANCEL_SUBSCRIPTION = '${_SUBSCRIPTION_ENROLLED}cancel';
  static const CANCEL_ACCOUNT = '${_SUBSCRIPTION_ENROLLED}cancel-account';
  static const UPDATE_MODULES_SELECTION =
      '${_SUBSCRIPTION_PACKAGE}show-or-hide-module';
  //Payment
  static const GET_ACCOUNT_LIST = '${_PAYMENT}get-all';
  static const ADD_PAYMENT_ACCOUNT = '${_PAYMENT}create-update';
  static const SET_DEFAULT_PAYMENT_ACCOUNT = '${_PAYMENT}set-default';
  static const SET_INACTIVE_PAYMENT_ACCOUNT = '${_PAYMENT}activate-deactivate';
  static const DELETE_PAYMENT_ACCOUNT = '${_PAYMENT}delete';

  //Signature QR
  static const SIGNATURE_QR = '${_PAYMENT}generate-QR';
  static const VERIFY_SIGNATURE_QR = '${_PAYMENT}verify-QR';

  // Log Viewer
  static const GET_LOGS_VIEWER_LIST = '${_GLOBAL}GetUserLogsByFilters';
  static const GET_LOGS_VIEWER_DETAILS = '${_GLOBAL}GetUserLogRefDetail';

  //Shift Report List
  static const GET_SHIFT_REPORT_LIST = '${_REPORT_CENTER}ShiftViewerReport';
  static const GET_SHIFT_REPORT_RECEIPTS =
      '${_REPORT_CENTER}ShiftViewerDetailReport';
  static const GET_SHIFT_REPORT_DETAILS = '${_REPORT_CENTER}ShiftReprintReport';
  static const GET_TENDER_DETAILS_BY_SHIFT =
      '${_REPORT_CENTER}TenderDetailByShift';
  static const GET_DEPARTMENT_DETAILS_BY_SHIFT =
      '${_REPORT_CENTER}DepartmentDetailByShift';
  static const GET_SHIFT_DROP_LIST = '${_REPORT_CENTER}ShiftDropReport';
  static const GET_SHIFT_PAYOUT_LIST = '${_REPORT_CENTER}ShiftPayoutsReport';
  static const GET_SHIFT_REPRINT_LIST = '${_REPORT_CENTER}ShiftListReport';
  static const GET_EXPENSE_REPORT = '${_REPORT_CENTER}ExpenseReportByCategory';
  static const GET_TENDER_REPORT = '${_REPORT_CENTER}TenderReport';
  static const GET_DEPOSIT_REPORT = '${_REPORT_CENTER}deposit-report';
  static const GET_CUSTOMER_REPORT = '${_REPORT_CENTER}CustomerSaleReport';
  static const GET_CUSTOMER_INVOICE_REPORT =
      '${_REPORT_CENTER}SaleReportByInvoice';
  static const GET_GROUP_SALE_REPORT = '${_REPORT_CENTER}group-sales-detail';
  static const GET_GROUP_SALE_DETAIL_REPORT =
      '${_REPORT_CENTER}group-sale-items-detail';
  static const GET_REBATE_REPORT = '${_REPORT_CENTER}vendor-rebates';
  static const GET_REBATE_REPORT_BY_VENDOR = '${_REPORT_CENTER}RebateReport';
  static const GET_PETTY_CASH_SUMMARY_REPORT =
      '${_REPORT_CENTER}PettyCashReport';
  static const ITEM_SALES_HISTORY_REPORT = '${_REPORT_CENTER}ItemHistoryReport';
  static const GET_IN_OUT_REPORT = '${_REPORT_CENTER}DailyInOutReport';
  static const GET_MERCHANT_REPORT = '${_REPORT_CENTER}MerchantDepositReport';
  static const GET_SALES_PUCHASE_DEPARTMENT_REPORT =
      '${_REPORT_CENTER}SalePurchaseByDepartmentReport';
  static const GET_REBATE_DETAIL_REPORT =
      '${_REPORT_CENTER}vendor-rebate-details';
  static const GET_POS_SUMMARY_REPORT = '${_REPORT_CENTER}POSSummaryReport';
  static const GET_BOOK_SUMMARY_REPORT = '${_REPORT_CENTER}SummaryReport';
  static const GET_DISCOUNT_REPORT =
      '${_REPORTS}GetSalesByMixmatchDiscountType';
  static const GET_DISCOUNT_DETAIL_REPORT =
      '${_REPORTS}GetSaleDetailsByMixmatchDiscountType';
  static const GET_INVENTORY_BOOK_REPORT =
      '${_REPORT_CENTER}InventoryReportByBook';
  static const GET_FUEL_SUMMARY_REPORT = '${_REPORT_CENTER}GasSummaryReport';
  static const GET_MONEY_SERVICE_REPORT = '${_REPORT_CENTER}MoneyServiceReport';
  static const GET_MONEY_SERVICE_SUMMARY_REPORT =
      '${_REPORT_CENTER}money-service-summary';
  static const GET_ATM_REPORT = '${_REPORT_CENTER}ATMReport';
  static const GET_PURCHASE_REPORT = '${_REPORT_CENTER}PurchaseReport';
  static const GET_LOTTERY_SUMMARY_REPORT =
      '${_REPORT_CENTER}LotteryServiceReport';
  static const GET_POS_HOLD_REPORT = '${_REPORT_CENTER}POSHoldReport';
  static const GET_PAY_ROLL_SUMMARY_REPORT =
      '${_REPORT_CENTER}PayrollSummaryReport';
  static const GET_PAY_ROLL_CATEGORY_REPORT =
      '${_REPORT_CENTER}PayrollReportByCategory';
  static const GET_PAY_ROLL_CHECK_REPORT =
      '${_REPORT_CENTER}PayrollChecksReport';
  static const GET_PAY_ROLL_DEPARTMENT_REPORT =
      '${_REPORT_CENTER}PayrollByDepartmentReport';
  static const GET_FUEL_PURCHASE_REPORT = '${_REPORT_CENTER}FuelReportByDate';
  static const GET_FUEL_SALES_REPORT = '${_REPORT_CENTER}SaleFuelReportByDate';
  static const GET_SHIFT_CLOSING_DATE = '${_REPORT_CENTER}GetClosingDateList';
  static const GET_CHANGE_ITEM_HISTORY = '${_REPORT_CENTER}item-history';
  static const REVERT_ITEM_HISTORY = 'Items/reset';

  // Check Cashing
  static const GET_CHECK_CASHING = '${_CHECK_CASHING}get-list';
  static const GET_DEPOSIT_CHECK_CASHING = '${_CHECK_CASHING}GetDeposits';
  static const GET_CTR_FILLING = '${_CHECK_CASHING}GetCtrList';
  static const GET_CTR_FILLING_DETAIL = '${_CHECK_CASHING}GetCtrDetail';
  static const GENERATE_CTR = '${_CHECK_CASHING}GenerateCTR';
  static const GET_BAD_CHECK_LIST = '${_CHECK_CASHING}GetBadChecks';
  static const GET_BAD_CHECK_DETAIL = '${_CHECK_CASHING}GetBadCheckById';
  static const ADD_BAD_CHECK = '${_CHECK_CASHING}SaveUpdateCheck';
  static const DELETE_BAD_CHECK = '${_CHECK_CASHING}DeleteChecksBulk';
  static const VALIDATE_BAD_CHECK = '${_GLOBAL}ReadCheckAI';
  static const VALIDATE_BAD_CUSTOMER_ID_CARD = '${_GLOBAL}ReadIDCardAI';
  static const GET_BAD_CUSTOMER_LIST = '${_CHECK_CASHING}GetBadCustomers';
  static const GET_BAD_CUSTOMER_DETAIL = '${_CHECK_CASHING}GetBadCustomerById';
  static const ADD_BAD_CUSTOMER = '${_CHECK_CASHING}SaveUpdateCustomer';
  static const DELETE_BAD_CUSTOMER = '${_CHECK_CASHING}DeleteCustomersBulk';
  static const GET_CHECK_LOG = '${_CHECK_CASHING}check-logs';
  static const DELETE_CHECK_CASHING = '${_CHECK_CASHING}delete';
  static const SAVE_CHECK_CASHING = '${_CHECK_CASHING}insert-update';
  static const CHECK_CASHING_RETURN = '${_CHECK_CASHING}create-return';
  static const DEPOSIT_CHECK_RETURN = '${_CHECK_CASHING}MarkCheckAsReturn';
  static const CHECK_CASHING_SETTLEMENT = '${_CHECK_CASHING}create-settle';
  static const CHECK_CASHING_DEPOSIT = '${_CHECK_CASHING}create-redeposited';
  static const GET_CHECK_CASHING_DOCUMENT = '${_CHECK_CASHING}get-docs';
  static const GET_CHECK_CASHING_SETTING = '${_CHECK_CASHING}GetSettings';
  static const GET_CHECK_CASHING_ACTIVATION_CODE =
      '${_CHECK_CASHING}GetActivationCode';
  static const SOFTWARE_ACTIVATION_URL =
      'https://dev.cronypos.com/dasset/pos.zip';
  static const SAVE_CHECK_CASHING_SETTING = '${_CHECK_CASHING}SaveSettings';
  static const GET_APPROVE_CONTACT = '${_CHECK_CASHING}GetApprovalContacts';
  static const GET_CHECK_CASHING_EMPLOYEE =
      '${_CHECK_CASHING}GetApprovalContacts';
  static const DELETE_APPROVE_CONTACT_EMPLOYEE =
      '${_CHECK_CASHING}DeleteApprovalContactsBulk';
  static const ADD_APPROVE_CONTACT_EMPLOYEE =
      '${_CHECK_CASHING}AddApprovalContacts';
  static const UPDATE_APPROVE_CONTACT_EMPLOYEE =
      '${_CHECK_CASHING}UpdateApprovalContact';
  static const GET_EMPLOYEE_LIST = '${_CHECK_CASHING}GetUsersBySearch';
  static const GET_DEPOSIT_CHECK_DETAIL =
      '${_CHECK_CASHING}GetAvailableChecksForDeposit';
  static const GET_ADD_DEPOSIT_CHECK_DETAIL = '${_CHECK_CASHING}AddDeposit';

  // Physical Inventory
  static const GET_PHYSICAL_INVENTORY = 'Items/GetPhysicalInventories';
  static const SAVE_BASIC_DETAILS = 'Items/SaveUpdatePhyInvBasicInfo';
  static const DELETE_PHYSICAL_INVENTORY = 'Items/DeletePhysicalInventories';
  static const SAVE_PHYSICAL_INVENTORY_DETAILS = 'Items/SavePhyInvDetails';
  static const GET_DIRECT_SCAN_ITEMS = 'Items/GetDirectScanItems';
  static const SAVE_DIRECT_SCAN_ITEMS = 'Items/SaveDirectScanItems';
  static const GET_ALL_SCAN = 'Items/GetAllScanItems';
  static const GET_ALL_ITEMS = 'Items/GetPhysicalAllItemsInventories';
  static const UPDATE_SCAN_ITEM = 'Items/UpdatePhyInvScannedItem';
  static const GET_ONLINE_GROUPS = 'Global/GetOnlineGroupsForDropdown';
  static const COMMIT_INVENTORY = 'Items/CommitPhysicalInventory';
  static const ITEM_HISTORY_BY_INVENTORY = 'Items/GetItemHistoryByInventory';
  static const ITEM_SOLD_HISTORY = 'Items/SoldHistoryReport';

  // Profit Loss
  static const GET_PROFIT_LOSS_LIST = '${_PROFIT_LOSS}AdvanceIncomeStatement';

  static const GET_PROFIT_LOSS_ENDING_SUMMARY =
      '${_PROFIT_LOSS}ProfitLossEndingSummary';
  static const GET_PROFIT_LOSS_INCOME_SUMMARY =
      '${_PROFIT_LOSS}ProfitLossIncomeSummary';
  static const GET_PROFIT_LOSS_EXPENSE_SUMMARY =
      '${_PROFIT_LOSS}ProfitLossExpenseSummary';

  static const GET_PROFIT_LOSS_PRODUCT_CARD_SUMMARY =
      '${_PROFIT_LOSS}ProductCardSummary';
  static const GET_PROFIT_LOSS_PRODUCT_DETAIL =
      '${_PROFIT_LOSS}ProductDetailByMonth';
  static const GET_PROFIT_LOSS_PRODUCT_YEAR_COMPARISON =
      '${_PROFIT_LOSS}ProductYearComparison';

  static const GET_PROFIT_LOSS_LOTTERY_CARD_SUMMARY =
      '${_PROFIT_LOSS}LotterySummaryForCards';
  static const GET_PROFIT_LOSS_LOTTERY_REVENUE =
      '${_PROFIT_LOSS}LotteryRevenueSummary';
  static const GET_PROFIT_LOSS_LOTTERY_COST_SALES =
      '${_PROFIT_LOSS}LotteryCostSalesSummary';
  static const GET_PROFIT_LOSS_LOTTERY_PRICE_RANGE =
      '${_PROFIT_LOSS}LotteryByPriceRangeSummary';
  static const GET_PROFIT_LOSS_TOP_LOTTERIES =
      '${_PROFIT_LOSS}TopLotteriesSummary';

  static const GET_PROFIT_LOSS_FUEL_CARD_SUMMARY =
      '${_PROFIT_LOSS}FuelSummaryForCards';
  static const GET_PROFIT_LOSS_FUEL_PROFIT_OVERVIEW =
      '${_PROFIT_LOSS}FuelProfitOverview';
  static const GET_PROFIT_LOSS_FUEL_OVERVIEW =
      '${_PROFIT_LOSS}FuelOverviewDetails';
  static const GET_PROFIT_LOSS_FUEL_PROFIT_COMPARISON =
      '${_PROFIT_LOSS}FuelProfitComparison';

  static const GET_PROFIT_LOSS_EXPENSE_SUMMARY_BY_NAME =
      '${_PROFIT_LOSS}ExpenseSummaryByName';
  static const GET_PROFIT_LOSS_EXPENSE_SUMMARY_BY_MONTH =
      '${_PROFIT_LOSS}ExpenseSummaryByMonth';
  static const GET_PROFIT_LOSS_EXPENSE_SUMMARY_COMPARISON =
      '${_PROFIT_LOSS}ExpenseSummaryComparision';

  static const GET_BALANCE_SHEET = "ProfitLoss/BalanceSheet";
  static const GET_PROFIT_LOSS_PRODUCT_YEAR_COMPARISION =
      '${_PROFIT_LOSS}ProductYearComparison';

  // Financial Reports
  static const GENERATE_FINANCIAL_REPORT =
      "FinancialReport/GenerateFinancialReport";
  static const FINANCIAL_REPORT_VALIDATE_DAILY_BOOK =
      "FinancialReport/ValidateDailyBook";
  static const FINANCIAL_REPORT_SEND_EMAIL =
      "FinancialReport/SendEmailWithAttachements";
  static const FINANCIAL_REPORT_GET_LAST_EMAIL =
      "FinancialReport/GetLastEmailAddress";

  // Expired Documents
  static const GET_EXPIRED_DOCS = 'Documents/GetAllExpiredDocuments';
  static const SAVE_EXPIRED_DOC = 'Documents/UpdateDocument';
  static const SAVE_DOC_CATEGORY = 'Documents/SaveUpdateDocumentCategory';
  static const DELETE_EXPIRED_DOCS = 'Documents/DeleteBulk';
  static const GET_STORE_LOGOS = 'Documents/GetStoreLogoUrl';

  // Expired Documents
  static const GET_EMP_TRAINING = 'Trainings/get-list';
  static const GET_EMP_TRAINING_SUMMARY = 'Trainings/summary';
  static const GET_EMP_TRAINING_CODE = 'Trainings/training-code-dropdown';
  static const SAVE_EMP_TRAINING = 'Trainings/insert-update';
  static const DELETE_EMP_TRAINING = 'Trainings/delete';
  static const GET_TRAININGS_BY_EMP = 'EmployeeTraining/trainings-by-employee';
  static const GET_EMPLOYEES_BY_TRAINING =
      'EmployeeTraining/employees-by-trainingid';
  static const MARK_EMP_TRAINING = 'EmployeeTraining/insert-update';

  // Rebates
  static const REBATES_GET_LIST = 'Rebates/GetList';
  static const REBATES_GET_DETAILS = 'Rebates/GetDetails';
  static const REBATES_SUMMARY = 'Rebates/GetRebateSummary';
  static const REBATES_SAVE = 'Rebates/Save';
  static const REBATES_DELETE = 'Rebates/Delete';
  // static const REBATES_GET_DETAILS = 'Rebates/GetDetails';

  // Custom Menu Template
  static const GET_MENU_TEMPLATES = 'Global/GetCustomMenuTemplates';
  static const GET_MENU_TEMPLATE_DETAILS =
      'Global/GetCustomMenuTemplateDetails';
  static const SAVE_MENU_TEMPLATE = 'Global/SaveUpdateCustomMenuTemplate';
  static const CLONE_MENU_TEMPLATE = 'Global/CloneCustomMenuTemplate';
  static const SET_MENU_TEMPLATE_DEFAULT = 'Global/SetDefaultTemplate';
  static const DELETE_MENU_TEMPLATE = 'Global/DeleteCustomMenuTemplates';

  // Money Order Setup Module
  static const GET_MONEY_ORDER_SETUP_LIST =
      '${_MONEY_ORDER_SETUP}GetAllMoneyService';
  static const DELETE_MONEY_ORDER_SETUP =
      '${_MONEY_ORDER_SETUP}DeleteMoneyServiceDetail';
  static const GET_MONEY_ORDER_SETUP =
      '${_MONEY_ORDER_SETUP}GetMoneyServiceDetail';
  static const SAVE_MONEY_ORDER_SETUP =
      '${_MONEY_ORDER_SETUP}SaveMoneyServiceDetail';
  static const GET_LOTTERY_DEFAULT_VENDOR =
      '${_MONEY_ORDER_SETUP}GetDefaultLotteryVendor';
}

class WebRtcUrls {
  WebRtcUrls._();

  static String baseUrl = Flavor.I.get(Keys.signalr);

  static String webRtcBaseUrl = '${baseUrl}api/';

  static const hub = 'connect?token=44e4e105-ff7c-4800-b0d4-a1da95272789';

  static const saveCustomer = 'Chat/SaveCustomer';
  static const joinMeeting = 'OnJoinedMeeting';

  static const sendSignal = 'SendHubSignal';
  static const receiveSignal = 'OnReceiveSignal';

  static const sendMsg = 'Chat/SendMsg';
  static const receiveMsg = 'OnMsgReceived';
  static const userIsTyping = 'UserIsTyping';
  static const fileMeta = 'FileDT';
  static const fileDone = 'DoneFileReceived';
  static const chatEnd = 'TechLeft';
  static const remoteDisconnect = 'Chat/OnRemoteUserDisconnect';

  static const incomingCall = 'IncomingCall';
  static const callAccepted = 'CallAccepted';
  static const callDeclined = 'CallDeclined';
  static const muteUnMute = 'MuteUnmute';
  static const videoKey = '#RemoteVideo';
  static const callEnded = 'CallEnded';
}
