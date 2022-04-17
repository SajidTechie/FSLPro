//
//  InitialData.swift
//  Dummy
//
//  Created by Goldmedal on 23/03/22.
//

import Foundation

struct InitialData : Codable {
    
    let android : Double?
    let ios : Double?
    
    enum CodingKeys: String, CodingKey {
        case android = "andriod"
        case ios = "ios"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        android = try values.decodeIfPresent(Double.self, forKey: .android)
        ios = try values.decodeIfPresent(Double.self, forKey: .ios)
    }
    
}
