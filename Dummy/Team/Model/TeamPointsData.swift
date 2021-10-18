//
//  TeamPointsData.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation
struct TeamPointsData : Codable {

        let dN : String?
        let extRole : String?
        let pFullName : String?
        let play : Int?
        let pName : String?
        let rName : String?
        let score : Float?
        let tLogo : String?
        let tName : String?

        enum CodingKeys: String, CodingKey {
                case dN = "DN"
                case extRole = "extRole"
                case pFullName = "PFullName"
                case play = "in"
                case pName = "PName"
                case rName = "RName"
                case score = "score"
                case tLogo = "TLogo"
                case tName = "TName"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                dN = try values.decodeIfPresent(String.self, forKey: .dN)
                extRole = try values.decodeIfPresent(String.self, forKey: .extRole)
                pFullName = try values.decodeIfPresent(String.self, forKey: .pFullName)
                play = try values.decodeIfPresent(Int.self, forKey: .play)
                pName = try values.decodeIfPresent(String.self, forKey: .pName)
                rName = try values.decodeIfPresent(String.self, forKey: .rName)
                score = try values.decodeIfPresent(Float.self, forKey: .score)
                tLogo = try values.decodeIfPresent(String.self, forKey: .tLogo)
                tName = try values.decodeIfPresent(String.self, forKey: .tName)
        }

}
