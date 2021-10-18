//
//  LiveScore.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation
//struct LiveScoreData : Codable {
//    
//    let teamA,teamB : String?
//    
//    enum CodingKeys: String, CodingKey {
//        case teamA = "TeamAScore"
//        case teamB = "TeamBScore"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        teamA = try values.decodeIfPresent(String.self, forKey: .teamA)
//        teamB = try values.decodeIfPresent(String.self, forKey: .teamB)
//    }
//    
//}

struct LiveScoreData : Codable {
    
    var groupName : String?
    var matchDate : String?
    var matchName : String?
    var mID : Int?
    var position = 0
    var season : String?
    var status : Int?
    var teamA : String?
    var teamALogo : String?
    var teamB : String?
    var teamBLogo : String?
    var venue : String?
    var teamAScore,teamBScore : String?
    
    enum CodingKeys: String, CodingKey {
        case groupName = "GroupName"
        case matchDate = "MatchDate"
        case matchName = "MatchName"
        case mID = "MID"
        case season = "Season"
        case status = "Status"
        case teamA = "TeamA"
        case teamALogo = "TeamALogo"
        case teamB = "TeamB"
        case teamBLogo = "TeamBLogo"
        case venue = "Venue"
        case teamAScore = "TeamAScore"
        case teamBScore = "TeamBScore"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        groupName = try values.decodeIfPresent(String.self, forKey: .groupName)
        matchDate = try values.decodeIfPresent(String.self, forKey: .matchDate)
        matchName = try values.decodeIfPresent(String.self, forKey: .matchName)
        mID = try values.decodeIfPresent(Int.self, forKey: .mID)
        season = try values.decodeIfPresent(String.self, forKey: .season)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        teamA = try values.decodeIfPresent(String.self, forKey: .teamA)
        teamALogo = try values.decodeIfPresent(String.self, forKey: .teamALogo)
        teamB = try values.decodeIfPresent(String.self, forKey: .teamB)
        teamBLogo = try values.decodeIfPresent(String.self, forKey: .teamBLogo)
        venue = try values.decodeIfPresent(String.self, forKey: .venue)
        teamAScore = try values.decodeIfPresent(String.self, forKey: .teamAScore)
        teamBScore = try values.decodeIfPresent(String.self, forKey: .teamBScore)
    }
    
}

extension LiveScoreData {
    init(groupName : String?,
         matchDate : String?,
         matchName : String?,
         mID : Int?,
         position : Int?,
         season : String?,
         status : Int?,
         teamA : String?,
         teamALogo : String?,
         teamB : String?,
         teamBLogo : String?,
         teamAScore : String?,
         teamBScore : String?,
         venue : String?) {
        self.groupName = groupName
        self.matchDate = matchDate
        self.matchName = matchName
        self.mID = mID
        self.position = position ?? 0
        self.season = season
        self.status = 0
        self.teamA = teamA
        self.teamALogo = teamALogo
        self.teamB = teamB
        self.teamBLogo = teamBLogo
        self.teamAScore = teamAScore
        self.teamBScore = teamBScore
        self.venue = venue
    }
}
