//
//  Launch.swift
//  XRocket
//
//  Created by Khoi Nguyen on 16/4/21.
//

import Foundation

public struct Launch: Codable, Equatable, Hashable {
    public let id: String
    public let name: String
    public let flightNumber: Int
    public let success: Bool
    public let dateUnix: Date
    public let links: Link
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case flightNumber = "flight_number"
        case success = "success"
        case dateUnix = "date_unix"
        case links = "links"
    }
    
    public init(id: String, name: String, flightNumber: Int, success: Bool, dateUTC: Date, links: Link) {
        self.id = id
        self.name = name
        self.flightNumber = flightNumber
        self.success = success
        self.dateUnix = dateUTC
        self.links = links
    }
}


public struct Link: Codable, Equatable, Hashable {
    public let flickr: Flickr
    public let patch: Patch
    
    public init(flickr: Flickr, patch: Patch) {
        self.flickr = flickr
        self.patch = patch
    }
}

public struct Flickr: Codable, Equatable, Hashable {
    public init(original: [URL]) {
        self.original = original
    }
    
    public let original: [URL]
}

public struct Patch: Codable, Equatable, Hashable {
    public init(small: URL, large: URL) {
        self.small = small
        self.large = large
    }
    
    public let small: URL
    public let large: URL
}
