//
//  Constant.swift
//  VAPORVUE
//
//  Created by IBC Mobile on 10/25/18.
//  Copyright © 2018 IBC Mobile. All rights reserved.
//

import Foundation
import UIKit

//let APPDELEGATE = UIApplication.shared.delegate! as! AppDelegate
var storID = String()
var tolalItemPrice = Int()
var paymentMetod = String()
var paymentStatus = String()
var wallet = String()


//Mark:- fetchString
var cartID = fetchString(key: "cartID")
var userphone = fetchString(key: "userPhone")
var useremail = fetchString(key: "userEmail")
var username = fetchString(key: "userName")
var userID = fetchString(key: "userID")
var orderID = fetchString(key: "orderID")

//Mark:- ScreenDimention
var SCREEN_WIDTH = UIScreen.main.bounds.width
var SCREEN_HEIGHT = UIScreen.main.bounds.height
let verticalCenter: CGFloat = UIScreen.main.bounds.size.height / 2.0
let horizontalCenter: CGFloat = UIScreen.main.bounds.size.width / 2.0
//Yla

let baseUrlTest =  "http://grosly.com/api/"
//replaces By
//let baseUrlTest =  "http://heritagefoodsonline.com/grocery/api/"

//"https://thecodecafe.in/newgrocer/api/"
let authKey = "$2a$08$4BsgX5lRtC5/fZar6OBSf.zRDr.HpYenJ5yR8.gov4VSM/7dIIPle"
//
//let ImgBaseUrl = "https://thecodecafe.in/gogrocer-ver2.0/"
let ImgBaseUrl = "http://grosly.com/"


let MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
let app_name = "ylaa"
let LoginDetailKey = "LoginDetail"
let HomeDataKey = "HomeData"
let LoadTimeStampKey = "LoadTimeStamp"
let PublishTimeStampKey = "PublishTimeStamp"
let ThrottleValueKey = "throttleValue"
let WifiKey = "wifiKey"
let NotifyMobileKey = "notifyMobileKey"


let RevenueCatEntitlementIdentifier = "vaporvue"
let RevenueCatApiKey = "EWQUZEuKafvnHvPgHZbFhiSZcjiSdzmU"
let OneSignalAppIdKey = "f7875929-7825-4b2e-8454-8cc964e9cf16"
let ManageMembershipUrl = "itms-apps://apps.apple.com/account/subscriptions"//"https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/manageSubscriptions"


// OneSignalUserTag Struct
struct OneSignalUserTag {
    static var custIdTag = "cust_id"
    static var firstNameTag = "first_name"
    static var lastNameTag = "last_name"
    static var membershipStatusTag = "membershipStatus"
}


// NotificationPermissionsTag Struct
struct NotificationPermissionsTag {
    static var recommendationsPermissionTag = "allow_recommend"
    static var newReleasePermissionTag = "allow_releases"
    static var specialOffersPermissionTag = "allow_offers"
}

//=====WebView=====//
struct WebViewURL {
    static var termsofService = "https://www.vaporvue.com/content/terms-of-use"
    static var privacyPolicy = "https://www.vaporvue.com/content/privacy-policy"
    static var contactUs = "https://api.nodplatform.com/apps/v4/vapr/settings/contact-us/index.html"
    static var help = "https://api.nodplatform.com/apps/v4/vapr/settings/help/index.html"
    static var legal = "https://api.nodplatform.com/apps/v4/vapr/settings/legal/index.html"
    static var partyNotices = "https://api.nodplatform.com/apps/v4/vapr/settings/legal/notices.html"
}
struct PageFrom {
    static var termsofService = "Terms of Service"
    static var privacyPolicy = "Privacy Policy"
    static var contactUs = "Contact Us"
    static var help = "Help"
    static var legal = "Legal"
    static var partyNotices = "3rd Party Notices"
}
//=====WebView=====//

struct Message {
    static var BlankFirstNameMsg = "Please enter First Name"
    static var BlankLastNameMsg = "Please enter Last Name"
    static var BlankEmailMsg = "Please enter email"
    static var ValidEmailMsg = "Please enter valid email"
    static var BlankPasswordMsg = "Please enter password"
    static var ExistingAccountMsg = "The email address provided is already associated with an account at TheSurfNetwork.com. Sign into your existing account, or provide a different email address."
    static var NoNetworkMsg = "Please check your internet connection"
    static var BlankLibraryMsg = "No items found in My Video Library"
    static var BlankWatchListMsg = "No items found in Watchlist"
    static var StreamingWifiRequiredTitle = "Wi-Fi Required"
    static var StreamingWifiRequiredMsg = "To watch video, connect your device to a Wi-Fi network, or tap Settings and disable Stream on Wi-Fi Only."
    static var StreamingWarningTitle = "Warning"
    static var StreamingWarningMsg = "Your device is not connected to a Wi-Fi network. Watching videos will count towards mobile data plan usage."
    static var BlankMobileNumberMsg = "Please Enter Your Mobile Number."
}

