//
//  SendSms.swift
//  Dummy
//
//  Created by Goldmedal on 10/11/21.
//

import Foundation

struct SmsData : Codable {

        let cc : String?
        let dm : String?
        let em : String?
        let eot : String?
        let error : String?
        let it : Bool?
        let l : String?
        let os : String?
        let r : Bool?
        let s : String?
        let status : String?
        let t : Int?
        let un : String?

        enum CodingKeys: String, CodingKey {
                case cc = "cc"
                case dm = "dm"
                case em = "em"
                case eot = "eot"
                case error = "error"
                case it = "it"
                case l = "l"
                case os = "os"
                case r = "r"
                case s = "s"
                case status = "status"
                case t = "t"
                case un = "un"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                cc = try values.decodeIfPresent(String.self, forKey: .cc)
                dm = try values.decodeIfPresent(String.self, forKey: .dm)
                em = try values.decodeIfPresent(String.self, forKey: .em)
                eot = try values.decodeIfPresent(String.self, forKey: .eot)
                error = try values.decodeIfPresent(String.self, forKey: .error)
                it = try values.decodeIfPresent(Bool.self, forKey: .it)
                l = try values.decodeIfPresent(String.self, forKey: .l)
                os = try values.decodeIfPresent(String.self, forKey: .os)
                r = try values.decodeIfPresent(Bool.self, forKey: .r)
                s = try values.decodeIfPresent(String.self, forKey: .s)
                status = try values.decodeIfPresent(String.self, forKey: .status)
                t = try values.decodeIfPresent(Int.self, forKey: .t)
                un = try values.decodeIfPresent(String.self, forKey: .un)
        }

}

