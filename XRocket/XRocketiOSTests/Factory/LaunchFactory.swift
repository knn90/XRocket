//
//  LaunchFactory.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 16/4/21.
//

import Foundation
import XRocket

class LaunchFactory {
    static func any(id: String = "any Id", name: String = "any name", flightNumber: Int = 1, success: Bool = true, dateUTC: Date = Date(timeIntervalSince1970: 1617813240), details: String = "", urls: [URL] = [], smallImageURL: URL = anyURL(), largeImageURL: URL = anyURL()) -> Launch {
        return Launch(
            id: id,
            name: name,
            flightNumber: flightNumber,
            success: success,
            dateUTC: dateUTC,
            details: details,
            links: Link(flickr: Flickr(original: urls), patch: Patch(small: smallImageURL, large: largeImageURL)),
            rocket: Rocket(id: "", name: ""))
    }
    
    static func emptyName() -> Launch {
        return Launch(id: "any Id", name: "", flightNumber: 3, success: true, dateUTC: Date(timeIntervalSince1970: 1617813240), details: "", links: Link(flickr: Flickr(original: [anyURL()]), patch: Patch(small: anyURL(), large: anyURL())), rocket: Rocket(id: "", name: ""))
    }
    
    static func launchFailed() -> Launch {
        return Launch(id: "any Id", name: "", flightNumber: 3, success: false, dateUTC: Date(timeIntervalSince1970: 1616574480), details: "", links: Link(flickr: Flickr(original: [anyURL()]), patch: Patch(small: anyURL(), large: anyURL())), rocket: Rocket(id: "", name: ""))
    }
    
    static func fullDetails() -> Launch {
        return Launch(id: "Id", name: "Starlink", flightNumber: 123, success: true, dateUTC: Date(timeIntervalSince1970: 1687357684), details: "This is the description of the lanch", links: Link(flickr: Flickr(original: []), patch: Patch(small: anyURL(), large: anyURL())), rocket: Rocket(id: "rocketId", name: "Falcon 11"))
    }
}
