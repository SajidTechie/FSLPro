//
//  LeagueData.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation

struct LeagueDetailData : Codable {

        let isElastic : Bool?
        let isOpen : Bool?
        let j : Int?
        let lCurSize : Int?
        var position = 0
        let lDesc : String?
        let lEntryFees : Double?
        let lgId : Int?
        let lMaxSize : Int?
        let lMID : Int?
        let lMinEntries : Int?
        let lName : String?
        let lWinner : Int?
        let wData : LeagueWDatum?
        let wDesc : String?
        let winningAmt : Double?

        enum CodingKeys: String, CodingKey {
                case isElastic = "IsElastic"
                case isOpen = "isOpen"
                case j = "j"
                case lCurSize = "LCurSize"
                case lDesc = "LDesc"
                case lEntryFees = "LEntryFees"
                case lgId = "LgId"
                case lMaxSize = "LMaxSize"
                case lMID = "LMID"
                case lMinEntries = "LMinEntries"
                case lName = "LName"
                case lWinner = "LWinner"
                case wData = "wData"
                case wDesc = "wDesc"
                case winningAmt = "WinningAmt"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                isElastic = try values.decodeIfPresent(Bool.self, forKey: .isElastic)
                isOpen = try values.decodeIfPresent(Bool.self, forKey: .isOpen)
                j = try values.decodeIfPresent(Int.self, forKey: .j)
                lCurSize = try values.decodeIfPresent(Int.self, forKey: .lCurSize)
                lDesc = try values.decodeIfPresent(String.self, forKey: .lDesc)
                lEntryFees = try values.decodeIfPresent(Double.self, forKey: .lEntryFees)
                lgId = try values.decodeIfPresent(Int.self, forKey: .lgId)
                lMaxSize = try values.decodeIfPresent(Int.self, forKey: .lMaxSize)
                lMID = try values.decodeIfPresent(Int.self, forKey: .lMID)
                lMinEntries = try values.decodeIfPresent(Int.self, forKey: .lMinEntries)
                lName = try values.decodeIfPresent(String.self, forKey: .lName)
                lWinner = try values.decodeIfPresent(Int.self, forKey: .lWinner)
                wData = try values.decodeIfPresent(LeagueWDatum.self, forKey: .wData)
                wDesc = try values.decodeIfPresent(String.self, forKey: .wDesc)
                winningAmt = try values.decodeIfPresent(Double.self, forKey: .winningAmt)
        }

}

struct LeagueWDatum : Codable {

        let ent : Int?
        let prz : Int?
        let rnk : [LeagueRnk]?
        let w : Int?

        enum CodingKeys: String, CodingKey {
                case ent = "ent"
                case prz = "prz"
                case rnk = "rnk"
                case w = "w"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                ent = try values.decodeIfPresent(Int.self, forKey: .ent)
                prz = try values.decodeIfPresent(Int.self, forKey: .prz)
                rnk = try values.decodeIfPresent([LeagueRnk].self, forKey: .rnk)
                w = try values.decodeIfPresent(Int.self, forKey: .w)
        }

}


struct LeagueRnk : Codable {

        let o : String?
        let prz : Int?

        enum CodingKeys: String, CodingKey {
                case o = "o"
                case prz = "prz"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                o = try values.decodeIfPresent(String.self, forKey: .o)
                prz = try values.decodeIfPresent(Int.self, forKey: .prz)
        }

}
