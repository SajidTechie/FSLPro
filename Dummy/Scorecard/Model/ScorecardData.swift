//
//  ScorecardData.swift
//  Dummy
//
//  Created by Goldmedal on 18/09/21.
//

import Foundation
struct ScorecardMain : Codable {
    let info : MatchInfo?
 //   let info : ScorecardInfo?
    let mID : Int?
    let score : [ScorecardScore]?
    
    enum CodingKeys: String, CodingKey {
        case info = "Info"
        case mID = "MID"
        case score = "Score"
    }
}

struct ScorecardScore : Codable {
    
    let bat : [ScorecardBat]?
    let bol : [ScorecardBol]?
    let innings : String?
    let overs : Double?
    let total : Int?
    let wickets : Int?
    let xtra : ScorecardXtra?
    
    enum CodingKeys: String, CodingKey {
        case bat = "bat"
        case bol = "bol"
        case innings = "innings"
        case overs = "overs"
        case total = "total"
        case wickets = "wickets"
        case xtra = "xtra"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bat = try values.decodeIfPresent([ScorecardBat].self, forKey: .bat)
        bol = try values.decodeIfPresent([ScorecardBol].self, forKey: .bol)
        innings = try values.decodeIfPresent(String.self, forKey: .innings)
        overs = try values.decodeIfPresent(Double.self, forKey: .overs)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        wickets = try values.decodeIfPresent(Int.self, forKey: .wickets)
        xtra = try values.decodeIfPresent(ScorecardXtra.self, forKey: .xtra)
    }
    
}


//struct ScorecardInfo : Codable {
//
//    let draw : String?
//    let firstUmpire : ScorecardFirstUmpire?
//    let followOn : Bool?
//    let grp : String?
//    let lt : ScorecardLt?
//    let manOfMatch : String?
//    let referee : ScorecardReferee?
//    let res : String?
//    let secondUmpire : ScorecardSecondUmpire?
//    let st : String?
//    let superOver : Bool?
//    let toss : ScorecardToss?
//    let tvUmpire : ScorecardTvUmpire?
//    let ty : String?
//    let utc : String?
//    let venue : ScorecardVenue?
//    let vt : ScorecardVt?
//    let wt : String?
//
//    enum CodingKeys: String, CodingKey {
//        case draw = "draw"
//        case firstUmpire = "first_umpire"
//        case followOn = "follow_on"
//        case grp = "grp"
//        case lt = "lt"
//        case manOfMatch = "man_of_match"
//        case referee = "referee"
//        case res = "res"
//        case secondUmpire = "second_umpire"
//        case st = "st"
//        case superOver = "super_over"
//        case toss = "toss"
//        case tvUmpire = "tv_umpire"
//        case ty = "ty"
//        case utc = "utc"
//        case venue = "venue"
//        case vt = "vt"
//        case wt = "wt"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        draw = try values.decodeIfPresent(String.self, forKey: .draw)
//        firstUmpire = try values.decodeIfPresent(ScorecardFirstUmpire.self, forKey: .firstUmpire)
//        followOn = try values.decodeIfPresent(Bool.self, forKey: .followOn)
//        grp = try values.decodeIfPresent(String.self, forKey: .grp)
//        lt = try values.decodeIfPresent(ScorecardLt.self, forKey: .lt)
//        manOfMatch = try values.decodeIfPresent(String.self, forKey: .manOfMatch)
//        referee = try values.decodeIfPresent(ScorecardReferee.self, forKey: .referee)
//        res = try values.decodeIfPresent(String.self, forKey: .res)
//        secondUmpire = try ScorecardSecondUmpire(from: decoder)
//        st = try values.decodeIfPresent(String.self, forKey: .st)
//        superOver = try values.decodeIfPresent(Bool.self, forKey: .superOver)
//        toss = try values.decodeIfPresent(ScorecardToss.self, forKey: .toss)
//        tvUmpire = try values.decodeIfPresent(ScorecardTvUmpire.self, forKey: .tvUmpire)
//        ty = try values.decodeIfPresent(String.self, forKey: .ty)
//        utc = try values.decodeIfPresent(String.self, forKey: .utc)
//        venue = try values.decodeIfPresent(ScorecardVenue.self, forKey: .venue)
//        vt = try values.decodeIfPresent(ScorecardVt.self, forKey: .vt)
//        wt = try values.decodeIfPresent(String.self, forKey: .wt)
//    }
//
//}



struct ScorecardXtra : Codable {
    
    let bye : Int?
    let legBye : Int?
    let noballBalls : Int?
    let noballRuns : Int?
    let penalty : Int?
    let wide : Int?
    
