//
//  MatchInfoData.swift
//  Dummy
//
//  Created by Goldmedal on 22/09/21.
//

import Foundation
struct MatchData : Codable {
    
    let info : MatchInfo?
    let mID : Int?
    
    enum CodingKeys: String, CodingKey {
        case info = "Info"
        case mID = "MID"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        info = try values.decodeIfPresent(MatchInfo.self, forKey: .info)
        mID = try values.decodeIfPresent(Int.self, forKey: .mID)
    }
    
}


struct MatchInfo : Codable {
    
    let draw : String?
    let firstUmpire : MatchFirstUmpire?
    let followOn : Bool?
    let grp : String?
    let lt : MatchLt?
    let manOfMatch : String?
    let referee : MatchReferee?
    let res : String?
    let secondUmpire : MatchSecondUmpire?
    let st : String?
    let superOver : Bool?
    let toss : MatchToss?
    let tvUmpire : MatchTvUmpire?
    let ty : String?
    let utc : String?
    let venue : MatchVenue?
    let vt : MatchVt?
    let wt : String?
    
    enum CodingKeys: String, CodingKey {
        case draw = "draw"
        case firstUmpire = "first_umpire"
        case followOn = "follow_on"
        case grp = "grp"
        case lt = "lt"
        case manOfMatch = "man_of_match"
        case referee = "referee"
        case res = "res"
        case secondUmpire = "second_umpire"
        case st = "st"
        case superOver = "super_over"
        case toss = "toss"
        case tvUmpire = "tv_umpire"
        case ty = "ty"
        case utc = "utc"
        case venue = "venue"
        case vt = "vt"
        case wt = "wt"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        draw = try values.decodeIfPresent(String.self, forKey: .draw)
        firstUmpire = try values.decodeIfPresent(MatchFirstUmpire.self, forKey: .firstUmpire)
        followOn = try values.decodeIfPresent(Bool.self, forKey: .followOn)
        grp = try values.decodeIfPresent(String.self, forKey: .grp)
        lt = try values.decodeIfPresent(MatchLt.self, forKey: .lt)
        manOfMatch = try values.decodeIfPresent(String.self, forKey: .manOfMatch)
        referee = try values.decodeIfPresent(MatchReferee.self, forKey: .referee)
        res = try values.decodeIfPresent(String.self, forKey: .res)
        secondUmpire = try values.decodeIfPresent(MatchSecondUmpire.self, forKey: .secondUmpire)
        st = try values.decodeIfPresent(String.self, forKey: .st)
        superOver = try values.decodeIfPresent(Bool.self, forKey: .superOver)
        toss = try values.decodeIfPresent(MatchToss.self, forKey: .toss)
        tvUmpire = try values.decodeIfPresent(MatchTvUmpire.self, forKey: .tvUmpire)
        ty = try values.decodeIfPresent(String.self, forKey: .ty)
        utc = try values.decodeIfPresent(String.self, forKey: .utc)
        venue = try values.decodeIfPresent(MatchVenue.self, forKey: .venue)
        vt = try values.decodeIfPresent(MatchVt.self, forKey: .vt)
        wt = try values.decodeIfPresent(String.self, forKey: .wt)
    }
    
}


struct MatchVt : Codable {
    
    let name : String?
    let score : String?
    let bench : [String]?
    let playing : [String]?
    
    enum CodingKeys: String, CodingKey {
        case bench = "bench"
        case name = "name"
        case score = "score"
        case playing = "playing"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        score = try values.decodeIfPresent(String.self, forKey: .score)
        bench = try values.decodeIfPresent([String].self, forKey: .bench)
        playing = try values.decodeIfPresent([String].self, forKey: .playing)
    }
    
}


struct MatchVenue : Codable {
    
    let capacity : Int?
    let city : String?
    let country : String?
    let floodlight : Bool?
    let name : String?
    
    enum CodingKeys: String, CodingKey {
        case capacity = "capacity"
        case city = "city"
        case country = "country"
        case floodlight = "floodlight"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        capacity = try values.decodeIfPresent(Int.self, forKey: .capacity)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        floodlight = try values.decodeIfPresent(Bool.self, forKey: .floodlight)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
    
}


struct MatchTvUmpire : Codable {
    
    let dob : String?
    let fn : String?
    let full : String?
    let gen : String?
    let ln : String?
    
    enum CodingKeys: String, CodingKey {
        case dob = "dob"
        case fn = "fn"
        case full = "full"
        case gen = "gen"
        case ln = "ln"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        fn = try values.decodeIfPresent(String.self, forKey: .fn)
        full = try values.decodeIfPresent(String.self, forKey: .full)
        gen = try values.decodeIfPresent(String.self, forKey: .gen)
        ln = try values.decodeIfPresent(String.self, forKey: .ln)
    }
    
}


struct MatchToss : Codable {
    
    let elected : String?
    let team : String?
    
    enum CodingKeys: String, CodingKey {
        case elected = "elected"
        case team = "team"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        elected = try values.decodeIfPresent(String.self, forKey: .elected)
        team = try values.decodeIfPresent(String.self, forKey: .team)
    }
    
}


struct MatchSecondUmpire : Codable {
    
    let dob : String?
    let fn : String?
    let full : String?
    let gen : String?
    let ln : String?
    
    enum CodingKeys: String, CodingKey {
        case dob = "dob"
        case fn = "fn"
        case full = "full"
        case gen = "gen"
        case ln = "ln"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        fn = try values.decodeIfPresent(String.self, forKey: .fn)
        full = try values.decodeIfPresent(String.self, forKey: .full)
        gen = try values.decodeIfPresent(String.self, forKey: .gen)
        ln = try values.decodeIfPresent(String.self, forKey: .ln)
    }
    
}


struct MatchReferee : Codable {
    
    let dob : String?
    let fn : String?
    let full : String?
    let gen : String?
    let ln : String?
    
    enum CodingKeys: String, CodingKey {
        case dob = "dob"
        case fn = "fn"
        case full = "full"
        case gen = "gen"
        case ln = "ln"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        fn = try values.decodeIfPresent(String.self, forKey: .fn)
        full = try values.decodeIfPresent(String.self, forKey: .full)
        gen = try values.decodeIfPresent(String.self, forKey: .gen)
        ln = try values.decodeIfPresent(String.self, forKey: .ln)
    }
    
}


struct MatchLt : Codable {
    
    let name : String?
    let score : String?
    let bench : [String]?
    let playing : [String]?
    
    enum CodingKeys: String, CodingKey {
        case bench = "bench"
        case name = "name"
        case score = "score"
        case playing = "playing"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        score = try values.decodeIfPresent(String.self, forKey: .score)
        bench = try values.decodeIfPresent([String].self, forKey: .bench)
        playing = try values.decodeIfPresent([String].self, forKey: .playing)
    }
    
}


struct MatchFirstUmpire : Codable {
    
    let dob : String?
    let fn : String?
    let full : String?
    let gen : String?
    let ln : String?
    
    enum CodingKeys: String, CodingKey {
        case dob = "dob"
        case fn = "fn"
        case full = "full"
        case gen = "gen"
        case ln = "ln"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        fn = try values.decodeIfPresent(String.self, forKey: .fn)
        full = try values.decodeIfPresent(String.self, forKey: .full)
        gen = try values.decodeIfPresent(String.self, forKey: .gen)
        ln = try values.decodeIfPresent(String.self, forKey: .ln)
    }
    
}
