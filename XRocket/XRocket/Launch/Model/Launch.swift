//
//  Launch.swift
//  XRocket
//
//  Created by Khoi Nguyen on 16/4/21.
//

import Foundation

public struct Launch: Codable, Equatable {
    let id: String
    let name: String
    let flightNumber: Int
    let success: Bool
    let dateUTC: Date
    
    public init(id: String, name: String, flightNumber: Int, success: Bool, dateUTC: Date) {
        self.id = id
        self.name = name
        self.flightNumber = flightNumber
        self.success = success
        self.dateUTC = dateUTC
    }
}
