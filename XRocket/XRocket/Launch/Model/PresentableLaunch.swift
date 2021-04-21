//
//  PresentableLaunch.swift
//  XRocket
//
//  Created by Khoi Nguyen on 20/4/21.
//

import Foundation

public struct PresentableLaunch: Equatable {
    public let id: String
    public let name: String
    public let flightNumber: String
    public let status: String
    public let launchDate: String
    public let imageURL: URL?
}
