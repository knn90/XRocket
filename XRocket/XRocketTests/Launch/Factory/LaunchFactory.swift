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
        return Launch(id: "any Id", name: "any name", details: "any details")
    }
    
    static func emptyName() -> Launch {
        return Launch(id: "any Id", name: "", details: "any details")
    }
    
    static func emptyDetails() -> Launch {
        return Launch(id: "any Id", name: "name", details: "")
    }
}
