//
//  MyTeamData.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation
struct MyTeamNameData : Codable {

        let name : String?
        let player : String?
        let role : String?
        let status : Int?
        let tID : Int?

        enum CodingKeys: String, CodingKey {
                case name = "Name"
                case player = "player"
                case role = "role"
                case status = "status"
                case tID = "TID"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                name = try values.decodeIfPresent(String.self, forKey: .name)
                player = try values.decodeIfPresent(String.self, forKey: .player)
                role = try values.decodeIfPresent(String.self, forKey: .role)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
                tID = try values.decodeIfPresent(Int.self, forKey: .tID)
        }

}