struct SelectedPlan {
    static var MonthlyPlan = "Monthly"
    static var YearlyPlan = "Yearly"
}

struct MembershipSource {
    static var internalSource = "internal"
    static var appStoreSource = "appstore"
}

struct MembershipStatus {
    static var active = "Active"
    static var cancelled = "Cancelled"
    static var expired = "Expired"
}


struct AccountCheckError {
    static var InvalidEmailError = "invalid_email_error"
    static var InvalidNameError = "invalid_name_error"
    static var InvalidPasswordError = "invalid_password_error"
    static var ExistingEmailError = "existing_email_error"
    static var InvalidCountryError = "invalid_country_error"
    static var InvalidAccessTokenError = "invalid access_token"
    static var NotAuthorizedError = "not authorized"
}

struct StreamThrottleValue {
    static var best = "4000"
    static var better = "2500"
    static var good = "1500"
    static var low = "500"
}

struct StreamThrottleValueStr {
    static var best = "Best"
    static var better = "Better"
    static var good = "Good"
    static var low = "Low"
}

struct TargetScreen {
    static var detailMovie = "detail-movie"
    static var detailSeason = "detail-season"
    static var detailEpisode = "detail-episode"
    static var categoryRows = "category-rows"
    static var categoryGrid = "category-grid"
    static var searchResult = "search-result"
    static var home = "home"
    static var watchlist = "favorites"
    static var myVideoLibrary = "library"
}

struct MoveFromScreen {
    static var message = "message"
    static var postadd = "postadd"
    static var notification = "notification"
    static var myylaa = "myylaa"
    static var home = "home"
}

struct RowStyle {
    static var marqueeStyle = "marquee"
    static var portraitStyle = "portrait"
    static var squareStyle = "square"
    static var landscapeStyle = "landscape"
    static var advertisementStyle = "advertisement_1"
}

struct DetailRowsValue {
    static var episodeStyle = "episodes"
    static var seasonStyle = "seasons"
    static var moreFromDirectorStyle = "more-from-director"
    static var moreFromStudioStyle = "more-from-studio"
    static var productRelatedStyle = "product-related"
}


let ServerUrl = "http://7-api.nodplatform.com/apps/v4/vapr/"
let StreamTrackingUrl = "https://7-api.nodplatform.com/stream.track/4/beacon.json"
let headerKeyName = "X-API_KEY"
let headerAccessTokenKey = "X-ACCESS_TOKEN"
let apiHeaderKey = "0XeolaalWSQSEgQVRUWFZpEAhNTmchSJ"
let monetizationKey = "monetization"
let selectedPlanKey = "selectedPlan"
let eligibilityStatusKey = "eligibilityStatus"
let nameKey = "name"
let emailKey = "email"
let passwordKey = "password"
let firstNameKey = "firstName"
let lastNameKey = "lastName"
let emailOptInKey = "emailOptIn"

let HomeApi = "home.json"
let HomeStatusApi = "home-status.json"
let FavoriteApi = "favorites"
let LoginApi = "auth.json"
let WatchNowApi = "watch"
let ProductApi = "products"
let EntitledApi = "/entitled.json"
let LibraryApi = "library.json"
let GetCustomerDetailApi = "customer.json"
let LogoutApi = "deauth.json"
let SearchSuggestApi = "search/suggest.json"
let SearchApi = "search/search.json"
let PasswordResetApi = "account/password-reset.json"
let SettingsApi = "settings.json"
let CheckAccountApi = "signup/account-check.json"
let ProcessSubscriptionApi = "signup/process.json"
let cancelMembershipApi = "membership/cancel.json"
let restartMembershipApi = "membership/restart.json"
@available(iOS 13.0, *)
let appDelegate = UIApplication.shared.delegate as! AppDelegate


/*  ***********************USER DEFAULT VALUE **********************************
saveStringInDefault(value: self.txtFieldNumber.text!, key: "phoneNumber")

 */

