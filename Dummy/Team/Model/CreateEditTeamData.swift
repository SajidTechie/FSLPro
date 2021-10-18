//
//  CreateEditTeamData.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation
struct CreateEditTeamData : Codable {

        let tID : Int?

        enum CodingKeys: String, CodingKey {
                case tID = "TID"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                tID = try values.decodeIfPresent(Int.self, forKey: .tID)
        }

}
