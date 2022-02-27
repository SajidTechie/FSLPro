//
//  LeagueData.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation

struct LeagueDetailData : Codable {
    
    let LgId: Int?
    let LMID: Int?
    let ltype: Int?
    let WinningAmt: Double?
    let LMaxSize: Int?
    var position = 0
    let LCurSize: Int?
    let isOpen: Bool?
    let LName: String?
    let LDesc: String?
    let LMinEntries: Int?
    let IsElastic: Bool?
    let LEntryFees: Double?
    let LWinner: Int?
    let wData: LeagueWDatum?
    let j: Int?
    let awards: [Awards]?
    
    private enum CodingKeys: String, CodingKey {
        case LgId = "LgId"
        case LMID = "LMID"
        case ltype = "ltype"
        case WinningAmt = "WinningAmt"
        case LMaxSize = "LMaxSize"
        case LCurSize = "LCurSize"
        case isOpen = "isOpen"
        case LName = "LName"
        case LDesc = "LDesc"
        case LMinEntries = "LMinEntries"
        case IsElastic = "IsElastic"
        case LEntryFees = "LEntryFees"
        case LWinner = "LWinner"
        case wData = "wData"
        case j = "j"
        case awards = "awards"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        LgId = try values.decode(Int.self, forKey: .LgId)
        LMID = try values.decode(Int.self, forKey: .LMID)
        ltype = try values.decode(Int.self, forKey: .ltype)
        WinningAmt = try values.decode(Double.self, forKey: .WinningAmt)
        LMaxSize = try values.decode(Int.self, forKey: .LMaxSize)
        LCurSize = try values.decode(Int.self, forKey: .LCurSize)
        isOpen = try values.decode(Bool.self, forKey: .isOpen)
        LName = try values.decode(String.self, forKey: .LName)
        LDesc = try values.decode(String.self, forKey: .LDesc)
        LMinEntries = try values.decode(Int.self, forKey: .LMinEntries)
        IsElastic = try values.decode(Bool.self, forKey: .IsElastic)
        LEntryFees = try values.decode(Double.self, forKey: .LEntryFees)
        LWinner = try values.decode(Int.self, forKey: .LWinner)
        wData = try values.decode(LeagueWDatum.self, forKey: .wData)
        j = try values.decode(Int.self, forKey: .j)
        awards = try values.decode([Awards].self, forKey: .awards)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(LgId, forKey: .LgId)
        try container.encode(LMID, forKey: .LMID)
        try container.encode(ltype, forKey: .ltype)
        try container.encode(WinningAmt, forKey: .WinningAmt)
        try container.encode(LMaxSize, forKey: .LMaxSize)
        try container.encode(LCurSize, forKey: .LCurSize)
        try container.encode(isOpen, forKey: .isOpen)
        try container.encode(LName, forKey: .LName)
        try container.encode(LDesc, forKey: .LDesc)
        try container.encode(LMinEntries, forKey: .LMinEntries)
        try container.encode(IsElastic, forKey: .IsElastic)
        try container.encode(LEntryFees, forKey: .LEntryFees)
        try container.encode(LWinner, forKey: .LWinner)
        try container.encode(wData, forKey: .wData)
        try container.encode(j, forKey: .j)
        try container.encode(awards, forKey: .awards)
    }
    
}

struct LeagueWDatum : Codable {
    
    let ent: Int?
    let prz: Int?
    let w: Int?
    let rnk: [LeagueRnk]?
    
    private enum CodingKeys: String, CodingKey {
        case ent = "ent"
        case prz = "prz"
        case w = "w"
        case rnk = "rnk"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ent = try values.decode(Int.self, forKey: .ent)
        prz = try values.decode(Int.self, forKey: .prz)
        w = try values.decode(Int.self, forKey: .w)
        rnk = try values.decode([LeagueRnk].self, forKey: .rnk)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ent, forKey: .ent)
        try container.encode(prz, forKey: .prz)
        try container.encode(w, forKey: .w)
        try container.encode(rnk, forKey: .rnk)
    }
    
}


struct LeagueRnk : Codable {
    
    let o: String?
    let coin: Int?
    
    private enum CodingKeys: String, CodingKey {
        case o = "o"
        case coin = "coin"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        o = try values.decode(String.self, forKey: .o)
        coin = try values.decode(Int.self, forKey: .coin)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(o, forKey: .o)
        try container.encode(coin, forKey: .coin)
    }
}

struct Awards: Codable {
    
    let desc: String?
    let img: String?
    let itm: String?
    
    private enum CodingKeys: String, CodingKey {
        case desc = "desc"
        case img = "img"
        case itm = "itm"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        desc = try values.decode(String.self, forKey: .desc)
        img = try values.decode(String.self, forKey: .img)
        itm = try values.decode(String.self, forKey: .itm)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(desc, forKey: .desc)
        try container.encode(img, forKey: .img)
        try container.encode(itm, forKey: .itm)
    }
    
}
