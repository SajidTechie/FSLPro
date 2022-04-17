//
//  UserProfileData.swift
//  Dummy
//
//  Created by Goldmedal on 20/03/22.
//

import Foundation
struct UserProfileData : Codable {
    let dN : String?
    let fN : String?
    let lN : String?
    let mail : String?
    let mob : String?
    let gender : String?
    let dob : String?
    let addr : String?
    let city : String?
    let state : String?
    let pin : String?
    let country : String?

    enum CodingKeys: String, CodingKey {

        case dN = "DN"
        case fN = "FN"
        case lN = "LN"
        case mail = "mail"
        case mob = "mob"
        case gender = "gender"
        case dob = "dob"
        case addr = "addr"
        case city = "city"
        case state = "state"
        case pin = "pin"
        case country = "country"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dN = try values.decodeIfPresent(String.self, forKey: .dN)
        fN = try values.decodeIfPresent(String.self, forKey: .fN)
        lN = try values.decodeIfPresent(String.self, forKey: .lN)
        mail = try values.decodeIfPresent(String.self, forKey: .mail)
        mob = try values.decodeIfPresent(String.self, forKey: .mob)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        addr = try values.decodeIfPresent(String.self, forKey: .addr)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        pin = try values.decodeIfPresent(String.self, forKey: .pin)
        country = try values.decodeIfPresent(String.self, forKey: .country)
    }

    
    init(DN: String, FN: String, LN: String, mail: String, gender: String, MN: String, dob: String, addr: String, city: String, state: String, pin: String, country: String) {
           self.dN = DN
           self.fN = FN
           self.lN = LN
           self.mail = mail
           self.mob = MN
           self.gender = gender
           self.dob = dob
           self.addr = addr
           self.city = city
           self.state = state
           self.pin = pin
           self.country = country
       }
}

