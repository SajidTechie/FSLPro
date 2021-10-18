//
//  LeagueEntryDetailsData.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation
struct LeagueEntryDetailsData : Codable {

        let dN : String?
        let flg : String?
        let lN : String?
        let swap : Int?
        let tID : Int?
        let tN : String?

        enum CodingKeys: String, CodingKey {
                case dN = "DN"
                case flg = "flg"
                case lN = "LN"
                case swap = "swap"
                case tID = "TID"
                case tN = "TN"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                dN = try values.decodeIfPresent(String.self, forKey: .dN)
                flg = try values.decodeIfPresent(String.self, forKey: .flg)
                lN = try values.decodeIfPresent(String.self, forKey: .lN)
                swap = try values.decodeIfPresent(Int.self, forKey: .swap)
                tID = try values.decodeIfPresent(Int.self, forKey: .tID)
                tN = try values.decodeIfPresent(String.self, forKey: .tN)
        }

}
