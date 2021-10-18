//
//  MatchesData.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import Foundation
struct Match : Codable {

        let groupName : String?
        let matchDate : String?
        let matchName : String?
        let mID : Int?
        let season : String?
        let status : Int?
        let teamA : String?
        let teamALogo : String?
        let teamB : String?
        let teamBLogo : String?
        let venue : String?

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
        }
    
}



