//
//  MyApi.swift
//  Dhanbarse
//
//  Created by Goldmedal on 2/25/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import Foundation

struct MyApi {
    
    // https://dhanbarseapi.goldmedalindia.in/
    
    //URLS - - -
    public static let PROD_BASE_URL  = "https://dhanbarseapi.goldmedalindia.in/api/dhanbarse/v1.0/"
    public static let CASHBACK_BASE_URL  = "https://dhanbarseapi.goldmedalindia.in/api/cashback/v1.0/"
    public static let CASHBACK_BASE_URL_v2  = "https://dhanbarseapi.goldmedalindia.in/api/cashback/v2.0/"
    public static let QRCODE_BASE_URL  = "https://dhanbarseapi-uat.goldmedalindia.in/api/qrcode/v1.0/"
    public static let TESTING_BASE_URL = "https://dhanbarseapi-uat.goldmedalindia.in/api/dhanbarse/v1.0/"
    
    //CONTROLLERS - - -
    public static let ACCESS_TOKEN = "https://dhanbarseapi-uat.goldmedalindia.in/api/login"
  //  public static let ACCESS_TOKEN = "https://dhanbarseapi.goldmedalindia.in/api/login"
    
//    public static let PROD_BASE_URL  = "https://dhanbarseapi.goldmedalindia.in/api/dhanbarse/v1.0/"
//    public static let CASHBACK_BASE_URL  = "https://dhanbarseapi.goldmedalindia.in/api/cashback/v1.0/"
//    public static let QRCODE_BASE_URL  = "https://dhanbarseapi.goldmedalindia.in/api/qrcode/v1.0/"
//    public static let TESTING_BASE_URL = "https://dhanbarseapi.goldmedalindia.in/api/dhanbarse/v1.0/"
    
    public static let DEVICE_TYPE = "ios"
    public static let APP_TYPE = "4"
    public static let APP_ID = 1
    public static let APP_VERSION = "3.0.0"
    public static let PUSH_ID = "12"
    
    public static let INIT_API = "account/otp/initialapi"
    public static let SEND_OTP = "account/otp/send"
    public static let VERIFY_OTP = "account/otp/verify"
    
    public static let COUNTERBOY_ADD = "counterboy/add"
    public static let COUNTERBOY_GET = "counterboy/get"
    public static let COUNTERBOY_REMOVE = "counterboy/delete"
    public static let COUNTERBOY_APPROVAL = "counterboy/ownerapproval"
    public static let COUNTERBOY_VERIFY = "counterboy/check-counterboy-exists"
    public static let COUNTERBOY_OTP = "counterboy/send-otp-to-counterboy"
    public static let COUNTERBOY_AMOUNT_TRANSFER_CURRENT_LIST = "counterboy/get-counterboy-list-for-current-duration"
    public static let COUNTERBOY_AMOUNT_TRANSFER_PREVIOUS_LIST = "counterboy/get-counterboy-amount-transfer-history"
    public static let COUNTERBOY_AMOUNT_TRANSFER_DETAIL = "counterboy/get-counterboy-amount-transfer-details"
    public static let COUNTERBOY_CASHBACK_AMOUNT_TRANSFER = "counterboy/Counterboy-Cashback-Amount-Transfer"
    public static let COUNTERBOY_SCHEME_LIST = "counterboy/get-counterboy-cashback-scheme-list"
    public static let COUNTERBOY_SCHEME_GET_OTP = "counterboy/send-otp-to-counterboy-head"
    public static let COUNTERBOY_SCHEME_REDEEM_OTP = "counterboy/Redeem-counterboy-cashback"
    public static let COUNTERBOY_LOGIN_AMOUNT_TRANSFER_CURRENT_LIST = "counterboy/get-counterboy-list-for-current-duration-cblogin"
    public static let COUNTERBOY_LOGIN_AMOUNT_TRANSFER_DETAIL = "counterboy/get-counterboy-amount-transfer-details-cblogin"

    public static let ADDITIONAL_MOBILE_ADD = "user/profile/insertupdateadditionalnumber"
    public static let ADDITIONAL_MOBILE_GET = "user/profile/getadditionalnumberuserslist"
    public static let ADDITIONAL_MOBILE_REMOVE = "user/profile/delete-additional-number-userslist"
    
    public static let GET_PROFILE_DATA = "user/profile/getdetails"
    public static let UPDATE_PERSONAL_DATA = "user/profile/addupdate"
    public static let UPDATE_COMMUNICATION_DATA = "user/profile/details/update"
    public static let UPDATE_BUSINESS_DATA = "shop/details/addupdate"
    public static let CHANGE_PROFILE_PIC = "user/profile/profile-photo-update"
    public static let GET_DETAIL_BY_PINCODE = "user/profile/get-stateanddistrictid-by-pincode"
    public static let GET_DESIGNATION = "user/profile/getdesignationlist"
    public static let GET_SHOP_DATA = "counterboy/GetCounterBoyheadDetails"
    
    public static let GET_CATEGORY_LIST = "user/profile/master/getcategorylist"
    public static let GET_STATE_LIST = "user/profile/master/getstatelist"
    public static let GET_DISTRICT_LIST = "user/profile/master/getdistictlist"
    public static let CHECK_REF_NO = "user/profile/details/checkrefno"
    public static let CHANGE_USER_CATEGORY = "user/profile/details/changeusercategory"
    public static let CHANGE_MOBILE_NO = "user/profile/details/changemobileno"
    public static let CHANGE_MOBILE_NO_OTP = "user/profile/send-otp-to-user"
    public static let VERIFY_MASTER = "user/profile/verify-user"
    public static let GET_INSURANCE_LIST = "insurance/getinsurancelist"
    public static let UPDATE_INSURANCE = "insurance/updateinsurance"
    
