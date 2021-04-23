//
//  LaunchFactory.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 16/4/21.
//

import Foundation
import XRocket

class LaunchFactory {
    static func any(id: String = "any Id", name: String = "any name", flightNumber: Int = 1, success: Bool = true, dateUTC: Date = Date(timeIntervalSince1970: 1617813240), urls: [URL] = [], smallImageURL: URL = anyURL(), largeImageURL: URL = anyURL()) -> Launch {
        return Launch(
            id: id,
            name: name,
            flightNumber: flightNumber,
            success: success,
            dateUTC: dateUTC,
            links: Link(flickr: Flickr(original: urls), patch: Patch(small: smallImageURL, large: largeImageURL)))
    }
    
    static func emptyName() -> Launch {
        return Launch(id: "any Id", name: "", flightNumber: 3, success: true, dateUTC: Date(timeIntervalSince1970: 1617813240), links: Link(flickr: Flickr(original: [anyURL()]), patch: Patch(small: anyURL(), large: anyURL())))
    }
    
    static func launchFailed() -> Launch {
        return Launch(id: "any Id", name: "", flightNumber: 3, success: false, dateUTC: Date(timeIntervalSince1970: 1616574480), links: Link(flickr: Flickr(original: [anyURL()]), patch: Patch(small: anyURL(), large: anyURL())))
    }
}
