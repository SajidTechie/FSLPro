//
//  GenderData.swift
//  Dummy
//
//  Created by Goldmedal on 20/03/22.
//

import Foundation
struct GenderData : Codable {
    var genderName : String?
    var genderAnnotation : String?
    
    enum CodingKeys: String, CodingKey {
        
        case genderName = "GenderName"
        case genderAnnotation = "GenderAnnotation"
    }
    
    
    init(genderName: String,genderAnnotation: String) {
        self.genderName = genderName
         self.genderAnnotation = genderAnnotation
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        genderName = try values.decodeIfPresent(String.self, forKey: .genderName)
        genderAnnotation = try values.decodeIfPresent(String.self, forKey: .genderAnnotation)
    }
    
}
