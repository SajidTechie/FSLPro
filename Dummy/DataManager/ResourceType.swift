//
//  ResourceType.swift
//  DigitasWorld
//
//  Created by ashok on 02/09/20.
//  Copyright © 2020 eSoft Technologies. All rights reserved.
//

import Foundation
import Moya

enum ResourceType {
    case appConfig
    case getADRewards(adid:String)
    case getUserProfile
    case editUserProfile(payloadprofile:ProfileObj)
    case getPincode(pincode:Int)
    case matches(mid: Int)
    case myTeam(mid: Int)
    case getMatchAllPlayer(mid: Int)
    case getLiveScore(mid: Int)
    case getSelectedTeamList(mid: Int,teamid: Int)
    case updateTeam(mid: Int,teamid: Int,teamDetail:[playerDetailObj])
    case getLeaguesForMatch(mid: Int)
    case getMatchRules
    case getMatchScoreCard(mid: Int)
    case aboutMatch(mid: Int)
    case joinLeague(mid: Int,lid: Int,teamid: Int)
    case getMyJoinedLeagues(mid: Int)
    case getMyJoinedLeaguesDetail(mid: Int,lid: Int)
    case getLeagueEntryDetails(mid: Int,lid: Int)
    case getTeamRank(mid: Int)
    case getLeaderBoard(mid: Int,lid: Int)
    case getTeamPoints(mid: Int,teamid: Int)
    case sendSMS(payloadsms:AuthPayloadObj,token:String)
    case verifyOtp(payloadotp:AuthPayloadObj,initialToken:String)
    case initialToken
    case refreshToken(phone:String,device:String)
    case getRewardsList
    case collectRewards(type:Int)
    case uploadFile(type:Int)// - - -remove this later @part
    case contactUs(payloadcontactus:AuthPayloadObj)
    case sponsor(payloadsponsor:AuthPayloadObj)
    
}



extension ResourceType: TargetType {
  
    var baseURL: URL {
        
        switch self {
        case .sendSMS(_):
            return URL(string:Constant.AUTH_URL)!
        case .verifyOtp(_):
            return URL(string:Constant.AUTH_URL)!
        case .initialToken:
            return URL(string:Constant.REFRESH_TOKEN_URL)!
        case .refreshToken:
            return URL(string:Constant.REFRESH_TOKEN_URL)!
        default:
            return URL(string:Constant.BASE_URL)!
        }
    }
   
    var path: String {
        switch self {
        case .matches(let mid):
            return "matches/\(mid)"
        case .myTeam(mid: let mid):
            return "match/\(mid)/teams"
        case .getMatchAllPlayer(mid: let mid):
            return "match/\(mid)/player"
        case .getLiveScore(mid: let mid):
            return "match/\(mid)/score"
        case .getSelectedTeamList(mid: let mid, teamid: let teamid):
            return "match/\(mid)/player/\(teamid)"
        case .updateTeam(mid: let mid, teamid: let teamid,_):
            return "match/\(mid)/team/\(teamid)"
        case .getLeaguesForMatch(mid: let mid):
            return "match/\(mid)/league"
        case .getMatchRules:
            return "match/rules"
        case .getMatchScoreCard(mid: let mid):
            return "match/\(mid)/new-score"
        case .aboutMatch(mid: let mid):
            return "match/\(mid)/info"
        case .getTeamRank(mid: let mid):
            return "my/\(mid)/rank"
        case .joinLeague(mid: let mid, lid: let lid, teamid: let teamid):
            return "join/\(mid)/\(lid)/\(teamid)"
        case .getMyJoinedLeagues(mid: let mid):
            return "my/\(mid)"
        case .getMyJoinedLeaguesDetail(mid: let mid, lid: let lid):
            return "match/\(mid)/league/\(lid)"
        case .getLeagueEntryDetails(mid: let mid, lid: let lid):
            return "my/\(mid)/det/\(lid)"
        case .getLeaderBoard(mid: let mid, lid: let lgid):
            return "my/\(mid)/rank/\(lgid)"
        case .getTeamPoints(mid: let mid, teamid: let teamid):
            return "my/\(mid)/team/\(teamid)"
        case .sendSMS(_):
            return ""
        case .verifyOtp(_):
            return ""
        case .initialToken:
            return ""
        case .refreshToken:
            return ""
        case .appConfig:
            return "version"
        case .getADRewards(adid: let adid):
            return "rewards/ads/\(adid)"
        case .getUserProfile:
            return "profile"
        case .editUserProfile:
            return "profile"
        case .getPincode(pincode: let pincode):
            return "zip/\(pincode)"
        case .getRewardsList:
            return "rewards"
        case .collectRewards(type: let type):
            return "rewards/collect/\(type)"
        case .uploadFile(type: let type):
            return "file/apy12"
        case .contactUs(payloadcontactus: let payloadcontactus):
            return "query"
        case .sponsor(payloadsponsor: let payloadsponsor):
            return "sponsor"
        }
    }
    
    
    var method: Moya.Method {
        switch self {
        case .matches,.myTeam,.getMatchAllPlayer,.getLiveScore,.getSelectedTeamList,.getLeaguesForMatch,.getMatchRules,.getMatchScoreCard,.aboutMatch,.getTeamRank,.joinLeague,.getMyJoinedLeaguesDetail,.getMyJoinedLeagues,.getLeagueEntryDetails,.getLeaderBoard,.getTeamPoints,.appConfig,.getRewardsList,.getUserProfile,.getADRewards,.getPincode,.collectRewards:
            return .get
        case .updateTeam,.sendSMS,.verifyOtp,.initialToken,.refreshToken,.editUserProfile,.uploadFile,.contactUs,.sponsor:
            return.post
        }
    }
    
   
    
