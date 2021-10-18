//
//  GetRulesData.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation
struct GetRulesData : Codable {

        let minmax : [GetRules0]?
        let bal : GetRules1?

        enum CodingKeys: String, CodingKey {
                case minmax = "0"
                case bal = "1"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                minmax = try values.decodeIfPresent([GetRules0].self, forKey: .minmax)
                bal = try values.decodeIfPresent(GetRules1.self, forKey: .bal)
           
        }

}


struct GetRules1 : Codable {

        let bAL : Int?
        let dN : String?

        enum CodingKeys: String, CodingKey {
                case bAL = "BAL"
                case dN = "DN"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                bAL = try values.decodeIfPresent(Int.self, forKey: .bAL)
                dN = try values.decodeIfPresent(String.self, forKey: .dN)
        }

}


struct GetRules0 : Codable {

        let max : Int?
        let min : Int?
        let role : String?

        enum CodingKeys: String, CodingKey {
                case max = "max"
                case min = "min"
                case role = "role"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                max = try values.decodeIfPresent(Int.self, forKey: .max)
                min = try values.decodeIfPresent(Int.self, forKey: .min)
                role = try values.decodeIfPresent(String.self, forKey: .role)
        }

}
