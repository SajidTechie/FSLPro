//
//  MyJoinedLeagueData.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation
struct MyJoinedLeagueData : Codable {

        let id : Int?
        let lName : String?
        let winning : Double?

        enum CodingKeys: String, CodingKey {
                case id = "id"
                case lName = "LName"
                case winning = "Winning"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(Int.self, forKey: .id)
                lName = try values.decodeIfPresent(String.self, forKey: .lName)
                winning = try values.decodeIfPresent(Double.self, forKey: .winning)
        }

}
