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
    case updateTeam(mid: Int,teamid: Int)
    case getLeaguesForMatch(mid: Int)
    case getMatchRules
    case getMatchScoreCard(mid: Int)
    case aboutMatch(mid: Int)
    case joinLeague(mid: Int,lid: Int,teamid: Int)
    case getMyJoinedLeagues(mid: Int)
    case getMyJoinedLeaguesDetail(mid: Int,lid: Int)
    case getLeagueEntryDetails(mid: Int,teamid: Int)
    case getTeamRank(mid: Int)
    case getLeaderBoard(mid: Int,lid: Int)
    case getTeamPoints(mid: Int,teamid: Int)
}


extension ResourceType: TargetType {
    
    var baseURL: URL {
        return URL(string:Constant.BASE_URL)!
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
        case .updateTeam(mid: let mid, teamid: let teamid):
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
        case .getLeagueEntryDetails(mid: let mid, teamid: let teamid):
            return "my/\(mid)/det/\(teamid)"
        case .getLeaderBoard(mid: let mid, lid: let lgid):
            return "my/\(mid)/rank/\(lgid)"
        case .getTeamPoints(mid: let mid, teamid: let teamid):
            return "my/\(mid)/team/\(teamid)"
        }
    }
    
    
    var method: Moya.Method {
        switch self {
        case .matches,.myTeam,.getMatchAllPlayer,.getLiveScore,.getSelectedTeamList,.getLeaguesForMatch,.getMatchRules,.getMatchScoreCard,.aboutMatch,.getTeamRank,.joinLeague,.getMyJoinedLeaguesDetail,.getMyJoinedLeagues,.getLeagueEntryDetails,.getLeaderBoard,.getTeamPoints:
            return .get
        case .updateTeam:
            return.post
        }
    }
    
    var task: Task {
        switch self {
        case .matches,.myTeam,.getMatchAllPlayer,.getLiveScore,.getSelectedTeamList,.getLeaguesForMatch,.getMatchRules,.getMatchScoreCard,.aboutMatch,.getTeamRank,.joinLeague,.getMyJoinedLeaguesDetail,.getMyJoinedLeagues,.getLeagueEntryDetails,.getLeaderBoard,.getTeamPoints,.updateTeam:
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