    enum CodingKeys: String, CodingKey {
        case bye = "bye"
        case legBye = "leg_bye"
        case noballBalls = "noball_balls"
        case noballRuns = "noball_runs"
        case penalty = "penalty"
        case wide = "wide"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bye = try values.decodeIfPresent(Int.self, forKey: .bye)
        legBye = try values.decodeIfPresent(Int.self, forKey: .legBye)
        noballBalls = try values.decodeIfPresent(Int.self, forKey: .noballBalls)
        noballRuns = try values.decodeIfPresent(Int.self, forKey: .noballRuns)
        penalty = try values.decodeIfPresent(Int.self, forKey: .penalty)
        wide = try values.decodeIfPresent(Int.self, forKey: .wide)
    }
    
}


struct ScorecardBol : Codable {
    
    let active : Bool?
    let fn : String?
    let medians : Int?
    let noball : Int?
    let note : String?
    let order : Int?
    let overs : String?
    let rate : Double?
    let runs : Int?
    let t : String?
    let wickets : Int?
    let wide : Int?
    
    enum CodingKeys: String, CodingKey {
        case active = "active"
        case fn = "fn"
        case medians = "medians"
        case noball = "noball"
        case note = "note"
        case order = "order"
        case overs = "overs"
        case rate = "rate"
        case runs = "runs"
        case t = "t"
        case wickets = "wickets"
        case wide = "wide"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        fn = try values.decodeIfPresent(String.self, forKey: .fn)
        medians = try values.decodeIfPresent(Int.self, forKey: .medians)
        noball = try values.decodeIfPresent(Int.self, forKey: .noball)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        order = try values.decodeIfPresent(Int.self, forKey: .order)
        overs = try values.decodeIfPresent(String.self, forKey: .overs)
        rate = try values.decodeIfPresent(Double.self, forKey: .rate)
        runs = try values.decodeIfPresent(Int.self, forKey: .runs)
        t = try values.decodeIfPresent(String.self, forKey: .t)
        wickets = try values.decodeIfPresent(Int.self, forKey: .wickets)
        wide = try values.decodeIfPresent(Int.self, forKey: .wide)
    }
    
}


struct ScorecardBat : Codable {
    
    let active : Bool?
    let ball : Int?
    let batsmanout : String?
    let bowlingPlayer : String?
    let catchStumpPlayer : String?
    let fn : String?
    let four : Int?
    let fowBalls : Double?
    let fowScore : Int?
    let note : String?
    let order : Int?
    let out : Bool?
    let rate : Double?
    let runout : String?
    let score : Int?
    let six : Int?
    let t : String?
    
    enum CodingKeys: String, CodingKey {
        case active = "active"
        case ball = "ball"
        case batsmanout = "batsmanout"
        case bowlingPlayer = "bowling_player"
        case catchStumpPlayer = "catch_stump_player"
        case fn = "fn"
        case four = "four"
        case fowBalls = "fow_balls"
        case fowScore = "fow_score"
        case note = "note"
        case order = "order"
        case out = "out"
        case rate = "rate"
        case runout = "runout"
        case score = "score"
        case six = "six"
        case t = "t"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        ball = try values.decodeIfPresent(Int.self, forKey: .ball)
        batsmanout = try values.decodeIfPresent(String.self, forKey: .batsmanout)
        bowlingPlayer = try values.decodeIfPresent(String.self, forKey: .bowlingPlayer)
        catchStumpPlayer = try values.decodeIfPresent(String.self, forKey: .catchStumpPlayer)
        fn = try values.decodeIfPresent(String.self, forKey: .fn)
        four = try values.decodeIfPresent(Int.self, forKey: .four)
        fowBalls = try values.decodeIfPresent(Double.self, forKey: .fowBalls)
        fowScore = try values.decodeIfPresent(Int.self, forKey: .fowScore)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        order = try values.decodeIfPresent(Int.self, forKey: .order)
        out = try values.decodeIfPresent(Bool.self, forKey: .out)
        rate = try values.decodeIfPresent(Double.self, forKey: .rate)
        runout = try values.decodeIfPresent(String.self, forKey: .runout)
        score = try values.decodeIfPresent(Int.self, forKey: .score)
        six = try values.decodeIfPresent(Int.self, forKey: .six)
        t = try values.decodeIfPresent(String.self, forKey: .t)
    }
    
}


