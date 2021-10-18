//
//  CommonDelegate.swift
//  Dummy
//
//  Created by Goldmedal on 24/09/21.
//

import Foundation
@objc protocol CommonDelegate {
    @objc optional func getMatchId(mid: Int)
    @objc optional func updateDate(value: String, date: Date)
    @objc optional func updateValue(value: String,from: String)
    @objc optional func refreshApi()
    @objc optional func getLatLong(lat: String,long: String)
}
