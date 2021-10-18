//
//  Log.swift
//  Dummy
//
//  Created by Goldmedal on 17/09/21.
//

import Foundation
import os

private let subsystem = "com.test"

struct Log {
    static let networking = OSLog(subsystem: subsystem, category: "networking")
    static let table = OSLog(subsystem: subsystem, category: "table")
}