    public static let BRANDING_IMAGE_LIST = "user/profile/master/getscrollingimglist"
    public static let GET_REFERRAL_CODE_LIST = "Qrscan/referredUserslist"
    
    public static let SCAN_QR_CODE = "wallet/paytm/direct-transfer"
    public static let GIFT_QR_CODE = "Qrscan/qrscan/gift-transfer"
    public static let GIFT_QR_CODE_LIST = "Qrscan/qrscan/giftqrcodescanlist"
    public static let CHECK_QR_CODE = "wallet/qr-code/check"
    public static let REGISTER_COMPLAINT = "wallet/register-complaint"
    
    public static let DEALER_PASSBOOK_DETAILS = "points/points/getdealerpassbook"
    public static let RETAILER_PASSBOOK_DETAILS = "points/points/getretailerspassbook"
    public static let DASHBOARD_POINTS = "user/profile/getdashboard"
    
    public static let RETAILER_LIST = "points/retailerslist"
    public static let RETAILER_LIST_REVOKE = "points/retailerslistrevoke"
    public static let REVOKE_FROM_RETAILER_TO_DEALER = "points/revoke/from-retailer-to-dealer"
    public static let CALCULATE_POINTS = "points/calculate-points"
    public static let TRANSFER_DEALOR_TO_RETAILER = "points/transfer/dealer-to-retailer"
    public static let REQUEST_STATEMENT = "points/requeststatement"
    public static let RRP_TO_DRP = "points/convertrrptodrp"
    
    public static let GET_SCHEME_LIST = "offers/getSchemelist"
    public static let GET_OFFERS_LIST = "offers/getlist"
    
    public static let GET_WALLET_LIST = "wallet/get-list/profileid"
    public static let GET_WALLET_HISTORY = "wallet/get-wallet-history/profileid"
    public static let GET_WALLET_GROUP_LIST = "wallet/get-group-list/profileid"
    public static let GET_WALLET_GROUP_AMOUNT_LIST = "wallet/get-group-amount-list/profileid"
    public static let GET_STATEMENT_URL = "points/statementurl"
    public static let VERIFY_ACCOUNT_URL = "wallet/paytm/account-verification/profileid"
   
    public static let GET_VIDEO_LIST = "marketing/getyoutube"
    public static let GET_MEDIA_LIST = "marketing/getmedia"
    public static let GET_SHOWROOM_LIST = "marketing/getshowroom"
    public static let GET_NEWARRIVAL_LIST = "marketing/getnewarrival"
   
    public static let SALES_EXEC_DISTRICTWISE_LIST = "executive/getusercountforapprovaldistrictwise"
    public static let SALES_EXEC_APPROVAL_LIST = "executive/userlistforapprovaldistrictwise"
    public static let SALES_EXEC_PROFILE_DETAIL = "executive/get-user-details"
    public static let SALES_EXEC_PROFILE_UPDATE = "executive/approval/update"
    public static let SALES_EXEC_FEEDBACK_REASON = "executive/getfeedbackreasons"
    public static let SALES_EXEC_FEEDBACK_UPDATE = "executive/addsalesexecutivefeedback"
    public static let SALES_EXEC_FEEDBACK_LIST = "executive/getfeedbacksgivenbysalesexecutive"
    
    public static let REWARD_PRODUCT_LIST = "mall/gethomepageproductlist"
    public static let REWARD_CAT_LIST = "mall/getcategorywisepageproductlist"
    public static let REWARD_ADD_CART_DETAIL = "mall/getproductdetails"
    public static let ADDRESS_LIST = "mall/getusersaddresslist"
    public static let PLACE_ORDER = "mall/PlaceOrder"
    public static let ADD_ADDRESS = "mall/AddNewAddress"
    public static let REWARD_HISTORY = "mall/getorderlist"
    public static let REWARD_ORDER_DETAIL = "mall/getorderdetails"
    public static let COUPON_CODE = "mall/checkcouponcode"
    public static let RETURN_REASON = "mall/getreturnrequestreason"
    public static let CANCEL_ORDER = "mall/CancelOrder"
    public static let RETURN_REPLACE_ORDER = "mall/returnrequest"
    
    public static let CONTACT_US = "marketing/getcontactus"
    public static let GET_NOTIFICATION_LIST = "notification/getnotificationlist"
    public static let GET_UNREAD_COUNT = "notification/unreadnotificationcount"
    public static let LOG_TO_SERVER = "notification/logtoserver"
    public static let UPDATE_NOTIFICATION = "notification/logtoread"
    
    public static let CB_SCAN_GET_OTP = "crm/sendotp"
    public static let CB_SCAN_QRCODE = "crm/scan/qrcode"
    public static let CB_SCAN_CUST_DETAIL = "crm/getcustomerdetails"
    public static let CB_SCAN_REGISTER = "crm/registerproduct"
    public static let UPLOAD_PRODUCT_IMAGE = "mall/commonuploadimage"
    public static let REWARD_UPDATE = "mall/UpdateShipRocketOrderStatusUserwise"
    public static let CHECK_PINCODE_FOR_DELIVERY = "mall/checkpincodefordelivery"
    public static let SALES_EXEC_PENDING_ORDER = "mall/getcustomerpendingorders"
    public static let SALES_EXEC_SUBMIT_ORDER = "mall/submithanddeliverorder"
    public static let SALES_EXEC_REOPEN = "executive/approval/reopen"
    public static let SALES_EXEC_UPDATE_PHOTO = "executive/updatephotos"
    public static let SALES_EXEC_CUST_DETAIL = "mall/searchcustomerdetails"
    public static let SALES_EXEC_UPLOAD_ACK = "mall/uploadacknowledgement"
    public static let SALES_EXEC_SEND_OTP = "mall/sendotp"
  
}
