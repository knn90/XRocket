//
//  PresentableLaunch.swift
//  XRocket
//
//  Created by Khoi Nguyen on 20/4/21.
//

import Foundation

public struct PresentableLaunch: Equatable {
    public init(id: String, name: String, flightNumber: String, status: String, launchDate: String, imageURL: URL?) {
        self.id = id
        self.name = name
        self.flightNumber = flightNumber
        self.status = status
        self.launchDate = launchDate
        self.imageURL = imageURL
    }
    
    public let id: String
    public let name: String
    public let flightNumber: String
    public let status: String
    public let launchDate: String
    public let imageURL: URL?
}
