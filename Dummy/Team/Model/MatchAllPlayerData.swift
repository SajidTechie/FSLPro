//
//  MatchAllPlayerData.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation
struct MatchAllPlayerData : Codable {

        var extRole : String?
        let play : Int?
        let pID : Int?
        let pName : String?
        let rName : String?
        var selected : Bool?
        let tID : Int?
        let tLogo : String?
        let tName : String?

        enum CodingKeys: String, CodingKey {
                case extRole = "extRole"
                case play = "in"
                case pID = "PID"
                case pName = "PName"
                case rName = "RName"
                case selected = "selected"
                case tID = "TID"
                case tLogo = "TLogo"
                case tName = "TName"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                extRole = try values.decodeIfPresent(String.self, forKey: .extRole)
                play = try values.decodeIfPresent(Int.self, forKey: .play)
                pID = try values.decodeIfPresent(Int.self, forKey: .pID)
                pName = try values.decodeIfPresent(String.self, forKey: .pName)
                rName = try values.decodeIfPresent(String.self, forKey: .rName)
                selected = try values.decodeIfPresent(Bool.self, forKey: .selected)
                tID = try values.decodeIfPresent(Int.self, forKey: .tID)
                tLogo = try values.decodeIfPresent(String.self, forKey: .tLogo)
                tName = try values.decodeIfPresent(String.self, forKey: .tName)
        }

}
