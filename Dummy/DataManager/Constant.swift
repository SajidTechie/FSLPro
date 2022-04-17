//
//  Constant.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import Foundation
class Constant {
 
//    static let UAT_BASE_URL = "http://data.fslpro.in/" //match/111/league
//    static let UAT_AUTH_URL = "http://data.fslpro.in/register"
 //   static let UAT_REFRESH_TOKEN_URL = "http://security.fslpro.in/connect/token"
  //  static let UAT_WEBSITE_URL = "http://fslpro.in"
    static let POINTS_WEB_URL = "https://fslpro.com/home/points"
    static let TERMS_WEB_URL = "https://fslpro.com/home/terms"
    static let HOW_TO_PLAY_WEB_URL = "https://fslpro.com/home/how"
    
    static let AUTH_URL = "https://data.fslpro.com/register"
    static let REFRESH_TOKEN_URL = "https://security.fslpro.com/connect/token"
    
   // static let AUTH_TOKEN = "6FADF6215DF05CF8533D67274CDE6F7D81D7EA05BD0672A35980D4410088C129"
    static let TYPE_NO_DATA = 10000
  //  static let BASE_URL = "https://fslpro.com/api"
    static let BASE_URL = "https://data.fslpro.com"
    static let SUCCESS_CODE = "200"
    static let NO_DATA_CODE = "2002"
    static let WEBSITE_URL = "https://fslpro.com"
  //  static let NO_IMAGE_ICON = "flagHome.png"
    static let NO_IMAGE_HOME_ICON = "flagHome.png"
    static let NO_IMAGE_AWAY_ICON = "flagAway.png"
    // ------- ---------------- -------------------------- --------------------------------
    static let LIVE_REFRESH_RATE : TimeInterval = 50 //20 secs
    static let TICK_TOCK_INTERVAL = 1000
    static let OTP_TIMER = 60
    
    static let NORMAL_LEAGUE_TYPE = 1
    static let UNLIMITED_LEAGUE_TYPE = 10
    static let SPONSOR_LEAGUE_TYPE = 100
    
    static let INITIAL_API = "INITIAL_API"
    static let MY_TEAM = "MY_TEAM"
    static let UPCOMING_MATCHES = "UPCOMING_MATCHES"
    static let LEAGUES_FOR_MATCH = "LEAGUES_FOR_MATCH"
    static let MY_JOINED_LEAGUES = "MY_JOINED_LEAGUES"
    static let LEAGUE_ENTRY_DETAILS = "LEAGUE_ENTRY_DETAILS"
    static let MY_TEAM_RANK = "MY_TEAM_RANK"
    static let LEADER_BOARD = "LEADER_BOARD"
    static let TEAM_POINTS = "TEAM_POINTS"
    static let SEND_SMS = "SEND_SMS"
    static let RULES = "RULES"
    static let VERIFY_OTP = "VERIFY_OTP"
    static let USER_PROFILE = "USER_PROFILE"
    static let EDIT_PROFILE = "EDIT_PROFILE"
    static let TOKEN_REFRESH = "TOKEN_REFRESH"
    static let INITIAL_TOKEN = "INITIAL_TOKEN"
    static let JOINED_LEAGUES_DETAIL = "JOINED_LEAGUES_DETAIL"
    static let SCORECARD = "SCORECARD"
    static let ABOUT_MATCH = "ABOUT_MATCH"
    static let CREATE_EDIT_TEAM = "CREATE_EDIT_TEAM"
    static let ALL_TEAM_PLAYERS = "ALL_TEAM_PLAYERS"
    static let SELECTED_TEAM_PLAYERS = "SELECTED_TEAM_PLAYERS"
    static let JOIN_LEAGUE = "JOIN_LEAGUE"
    static let LIVE_SCORE = "LIVE_SCORE"
    static let PINCODE = "PINCODE"
    
    static let GRANT_TYPE = "password"
    static let TOKEN_TYPE = "Bearer"
    static let CLIENT_ID = "FSL.MOBILE.IOS"
   // static let CLIENT_SECRET = "Z2obv!llTT5(N1H0Mm3mia0vG5<GBR"
    static let CLIENT_SECRET = "QRwy@X(m8gp*G$kdecjOEO5VAXdhV4"

    static let INITIAL_GRANT_TYPE = "client_credentials"
    static let INITIAL_CLIENT_ID = "FSL.MOBILE"
    static let INITIAL_CLIENT_SECRET = "snPi((jv1f7d#P0PfXxZ5ix60*Toz1"

    static let USER_ALREADY_EXISTS = "duplicate phone"
}

