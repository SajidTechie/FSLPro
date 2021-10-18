//
//  TeamRankData.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation
struct TeamRankData : Codable {

        let fees : Double?
        let id : Int?
        let lName : String?
        let state : Int?
        let status : Int?
        let winning : Double?

        enum CodingKeys: String, CodingKey {
                case fees = "fees"
                case id = "id"
                case lName = "LName"
                case state = "state"
                case status = "Status"
                case winning = "Winning"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                fees = try values.decodeIfPresent(Double.self, forKey: .fees)
                id = try values.decodeIfPresent(Int.self, forKey: .id)
                lName = try values.decodeIfPresent(String.self, forKey: .lName)
                state = try values.decodeIfPresent(Int.self, forKey: .state)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
                winning = try values.decodeIfPresent(Double.self, forKey: .winning)
        }

}