//struct ScorecardLt : Codable {
//
//    let name : String?
//    let score : String?
//
//    enum CodingKeys: String, CodingKey {
//        case name = "name"
//        case score = "score"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        score = try values.decodeIfPresent(String.self, forKey: .score)
//    }
//
//}
//
//
//
//struct ScorecardVt : Codable {
//
//    let name : String?
//    let score : String?
//
//    enum CodingKeys: String, CodingKey {
//        case name = "name"
//        case score = "score"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        score = try values.decodeIfPresent(String.self, forKey: .score)
//    }
//
//}
//
//
//
//struct ScorecardVenue : Codable {
//
//    let capacity : Int?
//    let city : String?
//    let country : String?
//    let floodlight : Bool?
//    let name : String?
//
//    enum CodingKeys: String, CodingKey {
//        case capacity = "capacity"
//        case city = "city"
//        case country = "country"
//        case floodlight = "floodlight"
//        case name = "name"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        capacity = try values.decodeIfPresent(Int.self, forKey: .capacity)
//        city = try values.decodeIfPresent(String.self, forKey: .city)
//        country = try values.decodeIfPresent(String.self, forKey: .country)
//        floodlight = try values.decodeIfPresent(Bool.self, forKey: .floodlight)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//    }
//
//}
//
//
//struct ScorecardTvUmpire : Codable {
//
//    let dob : String?
//    let fn : String?
//    let full : String?
//    let gen : String?
//    let ln : String?
//
//    enum CodingKeys: String, CodingKey {
//        case dob = "dob"
//        case fn = "fn"
//        case full = "full"
//        case gen = "gen"
//        case ln = "ln"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        dob = try values.decodeIfPresent(String.self, forKey: .dob)
//        fn = try values.decodeIfPresent(String.self, forKey: .fn)
//        full = try values.decodeIfPresent(String.self, forKey: .full)
//        gen = try values.decodeIfPresent(String.self, forKey: .gen)
//        ln = try values.decodeIfPresent(String.self, forKey: .ln)
//    }
//
//}
//
//
//struct ScorecardToss : Codable {
//
//    let elected : String?
//    let team : String?
//
//    enum CodingKeys: String, CodingKey {
//        case elected = "elected"
//        case team = "team"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        elected = try values.decodeIfPresent(String.self, forKey: .elected)
//        team = try values.decodeIfPresent(String.self, forKey: .team)
//    }
//
//}
//
//
//
//struct ScorecardSecondUmpire : Codable {
//
//    let dob : String?
//    let fn : String?
//    let full : String?
//    let gen : String?
//    let ln : String?
//
//    enum CodingKeys: String, CodingKey {
//        case dob = "dob"
//        case fn = "fn"
//        case full = "full"
//        case gen = "gen"
//        case ln = "ln"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        dob = try values.decodeIfPresent(String.self, forKey: .dob)
//        fn = try values.decodeIfPresent(String.self, forKey: .fn)
//        full = try values.decodeIfPresent(String.self, forKey: .full)
//        gen = try values.decodeIfPresent(String.self, forKey: .gen)
//        ln = try values.decodeIfPresent(String.self, forKey: .ln)
//    }
//
//}
//
//
//
//struct ScorecardReferee : Codable {
//
//    let dob : String?
//    let fn : String?
//    let full : String?
//    let gen : String?
//    let ln : String?
//
//    enum CodingKeys: String, CodingKey {
//        case dob = "dob"
//        case fn = "fn"
//        case full = "full"
//        case gen = "gen"
//        case ln = "ln"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        dob = try values.decodeIfPresent(String.self, forKey: .dob)
//        fn = try values.decodeIfPresent(String.self, forKey: .fn)
//        full = try values.decodeIfPresent(String.self, forKey: .full)
//        gen = try values.decodeIfPresent(String.self, forKey: .gen)
//        ln = try values.decodeIfPresent(String.self, forKey: .ln)
//    }
//
//}
//
//
//
//struct ScorecardFirstUmpire : Codable {
//
//    let dob : String?
//    let fn : String?
//    let full : String?
//    let gen : String?
//    let ln : String?
//
//    enum CodingKeys: String, CodingKey {
//        case dob = "dob"
//        case fn = "fn"
//        case full = "full"
//        case gen = "gen"
//        case ln = "ln"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        dob = try values.decodeIfPresent(String.self, forKey: .dob)
//        fn = try values.decodeIfPresent(String.self, forKey: .fn)
//        full = try values.decodeIfPresent(String.self, forKey: .full)
//        gen = try values.decodeIfPresent(String.self, forKey: .gen)
//        ln = try values.decodeIfPresent(String.self, forKey: .ln)
//    }
//
//}