    var task: Task {
        switch self {
        case .matches,.myTeam,.getMatchAllPlayer,.getLiveScore,.getSelectedTeamList,.getLeaguesForMatch,.getMatchRules,.getMatchScoreCard,.aboutMatch,.getTeamRank,.joinLeague,.getMyJoinedLeaguesDetail,.getMyJoinedLeagues,.getLeagueEntryDetails,.getLeaderBoard,.getTeamPoints,.appConfig,.getADRewards,.getUserProfile,.getPincode,.getRewardsList,.collectRewards,.uploadFile:
            return .requestPlain
            
        case let .updateTeam(_,_,teamDetail):
            return .requestJSONEncodable(teamDetail)
            
        case let .sendSMS(payloadsms,_):
            return .requestJSONEncodable(payloadsms)
         
        case let .contactUs(payloadcontactus):
            return .requestJSONEncodable(payloadcontactus)
     
        case let .editUserProfile(payloadprofile):
            return .requestJSONEncodable(payloadprofile)
            
        case let .sponsor(payloadsponsor):
            return .requestJSONEncodable(payloadsponsor)
            
        case let .verifyOtp(payloadotp,_):
            return .requestJSONEncodable(payloadotp)
            
        case .initialToken:
            return .requestParameters(parameters: ["grant_type": Constant.INITIAL_GRANT_TYPE, "client_id": Constant.INITIAL_CLIENT_ID,"client_secret": Constant.INITIAL_CLIENT_SECRET], encoding: URLEncoding.httpBody)

        case let .refreshToken(phone,device):
            return .requestParameters(parameters: ["grant_type": Constant.GRANT_TYPE,"username": phone,"password": device, "client_id": Constant.CLIENT_ID,"client_secret": Constant.CLIENT_SECRET], encoding: URLEncoding.httpBody)
            
//        case let .updateUser(_, firstName, lastName):  // Always sends parameters in URL, regardless of which HTTP method is used
//                    return .requestParameters(parameters: ["first_name": firstName, "last_name": lastName], encoding: URLEncoding.queryString)
//                case let .createUser(firstName, lastName): // Always send parameters as JSON in request body
//                    return .requestParameters(parameters: ["first_name": firstName, "last_name": lastName], encoding: JSONEncoding.default)
            

        }
    }
    
  
    var headers: [String : String]? {
        switch self {
        case let .sendSMS(_,token):
            return ["Authorization":"Bearer \(token)"]
        case let .verifyOtp(_,initialToken):
            return ["Authorization":"Bearer \(initialToken)"]
        case .initialToken:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        case .refreshToken:
            return ["Content-type": "application/x-www-form-urlencoded"]
        default:
            return ["Authorization":"Bearer \(Utility.getToken())"]
        }
    }
 
    var sampleData: Data {
        return Data()
      }
   
}
