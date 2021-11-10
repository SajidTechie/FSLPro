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
    case sendSMS(teamDetail:[playerDetailObj])
    case verifyOtp(teamDetail:[playerDetailObj])
    case initialToken
    case refreshToken
    
}


extension ResourceType: TargetType {
  
    var baseURL: URL {
        
        switch self {
        case .sendSMS(let loginObj):
            return URL(string:Constant.AUTH_URL)!
        case .verifyOtp(let loginObj):
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
            
            
            
            
            
//            @POST()
//            suspend fun sendSms(
//                @Header("authorization") token: String?,
//                    @Url url : String? = AUTH_URL,
//                    @Body payload: JsonObject?,
//            ): Response<SmsResponse>
//
//            @POST()
//            suspend fun verifyOtp(
//                    @Header("authorization") token: String?,
//                    @Url url : String? = AUTH_URL,
//                    @Body payload: JsonObject?,
//            ): Response<SmsResponse?>
//            @FormUrlEncoded
//            @POST()
//            suspend fun initialToken(
//                    @Field("grant_type") grantType: String,
//                    @Field("client_id") clientId: String,
//                    @Field("client_secret") clientSecret: String,
//                    @Url url : String? = REFRESH_TOKEN_URL,
//            ): Response<RefreshTokenResponse>
//
//            @FormUrlEncoded
//            @POST()
//            suspend fun refreshToken(
//                    @Field("grant_type") grantType: String,
//                    @Field("username") mobileNo: String?,
//                    @Field("password") deviceId: String?,
//                    @Field("client_id") clientId: String,
//                    @Field("client_secret") clientSecret: String,
//                    @Url url : String? = REFRESH_TOKEN_URL,
//            ): Response<RefreshTokenResponse>
            
            
        }
    }
    
    
    var method: Moya.Method {
        switch self {
        case .matches,.myTeam,.getMatchAllPlayer,.getLiveScore,.getSelectedTeamList,.getLeaguesForMatch,.getMatchRules,.getMatchScoreCard,.aboutMatch,.getTeamRank,.joinLeague,.getMyJoinedLeaguesDetail,.getMyJoinedLeagues,.getLeagueEntryDetails,.getLeaderBoard,.getTeamPoints:
            return .get
        case .updateTeam,.sendSMS,.verifyOtp,.initialToken,.refreshToken:
            return.post
    }
    }
    
    var task: Task {
        switch self {
        case .matches,.myTeam,.getMatchAllPlayer,.getLiveScore,.getSelectedTeamList,.getLeaguesForMatch,.getMatchRules,.getMatchScoreCard,.aboutMatch,.getTeamRank,.joinLeague,.getMyJoinedLeaguesDetail,.getMyJoinedLeagues,.getLeagueEntryDetails,.getLeaderBoard,.getTeamPoints:
            return .requestPlain
            
        case let .updateTeam(_,_,teamDetail):
            return .requestJSONEncodable(teamDetail)
            
        case let .sendSMS(teamDetail):
            return .requestJSONEncodable(teamDetail)
            
        case let .verifyOtp(teamDetail):
            return .requestJSONEncodable(teamDetail)
            
        case let .initialToken:
            return .requestPlain

        case let .refreshToken:
            return .requestPlain
            
        }
    }
    
    
    var headers: [String : String]? {
        return ["Authorization":"Bearer \(Constant.AUTH_TOKEN)"]
    }
    

    var sampleData: Data {
        return Data()
      }
   
}
