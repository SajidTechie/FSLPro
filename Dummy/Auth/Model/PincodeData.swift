//
//  PincodeData.swift
//  Dummy
//
//  Created by Goldmedal on 20/03/22.
//

import Foundation

struct PincodeData : Codable {
    let state : String?
    let district : String?
    let city : String?
    let pincode : Int?
    let country : String?

    enum CodingKeys: String, CodingKey {

        case state = "State"
        case district = "District"
        case city = "City"
        case pincode = "Pincode"
        case country = "country"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        district = try values.decodeIfPresent(String.self, forKey: .district)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        pincode = try values.decodeIfPresent(Int.self, forKey: .pincode)
        country = try values.decodeIfPresent(String.self, forKey: .country)
    }

}

