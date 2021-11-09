//
//  LeaderboardData.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation

struct LeaderboardData : Codable {
    
    let c : String?
    let dN : String?
    let id : Int?
    let lName : String?
    let name : String?
    let rank : Int?
    let score : Float?
    let state : Int?
    let wamt : Double?
    let flg : String?
    
    enum CodingKeys: String, CodingKey {
        case c = "c"
        case dN = "DN"
        case id = "id"
        case lName = "LName"
        case name = "name"
        case rank = "rank"
        case score = "score"
        case state = "state"
        case wamt = "wamt"
        case flg = "flg"
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        c = try values.decodeIfPresent(String.self, forKey: .c)
        dN = try values.decodeIfPresent(String.self, forKey: .dN)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        lName = try values.decodeIfPresent(String.self, forKey: .lName)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        rank = try values.decodeIfPresent(Int.self, forKey: .rank)
        score = try values.decodeIfPresent(Float.self, forKey: .score)
        state = try values.decodeIfPresent(Int.self, forKey: .state)
        wamt = try values.decodeIfPresent(Double.self, forKey: .wamt)
        flg = try values.decodeIfPresent(String.self, forKey: .flg)
    }
    
}
