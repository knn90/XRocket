//
//  LaunchFactory.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 16/4/21.
//

import Foundation
import XRocket

class LaunchFactory {
    static func any() -> Launch {
        return Launch(id: "any Id", name: "any name", flightNumber: 3, success: true, dateUTC: Date(timeIntervalSince1970: 1617813240))
    }
    
    static func emptyName() -> Launch {
        return Launch(id: "any Id", name: "", flightNumber: 3, success: true, dateUTC: Date(timeIntervalSince1970: 1617813240))
    }
    
    static func launchFailed() -> Launch {
        return Launch(id: "any Id", name: "", flightNumber: 3, success: false, dateUTC: Date(timeIntervalSince1970: 1616574480))
    }
}
