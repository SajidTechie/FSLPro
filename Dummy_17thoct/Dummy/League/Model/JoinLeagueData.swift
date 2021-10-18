//
//  JoinedLeagueData.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation

struct JoinedLeagueData : Codable {
    
    let joinedLeague : Int?
    let status : String?
    
    enum CodingKeys: String, CodingKey {
        case joinedLeague = "JoinedLeague"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        joinedLeague = try values.decodeIfPresent(Int.self, forKey: .joinedLeague)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
    
}
