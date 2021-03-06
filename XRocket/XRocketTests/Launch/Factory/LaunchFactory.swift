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
        return Launch(id: "any Id", name: "any name", flightNumber: 3, success: true, dateUTC: Date(timeIntervalSince1970: 1617813240), details: "", links: Link(flickr: Flickr(original: [anyURL()]), patch: Patch(small: anyURL(), large: anyURL())), rocket: Rocket(id: "", name: ""))
    }
    
    static func emptyName() -> Launch {
        return Launch(id: "any Id", name: "", flightNumber: 3, success: true, dateUTC: Date(timeIntervalSince1970: 1617813240), details: "", links: Link(flickr: Flickr(original: [anyURL()]), patch: Patch(small: anyURL(), large: anyURL())), rocket: Rocket(id: "", name: ""))
    }
    
    static func launchFailed() -> Launch {
        return Launch(id: "any Id", name: "", flightNumber: 3, success: false, dateUTC: Date(timeIntervalSince1970: 1616574480), details: "", links: Link(flickr: Flickr(original: [anyURL()]), patch: Patch(small: anyURL(), large: anyURL())), rocket: Rocket(id: "", name: ""))
    }
}
